defmodule PrzetargowiWeb.JudgementController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Judgements
  alias Przetargowi.Judgements.Judgement
  alias Przetargowi.Judgements.Summary
  alias Przetargowi.Judgements.Topics

  @base_url "https://przetargowi.pl"
  @meta_description_length 155

  @doc """
  Old `/orzeczenie/:slug` URLs: permanent redirect to the ruling's canonical
  URL under `/orzecznictwo-kio/`, or 404 when the ruling does not exist.
  """
  def legacy(conn, %{"slug" => slug}) do
    case Judgements.get_judgement(slug) do
      nil ->
        not_found(conn)

      judgement ->
        conn
        |> put_status(:moved_permanently)
        |> redirect(to: "/orzecznictwo-kio/#{judgement.slug || judgement.id}")
    end
  end

  @doc """
  Renders a ruling. Reached through `LandingController.topic/2`, which owns the
  shared `/orzecznictwo-kio/:slug` route.
  """
  def show(conn, %{"slug" => slug}) do
    case Judgements.get_judgement(slug) do
      # A real 404 — redirecting unknown rulings to the search page made
      # Google treat every dead URL as a soft 404.
      nil ->
        not_found(conn)

      judgement when judgement.slug != nil and judgement.slug != slug ->
        conn
        |> put_status(301)
        |> redirect(to: "/orzecznictwo-kio/#{judgement.slug}")

      judgement ->
        view_judgement = %{
          id: judgement.id,
          slug: judgement.slug,
          signature: Judgement.display_signature(judgement.signature),
          decision_date: judgement.decision_date,
          issuing_authority: judgement.issuing_authority,
          document_type: judgement.document_type,
          chairman: judgement.chairman,
          contracting_authority: judgement.contracting_authority,
          location: judgement.location,
          procedure_type: judgement.procedure_type,
          resolution_method: judgement.resolution_method,
          key_provisions: judgement.key_provisions || [],
          thematic_issues: judgement.thematic_issues || [],
          deliberation: judgement.deliberation,
          meritum: judgement.meritum,
          content_html: judgement.content_html,
          pdf_url: judgement.pdf_url
        }

        topics = Topics.for_issues(view_judgement.thematic_issues)
        heading = heading(judgement)
        url_identifier = judgement.slug || judgement.id
        canonical_url = "#{@base_url}/orzecznictwo-kio/#{url_identifier}"

        conn
        |> assign(:page_title, page_title(judgement, heading, topics))
        |> assign(:meta_description, meta_description(judgement, heading))
        |> assign(:canonical_url, canonical_url)
        |> assign(:og_url, canonical_url)
        |> assign(:og_type, "article")
        |> maybe_noindex(judgement)
        |> assign(:breadcrumbs, breadcrumbs(heading, topics, canonical_url))
        |> assign(:judgement, view_judgement)
        |> assign(:heading, heading)
        |> assign(:topics, topics)
        |> assign(:narrative, Summary.narrative(judgement))
        |> assign(:related_judgements, Judgements.list_related_judgements(judgement))
        |> render(:show)
    end
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(html: PrzetargowiWeb.ErrorHTML)
    |> render(:"404")
  end

  # "Wyrok KIO 1234/25", "Postanowienie KIO 1234/25", or for court rulings
  # "Wyrok Sądu Okręgowego w Warszawie XXIII Zs 12/24" → kept short as
  # "Wyrok XXIII Zs 12/24". Half of the database are orders (postanowienia),
  # so labelling everything "Wyrok KIO" was simply wrong.
  defp heading(%{signature: signature} = judgement) when is_binary(signature) do
    "#{document_label(judgement.document_type)} #{Judgement.display_signature(signature)}"
  end

  defp heading(_judgement), do: "Orzeczenie KIO"

  defp document_label("wyrok" <> _), do: "Wyrok"
  defp document_label("postanowienie" <> _), do: "Postanowienie"
  defp document_label("uchwała" <> _), do: "Uchwała"
  defp document_label(_), do: "Orzeczenie"

  # Unique, query-shaped titles: signature + date + the main legal issue.
  # The root layout appends " — Przetargowi".
  defp page_title(judgement, heading, topics) do
    date =
      case judgement.decision_date do
        nil -> ""
        date -> " z #{Calendar.strftime(date, "%d.%m.%Y")}"
      end

    subject =
      case topics do
        [topic | _] -> String.downcase(topic.name)
        [] -> authority_label(judgement.issuing_authority)
      end

    "#{heading}#{date} — #{subject}"
  end

  defp authority_label("Krajowa Izba Odwoławcza"), do: "orzecznictwo KIO"
  defp authority_label(authority) when is_binary(authority) and authority != "", do: authority
  defp authority_label(_), do: "orzecznictwo KIO"

  defp meta_description(judgement, heading) do
    prefix =
      case judgement.decision_date do
        nil -> heading
        date -> "#{heading} z #{Calendar.strftime(date, "%d.%m.%Y")}"
      end

    body =
      [judgement.meritum, judgement.deliberation]
      |> Enum.find("Pełna treść orzeczenia, streszczenie i powołane przepisy ustawy Pzp.", fn
        text -> is_binary(text) and String.trim(text) != ""
      end)

    truncate("#{prefix}. #{body}" |> String.replace(~r/\s+/, " ") |> String.trim())
  end

  defp truncate(text) do
    if String.length(text) > @meta_description_length do
      text
      |> String.slice(0, @meta_description_length)
      |> String.replace(~r/\s+\S*$/, "")
      |> Kernel.<>("…")
    else
      text
    end
  end

  defp breadcrumbs(heading, topics, canonical_url) do
    topic_crumb =
      case topics do
        [topic | _] -> [%{name: topic.name, url: @base_url <> Topics.path(topic)}]
        [] -> []
      end

    [
      %{name: "Strona główna", url: @base_url},
      %{name: "Orzecznictwo KIO", url: "#{@base_url}/orzecznictwo-kio"}
    ] ++ topic_crumb ++ [%{name: heading, url: canonical_url}]
  end

  # Thin/empty rulings (no fetched content) are kept out of the index so they
  # stop dragging the domain's quality signal down. Once content is fetched and
  # the page carries real value, it becomes indexable again automatically.
  defp maybe_noindex(conn, judgement) do
    if Summary.indexable?(judgement) do
      conn
    else
      assign(conn, :meta_robots, "noindex, follow")
    end
  end
end
