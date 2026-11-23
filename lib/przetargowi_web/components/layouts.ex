defmodule PrzetargowiWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PrzetargowiWeb, :html

  embed_templates "layouts/*"

  @nav_sections %{
    "orzecznictwo-kio" => "orzecznictwo-kio",
    "orzeczenie" => "orzecznictwo-kio",
    "przetargi" => "przetargi",
    "analiza-rynku" => "analiza-rynku",
    "raporty" => "raporty",
    "blog" => "blog"
  }

  @doc """
  Returns the top-menu section the current request belongs to (or `nil`),
  based on the first path segment. Rendered as `data-nav` on `<body>` so the
  matching `data-nav-item` link is highlighted via CSS.
  """
  def active_nav(%Plug.Conn{path_info: [segment | _]}), do: Map.get(@nav_sections, segment)
  def active_nav(_conn), do: nil

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :hide_nav, :boolean, default: false, doc: "hide the main navigation links"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-base-100">
      <header class="site-header sticky top-0 z-50">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between h-16">
            <a href="/" class="flex items-center gap-3 group">
              <div class="w-8 h-8 rounded-lg bg-neutral flex items-center justify-center">
                <.icon name="hero-scale" class="size-4 text-neutral-content" />
              </div>
              <span class="text-lg font-semibold tracking-tight text-base-content">
                Przetargowi
              </span>
            </a>

            <%= unless @hide_nav do %>
              <nav class="hidden md:flex items-center gap-7">
                <a
                  href="/orzecznictwo-kio"
                  data-nav-item="orzecznictwo-kio"
                  class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Orzeczenia
                </a>
                <a
                  href="/przetargi"
                  data-nav-item="przetargi"
                  class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Przetargi
                </a>
                <a
                  href="/analiza-rynku"
                  data-nav-item="analiza-rynku"
                  class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Analiza rynku
                </a>
                <a
                  href="/raporty"
                  data-nav-item="raporty"
                  class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Raporty
                </a>
                <a
                  href="/blog"
                  data-nav-item="blog"
                  class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Blog
                </a>
              </nav>
            <% end %>

            <div class="flex items-center gap-4">
              <%= if @current_scope do %>
                <a
                  href="/obserwowane"
                  class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Obserwowane
                </a>
                <a
                  href="/alerty"
                  class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Alerty
                </a>
                <a
                  href="/ustawienia"
                  class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Ustawienia
                </a>
                <.link
                  href="/wyloguj"
                  method="delete"
                  class="btn-primary-solid px-4 py-2 text-sm font-medium rounded-lg"
                >
                  Wyloguj
                </.link>
              <% else %>
                <a
                  href="/logowanie"
                  class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors"
                >
                  Zaloguj się
                </a>
                <a
                  href="/rejestracja"
                  class="btn-primary-solid px-4 py-2 text-sm font-medium rounded-lg"
                >
                  Rozpocznij
                </a>
              <% end %>
              <button
                id="mobile-menu-button"
                class="md:hidden p-2 text-base-content/60 hover:text-base-content transition-colors"
                onclick="document.getElementById('mobile-menu').classList.toggle('hidden')"
                aria-label="Menu"
              >
                <.icon name="hero-bars-3" class="size-5" />
              </button>
            </div>
          </div>
        </div>
        
    <!-- Mobile menu -->
        <div id="mobile-menu" class="hidden md:hidden border-t border-base-300 bg-base-100">
          <div class="px-4 py-4 space-y-3">
            <%= unless @hide_nav do %>
              <a
                href="/orzecznictwo-kio"
                data-nav-item="orzecznictwo-kio"
                class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
              >
                Orzeczenia
              </a>
              <a
                href="/przetargi"
                data-nav-item="przetargi"
                class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
              >
                Przetargi
              </a>
              <a
                href="/analiza-rynku"
                data-nav-item="analiza-rynku"
                class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
              >
                Analiza rynku
              </a>
              <a
                href="/raporty"
                data-nav-item="raporty"
                class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
              >
                Raporty
              </a>
              <a
                href="/blog"
                data-nav-item="blog"
                class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
              >
                Blog
              </a>
            <% end %>
            <div class="pt-3 border-t border-base-300">
              <%= if @current_scope do %>
                <a
                  href="/obserwowane"
                  class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
                >
                  Obserwowane
                </a>
                <a
                  href="/alerty"
                  class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
                >
                  Alerty
                </a>
                <a
                  href="/ustawienia"
                  class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
                >
                  Ustawienia
                </a>
                <.link
                  href="/wyloguj"
                  method="delete"
                  class="block text-sm font-medium text-error hover:text-error/80 py-2"
                >
                  Wyloguj
                </.link>
              <% else %>
                <a
                  href="/logowanie"
                  class="block text-sm font-medium text-base-content/70 hover:text-base-content py-2"
                >
                  Zaloguj się
                </a>
                <a
                  href="/rejestracja"
                  class="block text-sm font-medium text-primary hover:text-primary/80 py-2"
                >
                  Rozpocznij
                </a>
              <% end %>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>

      <footer class="footer-dark">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-10 mb-12">
            <div class="col-span-2 md:col-span-1">
              <a href="/" class="flex items-center gap-3 mb-5">
                <div class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
                  <.icon name="hero-scale" class="size-4 text-white" />
                </div>
                <span class="font-display font-semibold text-lg text-primary-content">
                  Przetargowi
                </span>
              </a>
              <p class="text-sm text-primary-content/60 leading-relaxed">
                Wyszukiwarka orzeczeń KIO i przetargów publicznych wspierana przez AI.
              </p>
            </div>
            <div>
              <h4 class="font-semibold text-white/90 mb-4 text-xs uppercase tracking-wider">
                Produkt
              </h4>
              <ul class="space-y-2.5">
                <li><a href="/orzecznictwo-kio">Orzecznictwo KIO</a></li>
                <li><a href="/orzecznictwo-kio/statystyki">Statystyki KIO</a></li>
                <li><a href="/przetargi">Przetargi</a></li>
                <li><a href="/raporty">Raporty</a></li>
                <li><a href="/blog">Blog</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-semibold text-white/90 mb-4 text-xs uppercase tracking-wider">
                Orzecznictwo KIO
              </h4>
              <ul class="space-y-2.5" id="footer-kio-topics">
                <li :for={topic <- footer_topics()}>
                  <a href={Przetargowi.Judgements.Topics.path(topic)}>{topic.name}</a>
                </li>
              </ul>
            </div>
            <div>
              <h4 class="font-semibold text-white/90 mb-4 text-xs uppercase tracking-wider">
                Przetargi
              </h4>
              <ul class="space-y-2.5" id="footer-tender-hubs">
                <li :for={{path, label} <- footer_tender_links()}>
                  <a href={path}>{label}</a>
                </li>
              </ul>
            </div>
            <div>
              <h4 class="font-semibold text-white/90 mb-4 text-xs uppercase tracking-wider">
                Firma
              </h4>
              <ul class="space-y-2.5">
                <li><a href="/o-nas">O nas</a></li>
                <li><a href="/kontakt">Kontakt</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-semibold text-white/90 mb-4 text-xs uppercase tracking-wider">
                Prawne
              </h4>
              <ul class="space-y-2.5">
                <li><a href="/regulamin">Regulamin</a></li>
                <li><a href="/polityka-prywatnosci">Polityka prywatności</a></li>
              </ul>
            </div>
          </div>
          <div class="pt-8 border-t border-primary-content/10 flex flex-col sm:flex-row justify-between items-center gap-4">
            <p class="text-sm text-primary-content/50">
              © {Date.utc_today().year} Przetargowi. Wszelkie prawa zastrzeżone.
            </p>
            <p class="text-xs text-primary-content/40">
              Źródło danych: orzeczenia.uzp.gov.pl
            </p>
          </div>
        </div>
      </footer>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  # Sitewide footer links to the highest-demand tender hubs.
  defp footer_tender_links do
    [
      {"/przetargi/branza/budowlane", "Przetargi budowlane"},
      {"/przetargi/branza/drogowe", "Przetargi drogowe"},
      {"/przetargi/branza/medyczne", "Przetargi medyczne"},
      {"/przetargi/branza/it", "Przetargi IT"},
      {"/przetargi/rodzaj/dostawy", "Przetargi na dostawy"},
      {"/przetargi/rodzaj/uslugi", "Przetargi na usługi"}
    ]
  end

  @brand_suffix " — Przetargowi"
  @max_title_length 62

  @doc """
  Builds the `<title>`. The brand is appended only while the result stays
  short enough not to be truncated in search results; long titles keep their
  keywords instead.
  """
  def document_title(nil), do: "Orzeczenia KIO i Przetargi Publiczne" <> @brand_suffix

  def document_title(title) do
    if String.length(title) + String.length(@brand_suffix) <= @max_title_length do
      title <> @brand_suffix
    else
      title
    end
  end

  # Sitewide footer links to the highest-demand KIO topic hubs.
  @footer_topic_slugs ~w(razaco-niska-cena odrzucenie-oferty wykluczenie-wykonawcy tajemnica-przedsiebiorstwa uniewaznienie-postepowania wadium)

  defp footer_topics do
    @footer_topic_slugs
    |> Enum.map(&Przetargowi.Judgements.Topics.get/1)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Shows the flash group with standard titles and content.
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
