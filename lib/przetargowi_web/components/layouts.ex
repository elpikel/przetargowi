defmodule PrzetargowiWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PrzetargowiWeb, :html

  embed_templates "layouts/*"

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
            <a href="/" class="flex items-center gap-3">
              <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center">
                <.icon name="hero-scale" class="size-5 text-primary-content" />
              </div>
              <span class="text-lg font-semibold tracking-tight text-base-content">Przetargowi</span>
            </a>

            <%= unless @hide_nav do %>
              <nav class="hidden md:flex items-center gap-8">
                <a href="/szukaj" class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors">
                  Wyszukiwarka
                </a>
                <a href="/#cennik" class="text-sm font-medium text-base-content/60 hover:text-base-content transition-colors">
                  Cennik
                </a>
              </nav>
            <% end %>

            <div class="flex items-center gap-4">
              <%= if @current_scope do %>
                <span class="hidden sm:block text-sm text-base-content/60">
                  {@current_scope.user.email}
                </span>
                <a href="/ustawienia" class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors">
                  Ustawienia
                </a>
                <.link href="/wyloguj" method="delete" class="btn-primary-solid px-4 py-2 text-sm font-medium rounded-lg">
                  Wyloguj
                </.link>
              <% else %>
                <a href="/logowanie" class="hidden sm:block text-sm font-medium text-base-content/60 hover:text-base-content transition-colors">
                  Zaloguj się
                </a>
                <a href="/rejestracja" class="btn-primary-solid px-4 py-2 text-sm font-medium rounded-lg">
                  Rozpocznij
                </a>
              <% end %>
              <button class="md:hidden p-2 text-base-content/60 hover:text-base-content transition-colors">
                <.icon name="hero-bars-3" class="size-5" />
              </button>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>

      <footer class="bg-base-200 border-t border-base-300">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-10">
            <div class="col-span-2 md:col-span-1">
              <a href="/" class="flex items-center gap-2 mb-4">
                <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
                  <.icon name="hero-scale" class="size-4 text-primary-content" />
                </div>
                <span class="font-semibold text-base-content">Przetargowi</span>
              </a>
              <p class="text-sm text-base-content/50 leading-relaxed">
                Wyszukiwarka orzeczeń zamówień publicznych wspierana przez AI.
              </p>
            </div>
            <div>
              <h4 class="font-medium text-base-content mb-4 text-sm">Produkt</h4>
              <ul class="space-y-3">
                <li><a href="/szukaj" class="text-sm text-base-content/50 hover:text-base-content transition-colors">Wyszukiwarka</a></li>
                <li><a href="/#cennik" class="text-sm text-base-content/50 hover:text-base-content transition-colors">Cennik</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-medium text-base-content mb-4 text-sm">Firma</h4>
              <ul class="space-y-3">
                <li><a href="/o-nas" class="text-sm text-base-content/50 hover:text-base-content transition-colors">O nas</a></li>
                <li><a href="/kontakt" class="text-sm text-base-content/50 hover:text-base-content transition-colors">Kontakt</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-medium text-base-content mb-4 text-sm">Prawne</h4>
              <ul class="space-y-3">
                <li><a href="/regulamin" class="text-sm text-base-content/50 hover:text-base-content transition-colors">Regulamin</a></li>
                <li><a href="/polityka-prywatnosci" class="text-sm text-base-content/50 hover:text-base-content transition-colors">Polityka prywatności</a></li>
              </ul>
            </div>
          </div>
          <div class="pt-8 border-t border-base-300 flex flex-col sm:flex-row justify-between items-center gap-4">
            <p class="text-sm text-base-content/40">
              © {Date.utc_today().year} Przetargowi
            </p>
            <p class="text-xs text-base-content/40">
              Źródło danych: orzeczenia.uzp.gov.pl
            </p>
          </div>
        </div>
      </footer>
    </div>

    <.flash_group flash={@flash} />
    """
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
