defmodule Przetargowi.Bzp.Client do
  @moduledoc """
  Client for fetching tenders from the BZP API (ezamowienia.gov.pl).

  ## Usage

      BzpClient.fetch_tenders_notices()
      BzpClient.fetch_tenders_notices(cpv_code: "45000000-7", notice_type: "ContractNotice")
      BzpClient.fetch_all_recent(days: 7)
  """

  require Logger

  alias Przetargowi.Tenders.TenderNoticeParser

  @base_url "https://ezamowienia.gov.pl/mo-board/api/v1/notice"
  @documents_url "https://ezamowienia.gov.pl/mp-readmodels/api/Search/GetTenderDocuments"
  @default_page_size 100
  @timeout 30_000
  @retry_attempts 3
  @retry_delay 1_000

  @doc """
  Fetches tenders notices published between the given dates.

  ## Options
  - `:object_id` - specific tender notice ID to fetch
  - `:publication_date_from` - date from (YYYY-MM-DD)
  - `:publication_date_to` - date to (YYYY-MM-DD)
  - `:notice_type` - type of notice to fetch (e.g., "TenderResultNotice")
  """
  def fetch_tenders_notices(object_id, publication_date_from, publication_date_to, notice_type) do
    params =
      build_query_params(object_id, publication_date_from, publication_date_to, notice_type)

    Logger.info(
      "BZP API: Fetching tenders notices from #{publication_date_from} to #{publication_date_to} from object_id #{inspect(object_id)} with notice_type #{inspect(notice_type)}"
    )

    case make_request_with_retry(params) do
      {:ok, response} -> parse_response(response, 0)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Fetches all pages up to the limit.
  """
  def fetch_all_tender_notices(publication_date_from, publication_date_to, notice_type) do
    fetch_all_tender_notices(nil, publication_date_from, publication_date_to, notice_type, [])
  end

  defp fetch_all_tender_notices(
         object_id,
         publication_date_from,
         publication_date_to,
         notice_type,
         acc
       ) do
    case fetch_tenders_notices(object_id, publication_date_from, publication_date_to, notice_type) do
      {:ok, %{tenders: []}} ->
        Logger.info("BZP API: No more results.")
        {:ok, acc}

      {:ok, %{tenders: tenders}} ->
        Logger.info("BZP API: Got #{length(tenders)} tenders")
        # Rate limiting
        Process.sleep(500)
        last_tender = List.last(tenders)
        next_object_id = last_tender.object_id

        fetch_all_tender_notices(
          next_object_id,
          publication_date_from,
          publication_date_to,
          notice_type,
          acc ++ tenders
        )

      {:error, reason} ->
        Logger.error("BZP API: Error: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp build_query_params(object_id, publication_date_from, publication_date_to, notice_type) do
    maybe_add(
      %{
        "PageSize" => @default_page_size,
        "PublicationDateFrom" => publication_date_from,
        "PublicationDateTo" => publication_date_to,
        "NoticeType" => notice_type
      },
      "SearchAfter",
      object_id
    )
  end

  defp maybe_add(map, _key, nil), do: map
  defp maybe_add(map, key, value), do: Map.put(map, key, value)

  # Private: HTTP request with retry

  defp make_request_with_retry(params, attempt \\ 1) do
    case make_request(params) do
      {:ok, %{status: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %{status: status, body: error_body}} ->
        Logger.warning("BZP API: Status #{status}, body: #{inspect(error_body)}")
        maybe_retry({:error, {:http_error, status}}, params, attempt)

      {:error, reason} ->
        Logger.warning("BZP API: Request failed: #{inspect(reason)}")
        maybe_retry({:error, reason}, params, attempt)
    end
  end

  defp make_request(params) do
    # Note: Using verify: :verify_none due to BZP server certificate having
    # key_usage_mismatch (keyCertSign/cRLSign used for TLS). This is a server-side
    # misconfiguration that we cannot fix. The connection is still encrypted.
    Req.get(@base_url,
      params: params,
      headers: [
        {"Accept", "application/json"},
        {"User-Agent", "Przetargowi/1.0"}
      ],
      receive_timeout: @timeout,
      connect_options: [
        transport_opts: [
          verify: :verify_none
        ]
      ]
    )
  end

  defp maybe_retry(_error, params, attempt) when attempt < @retry_attempts do
    delay = @retry_delay * attempt
    Logger.info("BZP API: Retrying in #{delay}ms (attempt #{attempt + 1}/#{@retry_attempts})")
    Process.sleep(delay)
    make_request_with_retry(params, attempt + 1)
  end

  defp maybe_retry(error, _params, _attempt), do: error

  # Private: Response parsing

  # API returns a list directly
  defp parse_response(body, page) when is_list(body) do
    tenders = Enum.map(body, &parse_tender/1)

    {:ok,
     %{
       tenders: tenders,
       total: length(tenders),
       page: page
     }}
  end

  defp parse_response(body, page) when is_map(body) do
    tenders =
      body
      |> Map.get("notices", [])
      |> Enum.map(&parse_tender/1)

    {:ok,
     %{
       tenders: tenders,
       total: Map.get(body, "totalCount", length(tenders)),
       page: page
     }}
  end

  defp parse_response(body, page) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, decoded} -> parse_response(decoded, page)
      {:error, _} -> {:error, :invalid_json}
    end
  end

  defp parse_tender(raw) do
    %{
      estimated_values: estimated_values,
      estimated_value: estimated_value,
      total_contract_value: total_contract_value,
      total_contractors_contracts_count: total_contractors_contracts_count,
      cancelled_count: cancelled_count,
      contractors_contract_details: contractors_contract_details
    } = TenderNoticeParser.parse_contract(raw)

    %{
      client_type: sanitize_html(raw["clientType"]),
      order_type: sanitize_html(raw["orderType"]),
      tender_type: sanitize_html(raw["tenderType"]),
      notice_type: sanitize_html(raw["noticeType"]),
      notice_number: sanitize_html(raw["noticeNumber"]),
      bzp_number: sanitize_html(raw["bzpNumber"]),
      is_tender_amount_below_eu: raw["isTenderAmountBelowEU"],
      publication_date: raw["publicationDate"],
      order_object: sanitize_html(raw["orderObject"]),
      cpv_codes: raw["cpvCode"] |> String.split(",") |> Enum.map(&sanitize_html/1),
      submitting_offers_date: raw["submittingOffersDate"],
      procedure_result: sanitize_html(raw["procedureResult"]),
      organization_name: sanitize_html(raw["organizationName"]),
      organization_city: sanitize_html(raw["organizationCity"]),
      organization_province: sanitize_html(raw["organizationProvince"]),
      organization_country: sanitize_html(raw["organizationCountry"]),
      organization_national_id: sanitize_html(raw["organizationNationalId"]),
      organization_id: raw["organizationId"],
      tender_id: raw["tenderId"],
      html_body: sanitize_html(raw["htmlBody"]),
      contractors:
        Enum.map(raw["contractors"] || [], fn contractor ->
          %{
            contractor_name: sanitize_html(contractor["contractorName"]),
            contractor_city: sanitize_html(contractor["contractorCity"]),
            contractor_province: sanitize_html(contractor["contractorProvince"]),
            contractor_country: sanitize_html(contractor["contractorCountry"]),
            contractor_national_id: sanitize_html(contractor["contractorNationalId"])
          }
        end),
      object_id: raw["objectId"],
      estimated_values: estimated_values,
      estimated_value: estimated_value,
      total_contract_value: total_contract_value,
      total_contractors_contracts_count: total_contractors_contracts_count,
      cancelled_count: cancelled_count,
      contractors_contract_details: contractors_contract_details
    }
  end

  def sanitize_html(nil), do: nil

  def sanitize_html(html) when is_binary(html) do
    html
    # Escaped null bytes
    |> String.replace(~r/\\u0000/, "")
    # Raw null bytes
    |> String.replace(<<0>>, "")
    # Another form
    |> String.replace(<<0x00>>, "")
  end

  # Document fetching

  @doc """
  Fetches documents for a tender by its tender_id.

  ## Example

      BzpClient.fetch_tender_documents("ocds-148610-f17cf8c0-3ddf-4a06-b833-ae35139671e8")
  """
  def fetch_tender_documents(tender_id) do
    Logger.info("BZP API: Fetching documents for tender #{tender_id}")

    case make_documents_request(tender_id) do
      {:ok, documents} -> {:ok, parse_documents(documents, tender_id)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_documents_request(tender_id, attempt \\ 1) do
    case Req.get(@documents_url,
           params: %{"tenderId" => tender_id},
           headers: [
             {"Accept", "application/json"},
             {"User-Agent", "Przetargowi/1.0"}
           ],
           receive_timeout: @timeout,
           connect_options: [
             transport_opts: [
               verify: :verify_none
             ]
           ]
         ) do
      {:ok, %{status: 200, body: body}} when is_list(body) ->
        {:ok, body}

      {:ok, %{status: 200, body: body}} when is_binary(body) ->
        case Jason.decode(body) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, _} -> {:error, :invalid_json}
        end

      {:ok, %{status: status, body: error_body}} ->
        Logger.warning("Documents API: Status #{status}, body: #{inspect(error_body)}")

        if attempt < @retry_attempts do
          Process.sleep(@retry_delay * attempt)
          make_documents_request(tender_id, attempt + 1)
        else
          {:error, {:http_error, status}}
        end

      {:error, reason} ->
        Logger.warning("Documents API: Request failed: #{inspect(reason)}")

        if attempt < @retry_attempts do
          Process.sleep(@retry_delay * attempt)
          make_documents_request(tender_id, attempt + 1)
        else
          {:error, reason}
        end
    end
  end

  defp parse_documents(documents, tender_id) when is_list(documents) do
    Enum.map(documents, fn doc ->
      %{
        object_id: doc["objectId"],
        tender_id: tender_id,
        name: sanitize_html(doc["name"]),
        file_name: sanitize_html(doc["fileName"]),
        url: doc["url"],
        state: doc["tenderDocumentState"],
        create_date: doc["createDate"],
        published_date: doc["publishedDate"],
        delete_date: doc["deleteDate"],
        delete_reason: sanitize_html(doc["deleteReason"])
      }
    end)
  end

  defp parse_documents(_, _), do: []
end
