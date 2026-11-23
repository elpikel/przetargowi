defmodule PrzetargowiWeb.MarketDashboardLive do
  use PrzetargowiWeb, :live_view

  alias Przetargowi.Cpv
  alias Przetargowi.MarketAnalysis

  @faqs [
    %{
      question: "Skąd pochodzą dane w analizie rynku?",
      answer:
        "Z ogłoszeń publikowanych w Biuletynie Zamówień Publicznych: ogłoszeń o zamówieniu, o wyniku postępowania i o wykonaniu umowy. Analiza obejmuje do tysiąca najnowszych rozstrzygniętych postępowań w wybranej branży i województwie."
    },
    %{
      question: "Jak sprawdzić, kto wygrywa przetargi w mojej branży?",
      answer:
        "Wybierz branżę według kodu CPV i, opcjonalnie, województwo. Zobaczysz listę wykonawców z największą liczbą podpisanych umów, łączną wartość ich kontraktów oraz zamawiających, którzy ogłaszają najwięcej postępowań."
    },
    %{
      question: "Co oznacza odsetek postępowań tylko z kryterium ceny?",
      answer:
        "To udział ogłoszeń, w których cena jest jedynym kryterium oceny ofert. Im jest wyższy, tym bardziej o wyniku decyduje sama cena, a mniej doświadczenie, termin czy gwarancja."
    },
    %{
      question: "Czym jest kod CPV?",
      answer:
        "CPV (Wspólny Słownik Zamówień) to unijna klasyfikacja przedmiotu zamówienia. Każde ogłoszenie ma kod główny, np. 45 oznacza roboty budowlane, 33 — urządzenia medyczne i farmaceutyki, 72 — usługi informatyczne."
    },
    %{
      question: "Czy analiza rynku jest bezpłatna?",
      answer: "Tak. Analiza jest dostępna bezpłatnie i nie wymaga rejestracji."
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Analiza rynku przetargów — kto wygrywa zamówienia publiczne")
     |> assign(
       :meta_description,
       "Sprawdź rynek zamówień publicznych w Polsce: kto wygrywa przetargi, za ile, którzy zamawiający ogłaszają najwięcej i jakie kryteria stosują — według branży (CPV) i województwa."
     )
     |> assign(:canonical_url, "https://przetargowi.pl/analiza-rynku")
     |> assign(:faqs, @faqs)
     |> assign(:province, "")
     |> assign(:cpv_prefix, nil)
     |> assign(:cpv_code, nil)
     |> assign(:cpv_label, "")
     |> assign(:cpv_suggestions, [])
     |> assign(:cpv_open, false)
     |> assign(:cpv_error, false)
     |> assign(:analysis, nil)
     |> assign(:loading, false)}
  end

  # The URL is the state: every change of province or industry patches it, and
  # this callback (re)runs the analysis. With no industry in the URL the first
  # one on the list is used, so the page never opens empty.
  @impl true
  def handle_params(params, _uri, socket) do
    province = valid_province(params["wojewodztwo"])

    case resolve_cpv(params["cpv"]) do
      {:ok, {prefix, code, label}} ->
        {:noreply,
         socket
         |> assign(:province, province)
         |> assign(:cpv_prefix, prefix)
         |> assign(:cpv_code, code)
         |> assign(:cpv_label, label)
         |> assign(:cpv_open, false)
         |> assign(:cpv_error, false)
         |> assign(:loading, true)
         |> start_async(:analyze, fn -> MarketAnalysis.analyze(prefix, province) end)}

      :error ->
        {:noreply,
         socket
         |> assign(:province, province)
         |> assign(:cpv_prefix, nil)
         |> assign(:cpv_code, nil)
         |> assign(:cpv_label, "")
         |> assign(:cpv_open, false)
         |> assign(:cpv_error, true)
         |> assign(:analysis, nil)
         |> assign(:loading, false)}
    end
  end

  defp valid_province(code) do
    if Enum.any?(MarketAnalysis.provinces(), fn {known, _name} -> known == code end),
      do: code,
      else: ""
  end

  defp default_cpv, do: List.first(Cpv.all())

  defp resolve_cpv(param) when param in [nil, ""], do: {:ok, labelled(default_cpv())}

  defp resolve_cpv(param) do
    case Cpv.find(param) do
      nil ->
        # Older links carried a bare numeric prefix that is not on the list
        digits = String.replace(param, ~r/[^0-9]/, "")
        if String.length(digits) >= 2, do: {:ok, {digits, digits, digits}}, else: :error

      entry ->
        {:ok, labelled(entry)}
    end
  end

  defp labelled({prefix, code, description}), do: {prefix, code, "#{code} — #{description}"}

  defp analysis_path(province, cpv_code) do
    {_prefix, default_code, _desc} = default_cpv()

    params =
      %{}
      |> then(&if(cpv_code in [nil, default_code], do: &1, else: Map.put(&1, :cpv, cpv_code)))
      |> then(&if(province == "", do: &1, else: Map.put(&1, :wojewodztwo, province)))

    ~p"/analiza-rynku?#{params}"
  end

  @impl true
  def handle_event("province", %{"province" => province}, socket) do
    {:noreply,
     push_patch(socket, to: analysis_path(valid_province(province), socket.assigns.cpv_code))}
  end

  # Opening the list shows every industry, whatever is currently selected
  def handle_event("cpv_open", _params, socket) do
    {:noreply,
     socket
     |> assign(:cpv_suggestions, Cpv.all())
     |> assign(:cpv_open, true)
     |> assign(:cpv_error, false)}
  end

  def handle_event("cpv_search", %{"query" => query}, socket) do
    suggestions =
      if String.trim(query) == "", do: Cpv.all(), else: Cpv.search(query, 30)

    {:noreply, socket |> assign(:cpv_suggestions, suggestions) |> assign(:cpv_open, true)}
  end

  def handle_event("cpv_close", _params, socket) do
    {:noreply, assign(socket, :cpv_open, false)}
  end

  def handle_event("cpv_select", %{"code" => code}, socket) do
    {:noreply, push_patch(socket, to: analysis_path(socket.assigns.province, code))}
  end

  # Enter picks the best match for what was typed; nothing matching is an error
  def handle_event("cpv_enter", %{"query" => query}, socket) do
    case String.trim(query) != "" && Cpv.search(query, 1) do
      [{_prefix, code, _desc}] ->
        {:noreply, push_patch(socket, to: analysis_path(socket.assigns.province, code))}

      _ ->
        {:noreply, socket |> assign(:cpv_open, false) |> assign(:cpv_error, true)}
    end
  end

  @impl true
  def handle_async(:analyze, {:ok, analysis}, socket) do
    {:noreply,
     socket
     |> assign(:analysis, analysis)
     |> assign(:loading, false)
     |> push_event("chart-data", %{analysis: serialize_for_js(analysis)})}
  end

  def handle_async(:analyze, {:exit, _reason}, socket) do
    {:noreply, assign(socket, loading: false)}
  end

  defp serialize_for_js(analysis) do
    %{
      price_distribution: analysis.price_distribution,
      top_contractors:
        Enum.map(analysis.top_contractors, fn c ->
          %{name: c.name, wins: c.wins, total_value: c.total_value}
        end),
      top_ordering_parties:
        Enum.map(analysis.top_ordering_parties, fn p ->
          %{name: p.name, count: p.count}
        end),
      trends: analysis.trends,
      criteria: analysis.criteria
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="hero-backdrop min-h-screen bg-base-200">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
          <.hub_header
            crumbs={[{"Strona główna", "/"}, {"Analiza rynku", nil}]}
            title="Analiza rynku przetargów"
            lead="Sprawdź, kto wygrywa zamówienia publiczne w Twojej branży i regionie, za ile, którzy zamawiający ogłaszają najwięcej postępowań i jakie kryteria oceny ofert stosują."
          />

          <div class="card-base p-5 mb-8 grid gap-4 md:grid-cols-3" id="analysis-controls">
            <form phx-change="province" id="province-form">
              <label
                for="province-select"
                class="block text-sm font-medium text-base-content/70 mb-2"
              >
                Województwo
              </label>
              <select
                id="province-select"
                name="province"
                class="search-input w-full px-4 py-3 rounded-lg"
              >
                <option
                  :for={{code, name} <- MarketAnalysis.provinces()}
                  value={code}
                  selected={code == @province}
                >
                  {name}
                </option>
              </select>
            </form>

            <div
              id="cpv-combobox"
              phx-hook=".CpvCombobox"
              data-label={@cpv_label}
              class="md:col-span-2 relative"
            >
              <label for="cpv-input" class="block text-sm font-medium text-base-content/70 mb-2">
                Branża / kod CPV
              </label>
              <input
                type="text"
                id="cpv-input"
                value={@cpv_label}
                placeholder="Wpisz kod lub nazwę branży, np. budowlane, informatyczne, medyczne…"
                autocomplete="off"
                role="combobox"
                aria-expanded={to_string(@cpv_open)}
                aria-controls="cpv-options"
                aria-invalid={to_string(@cpv_error)}
                class={[
                  "search-input w-full px-4 py-3 rounded-lg",
                  @cpv_error && "is-invalid"
                ]}
              />
              <p :if={@cpv_error} id="cpv-error" class="mt-2 text-sm text-error">
                Nie znaleziono takiej branży. Wybierz pozycję z listy.
              </p>
              <ul
                :if={@cpv_open}
                id="cpv-options"
                role="listbox"
                class="absolute top-full left-0 right-0 z-50 mt-1 p-1 bg-base-100 border border-base-300 rounded-lg shadow-lg max-h-80 overflow-y-auto"
              >
                <li :for={{_prefix, full_code, desc} <- @cpv_suggestions}>
                  <button
                    type="button"
                    data-cpv-option
                    role="option"
                    aria-selected={to_string(full_code == @cpv_code)}
                    phx-click="cpv_select"
                    phx-value-code={full_code}
                    class={[
                      "w-full flex gap-3 px-3 py-2 rounded-md text-sm text-left hover:bg-base-200 transition-colors",
                      full_code == @cpv_code && "bg-primary/5"
                    ]}
                  >
                    <span class="font-mono text-primary font-medium shrink-0">{full_code}</span>
                    <span class="flex-1 truncate text-base-content/80">{desc}</span>
                  </button>
                </li>
                <li :if={@cpv_suggestions == []} class="px-3 py-2 text-sm text-base-content/60">
                  Brak pasujących branż
                </li>
              </ul>
              <script :type={Phoenix.LiveView.ColocatedHook} name=".CpvCombobox">
                // Industry picker. The server renders the option list; this hook only
                // decides when the list is open and what the text field shows:
                // opening clears the field and lists everything, leaving without
                // choosing puts the current selection back.
                export default {
                  mounted() {
                    this.input = this.el.querySelector("input")
                    this.isOpen = false
                    this.timer = null

                    const open = () => {
                      if (this.isOpen) return
                      this.isOpen = true
                      this.input.value = ""
                      this.pushEvent("cpv_open", {})
                    }

                    this.close = () => {
                      if (!this.isOpen) return
                      this.isOpen = false
                      clearTimeout(this.timer)
                      this.input.value = this.el.dataset.label
                      this.pushEvent("cpv_close", {})
                    }

                    this.input.addEventListener("focus", open)
                    this.input.addEventListener("click", open)

                    // Clicked before the page finished connecting: the field already
                    // has focus, so no focus or click event is coming. Open it now.
                    if (document.activeElement === this.input) open()

                    this.input.addEventListener("input", () => {
                      this.isOpen = true
                      clearTimeout(this.timer)
                      this.timer = setTimeout(
                        () => this.pushEvent("cpv_search", {query: this.input.value}),
                        120
                      )
                    })

                    this.input.addEventListener("keydown", event => {
                      if (event.key === "Escape") {
                        this.close()
                        this.input.blur()
                      } else if (event.key === "Enter") {
                        event.preventDefault()
                        clearTimeout(this.timer)
                        this.isOpen = false
                        this.pushEvent("cpv_enter", {query: this.input.value})
                        this.input.blur()
                      }
                    })

                    // Choosing an option: the server patches the URL. Leave the field
                    // so that the next click on it opens the list again.
                    this.el.addEventListener("click", event => {
                      if (event.target.closest("[data-cpv-option]")) {
                        this.isOpen = false
                        this.input.blur()
                      }
                    })

                    this.onOutsidePress = event => {
                      if (!this.el.contains(event.target)) this.close()
                    }
                    document.addEventListener("mousedown", this.onOutsidePress)

                    this.el.addEventListener("focusout", event => {
                      if (event.relatedTarget && !this.el.contains(event.relatedTarget)) this.close()
                    })
                  },

                  // After any server update the closed field shows the selection
                  updated() {
                    if (!this.isOpen) this.input.value = this.el.dataset.label
                  },

                  destroyed() {
                    document.removeEventListener("mousedown", this.onOutsidePress)
                    clearTimeout(this.timer)
                  }
                }
              </script>
            </div>
          </div>

          <div :if={@loading} class="flex justify-center py-12">
            <span class="loading loading-spinner loading-lg text-primary" id="analysis-loading">
            </span>
          </div>

          <div :if={@analysis && !@loading} id="dashboard-charts" phx-hook="MarketCharts">
            <.stat_tiles
              id="analysis-figures"
              items={[
                {"Rozstrzygnięte postępowania w analizie", @analysis.total_tenders},
                {"Podpisane umowy z wykonawcami", @analysis.total_contracts},
                {"Otwarte przetargi w tej branży", @analysis.total_open}
              ]}
            />
            <p class="-mt-4 mb-8 text-sm text-base-content/60" id="analysis-price-only">
              <%= if @analysis.criteria.price_only_pct do %>
                W <strong class="text-base-content">{@analysis.criteria.price_only_pct}%</strong>
                ogłoszeń cena jest jedynym kryterium oceny ofert.
              <% else %>
                Brak danych o kryteriach oceny ofert dla tego wyboru.
              <% end %>
            </p>
            
    <!-- Charts row 1 -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
              <!-- Top contractors chart -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">
                    Top wykonawcy (wygrane kontrakty)
                  </h2>
                  <canvas id="contractors-chart" phx-update="ignore"></canvas>
                  <p
                    :if={@analysis.top_contractors == []}
                    class="text-base-content/50 text-center py-8"
                  >
                    Brak danych o wykonawcach
                  </p>
                </div>
              </div>
              
    <!-- Monthly trends -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">Trend miesięczny</h2>
                  <canvas id="trends-chart" phx-update="ignore"></canvas>
                </div>
              </div>
            </div>
            
    <!-- Charts row 2 -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
              <!-- Criteria analysis -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">Kryteria oceny ofert</h2>
                  <canvas id="criteria-chart" phx-update="ignore"></canvas>
                  <p
                    :if={@analysis.criteria.top_criteria == []}
                    class="text-base-content/50 text-center py-8"
                  >
                    Brak danych o kryteriach
                  </p>
                </div>
              </div>
              
    <!-- Price distribution (if available) -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">Wartości kontraktów</h2>
                  <%= if @analysis.price_distribution.count > 0 do %>
                    <canvas id="price-chart" phx-update="ignore"></canvas>
                    <div class="text-sm text-base-content/60 mt-2">
                      Min: {format_pln(@analysis.price_distribution.min)} |
                      Mediana: {format_pln(@analysis.price_distribution.median)} |
                      Max: {format_pln(@analysis.price_distribution.max)}
                    </div>
                  <% else %>
                    <div class="flex flex-col items-center justify-center py-8 text-base-content/50">
                      <p>Brak danych cenowych</p>
                      <p class="text-xs mt-1">
                        Wartości kontraktów nie są jeszcze dostępne dla tych postępowań
                      </p>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
            
    <!-- Tables -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
              <!-- Top contractors table -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">Wiodący wykonawcy</h2>
                  <div class="overflow-x-auto">
                    <table class="table table-sm">
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Firma</th>
                          <th>Miasto</th>
                          <th>Wygrane</th>
                        </tr>
                      </thead>
                      <tbody>
                        <%= for {c, i} <- Enum.with_index(@analysis.top_contractors, 1) do %>
                          <tr>
                            <td>{i}</td>
                            <td class="font-medium max-w-48 truncate" title={c.name}>{c.name}</td>
                            <td>{c.city}</td>
                            <td class="font-bold">{c.wins}</td>
                          </tr>
                        <% end %>
                      </tbody>
                    </table>
                  </div>
                  <p :if={@analysis.top_contractors == []} class="text-base-content/50 text-sm">
                    Brak danych o wykonawcach w wybranych postępowaniach.
                  </p>
                </div>
              </div>
              
    <!-- Top ordering parties table -->
              <div class="card-base">
                <div class="p-6">
                  <h2 class="text-lg font-semibold text-base-content mb-4">Wiodący zamawiający</h2>
                  <div class="overflow-x-auto">
                    <table class="table table-sm">
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Zamawiający</th>
                          <th>Miasto</th>
                          <th>Postępowań</th>
                        </tr>
                      </thead>
                      <tbody>
                        <%= for {p, i} <- Enum.with_index(@analysis.top_ordering_parties, 1) do %>
                          <tr>
                            <td>{i}</td>
                            <td class="font-medium max-w-56 truncate" title={p.name}>{p.name}</td>
                            <td>{p.city}</td>
                            <td class="font-bold">{p.count}</td>
                          </tr>
                        <% end %>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Segments -->
            <div class="card-base mb-6">
              <div class="p-6">
                <h2 class="text-lg font-semibold text-base-content mb-4">Segmenty zamówień</h2>
                <div class="overflow-x-auto">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Typ zamówienia</th>
                        <th>Postępowań</th>
                        <th>Podpisanych kontraktów</th>
                      </tr>
                    </thead>
                    <tbody>
                      <%= for s <- @analysis.best_segments do %>
                        <tr>
                          <td class="font-medium">{s.order_type}</td>
                          <td>{s.tender_count}</td>
                          <td>{s.contract_count}</td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            
    <!-- Criteria table -->
            <div :if={@analysis.criteria.top_criteria != []} class="card-base mb-6">
              <div class="p-6">
                <h2 class="text-lg font-semibold text-base-content mb-4">
                  Najczęstsze kryteria oceny
                </h2>
                <p class="text-sm text-base-content/60 mb-4">
                  Na podstawie {@analysis.criteria.total_tenders_with_criteria} ogłoszeń z określonymi kryteriami.
                </p>
                <div class="overflow-x-auto">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Kryterium</th>
                        <th>Wystąpień</th>
                        <th>Średnia waga</th>
                      </tr>
                    </thead>
                    <tbody>
                      <%= for k <- @analysis.criteria.top_criteria do %>
                        <tr>
                          <td class="font-medium">{k.name}</td>
                          <td>{k.count}</td>
                          <td>
                            <span :if={k.avg_weight} class="badge badge-outline">
                              {k.avg_weight}%
                            </span>
                            <span :if={!k.avg_weight} class="text-base-content/40">b/d</span>
                          </td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div :if={!@analysis && !@loading && @cpv_prefix} class="text-center py-12">
            <p class="text-lg text-base-content/60">Brak danych dla wybranej branży.</p>
          </div>

          <div class="mt-14 space-y-10" id="analysis-editorial">
            <.prose_card
              id="analysis-overview"
              title="Jak czytać analizę rynku zamówień publicznych"
              paragraphs={[
                "Analiza pokazuje, jak wygląda rynek zamówień publicznych w wybranej branży i województwie: ile postępowań rozstrzygnięto, ile umów podpisano, kto je wygrywał i za jakie kwoty. Powstaje z ogłoszeń Biuletynu Zamówień Publicznych, w tym ogłoszeń o wyniku postępowania i o wykonaniu umowy.",
                "Lista wiodących wykonawców pozwala ocenić konkurencję przed złożeniem oferty, a lista zamawiających — wskazać instytucje, które regularnie kupują w Twojej branży. Rozkład wartości kontraktów i udział postępowań rozstrzyganych wyłącznie ceną podpowiadają, czy na danym rynku wygrywa się ceną, czy także doświadczeniem i jakością.",
                "Aktualne postępowania w wybranej branży znajdziesz w wyszukiwarce przetargów, a miesięczne podsumowania dla województw — w raportach przetargowych."
              ]}
            />
            <p class="-mt-4 text-sm">
              <a href="/przetargi" class="text-primary font-medium hover:underline">
                Aktualne przetargi publiczne
              </a>
              <span class="text-base-content/40 mx-2">·</span>
              <a href="/raporty" class="text-primary font-medium hover:underline">
                Raporty przetargowe
              </a>
              <span class="text-base-content/40 mx-2">·</span>
              <a href="/orzecznictwo-kio" class="text-primary font-medium hover:underline">
                Orzecznictwo KIO
              </a>
            </p>
            <.faq_section id="analysis-faq" faqs={@faqs} />
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp format_pln(nil), do: "-"

  defp format_pln(value) when is_float(value) and value >= 1_000_000 do
    "#{:erlang.float_to_binary(value / 1_000_000, decimals: 1)} mln"
  end

  defp format_pln(value) when is_float(value) and value >= 1_000 do
    "#{:erlang.float_to_binary(value / 1_000, decimals: 0)} tys."
  end

  defp format_pln(value) when is_float(value), do: "#{round(value)}"
  defp format_pln(value) when is_integer(value), do: "#{value}"
  defp format_pln(_), do: "-"
end
