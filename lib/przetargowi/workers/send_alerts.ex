defmodule Przetargowi.Workers.SendAlerts do
  @moduledoc """
  Oban worker that sends alert emails to users with matching tender notices.
  """
  use Oban.Worker,
    queue: :alerts,
    max_attempts: 3,
    unique: [period: 3600]

  import Ecto.Query

  alias Przetargowi.Accounts.User
  alias Przetargowi.Alerts.Alert
  alias Przetargowi.Alerts.AlertEmail
  alias Przetargowi.Mailer
  alias Przetargowi.Repo
  alias Przetargowi.Tenders.TenderNotice

  require Logger

  @impl Oban.Worker
  def perform(_) do
    alerts =
      Alert
      |> from(as: :alert)
      |> join(:inner, [alert: a], u in User, on: a.user_id == u.id, as: :user)
      |> where([user: u], not is_nil(u.confirmed_at))
      |> select([alert: a, user: u], %{email: u.email, rules: a.rules})
      |> Repo.all()

    Enum.each(alerts, fn alert ->
      send_alert_email(alert)
    end)

    :ok
  end

  defp send_alert_email(%{
         email: email,
         rules: %{"region" => region, "tender_category" => tender_category} = rules
       }) do
    Logger.info("Processing alert for #{email} with rules: #{inspect(rules)}")

    notices = fetch_matching_notices(region, tender_category)

    if Enum.empty?(notices) do
      Logger.info("No matching notices for #{email}, skipping email")
    else
      Logger.info("Found #{length(notices)} notices for #{email}, sending email")

      email
      |> AlertEmail.compose(notices, category_label(tender_category))
      |> Mailer.deliver()
      |> case do
        {:ok, _} ->
          Logger.info("Alert email sent successfully to #{email}")

        {:error, reason} ->
          Logger.error("Failed to send alert email to #{email}: #{inspect(reason)}")
      end
    end
  end

  defp send_alert_email(%{email: email, rules: rules}) do
    Logger.warning("Skipping alert for #{email} - unsupported rules format: #{inspect(rules)}")
  end

  defp fetch_matching_notices(region, tender_category) do
    province_code = region_to_province_code(region)
    order_type = to_order_type(tender_category)

    TenderNotice
    |> from(as: :tender_notice)
    |> where(
      [tender_notice: tn],
      tn.notice_type == "ContractNotice" and
        tn.submitting_offers_date >= ^DateTime.utc_now()
    )
    |> filter_by_province(province_code)
    |> filter_by_order_type(order_type)
    |> select([tender_notice: tn], tn)
    |> order_by([tender_notice: tn], asc: tn.submitting_offers_date)
    |> limit(10)
    |> Repo.all()
  end

  defp filter_by_province(query, nil), do: query

  defp filter_by_province(query, province_code) do
    where(query, [tender_notice: tn], tn.organization_province == ^province_code)
  end

  defp filter_by_order_type(query, nil), do: query

  defp filter_by_order_type(query, order_type) do
    where(query, [tender_notice: tn], tn.order_type == ^order_type)
  end

  # The alert form submits the order_type code ("Delivery"/"Services"/"Works"),
  # which the controller stores verbatim in the rules. Legacy alerts may hold the
  # Polish label instead, so accept both. Anything else (incl. nil) applies no filter.
  defp to_order_type(tender_category) do
    case tender_category do
      code when code in ["Delivery", "Services", "Works"] -> code
      "Dostawy" -> "Delivery"
      "Usługi" -> "Services"
      "Roboty budowlane" -> "Works"
      _ -> nil
    end
  end

  # Human-readable Polish label for the email subject/body.
  defp category_label(tender_category) do
    case to_order_type(tender_category) do
      "Delivery" -> "Dostawy"
      "Services" -> "Usługi"
      "Works" -> "Roboty budowlane"
      _ -> "wybrane kategorie"
    end
  end

  defp region_to_province_code(region) do
    case region do
      "dolnoslaskie" -> "PL02"
      "kujawsko-pomorskie" -> "PL04"
      "lubelskie" -> "PL06"
      "lubuskie" -> "PL08"
      "lodzkie" -> "PL10"
      "malopolskie" -> "PL12"
      "mazowieckie" -> "PL14"
      "opolskie" -> "PL16"
      "podkarpackie" -> "PL18"
      "podlaskie" -> "PL20"
      "pomorskie" -> "PL22"
      "slaskie" -> "PL24"
      "swietokrzyskie" -> "PL26"
      "warminsko-mazurskie" -> "PL28"
      "wielkopolskie" -> "PL30"
      "zachodniopomorskie" -> "PL32"
      _ -> nil
    end
  end
end
