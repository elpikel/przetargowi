defmodule PrzetargowiWeb.MarketDashboardLive do
  use PrzetargowiWeb, :live_view

  alias Przetargowi.Cpv
  alias Przetargowi.MarketAnalysis

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Analiza Rynku Przetargów Publicznych")
     |> assign(
       :meta_description,
       "Sprawdź rynek zamówień publicznych w Polsce. Analiza branż, wykonawców, zamawiających i trendów przetargowych wg kodów CPV i województw."
     )
     |> assign(:canonical_url, "https://przetargowi.pl/analiza-rynku")
     |> assign(:province, "")
     |> assign(:cpv_query, "")
     |> assign(:cpv_prefix, nil)
     |> assign(:cpv_code, nil)
     |> assign(:cpv_suggestions, [])
     |> assign(:show_suggestions, false)
     |> assign(:analysis, nil)
     |> assign(:loading, false)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    province = params["wojewodztwo"] || ""
    cpv_param = params["cpv"] || ""

    socket = assign(socket, :province, province)

    socket =
      if cpv_param != "" do
        # Resolve full code and prefix from whatever was in the URL
        {prefix, full_code, label} = resolve_cpv(cpv_param)

        socket
        |> assign(:cpv_query, label)
        |> assign(:cpv_prefix, prefix)
        |> assign(:cpv_code, full_code)
        |> assign(:loading, true)
        |> start_async(:analyze, fn -> MarketAnalysis.analyze(prefix, province) end)
      else
        assign(socket, :cpv_query, "")
      end

    {:noreply, socket}
  end

  defp resolve_cpv(code) do
    case Cpv.find(code) do
      {prefix, full_code, desc} -> {prefix, full_code, "#{full_code} — #{desc}"}
      nil -> {code, code, code}
    end
  end

  @impl true
  def handle_event("filter", params, socket) do
    province = params["province"] || socket.assigns.province
    cpv_query = params["cpv_query"] || socket.assigns.cpv_query
    cpv_code = socket.assigns[:cpv_code]

    # Use stored full code from autocomplete selection, or extract from input
    cpv_for_url =
      cond do
        cpv_code && cpv_code != "" -> cpv_code
        true -> extract_cpv_prefix(cpv_query)
      end

    if cpv_for_url do
      {:noreply,
       socket
       |> assign(:show_suggestions, false)
       |> push_patch(to: ~p"/analiza-rynku?#{%{wojewodztwo: province, cpv: cpv_for_url}}")}
    else
      {:noreply,
       socket
       |> assign(:province, province)
       |> assign(:cpv_query, cpv_query)
       |> assign(:analysis, nil)}
    end
  end

  def handle_event("cpv_search", %{"cpv_query" => query}, socket) do
    limit = if String.trim(query) == "", do: 100, else: 15
    suggestions = Cpv.search(query, limit)

    {:noreply,
     socket
     |> assign(:cpv_query, query)
     |> assign(:cpv_suggestions, suggestions)
     |> assign(:show_suggestions, suggestions != [])}
  end

  # Fallback for form-level change events
  def handle_event("cpv_search", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cpv_focus", _params, socket) do
    query = socket.assigns.cpv_query
    limit = if query == "" or query == nil, do: 100, else: 15
    suggestions = Cpv.search(query, limit)

    {:noreply,
     socket
     |> assign(:cpv_suggestions, suggestions)
     |> assign(:show_suggestions, true)}
  end

  def handle_event("cpv_close", _params, socket) do
    {:noreply, assign(socket, :show_suggestions, false)}
  end

  def handle_event("cpv_select", %{"prefix" => prefix, "code" => code, "desc" => desc}, socket) do
    {:noreply,
     socket
     |> assign(:cpv_query, "#{code} — #{desc}")
     |> assign(:cpv_prefix, prefix)
     |> assign(:cpv_code, code)
     |> assign(:show_suggestions, false)}
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

  defp extract_cpv_prefix(query) do
    # Handle "45 — Roboty budowlane" format from autocomplete
    cleaned =
      query
      |> String.split(~r/[\s—\-]/, parts: 2)
      |> List.first("")
      |> String.replace(~r/[^0-9]/, "")

    if String.length(cleaned) >= 2, do: cleaned, else: nil
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
    <div class="min-h-screen bg-base-200">
      <div class="container mx-auto px-4 py-8 max-w-7xl">
        <h1 class="text-3xl font-bold mb-2">Analiza Rynku Przetargów</h1>
        <p class="text-base-content/60 mb-8">
          Wybierz województwo i kod CPV, aby zobaczyć analizę rynku zamówień publicznych.
        </p>

        <form phx-submit="filter" class="card bg-base-100 shadow-md mb-8">
          <div class="card-body">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
              <div class="form-control">
                <label class="label"><span class="label-text font-medium">Województwo</span></label>
                <select name="province" class="select select-bordered w-full" value={@province}>
                  <%= for {code, name} <- MarketAnalysis.provinces() do %>
                    <option value={code} selected={code == @province}>{name}</option>
                  <% end %>
                </select>
              </div>

              <div class="form-control relative" phx-click-away="cpv_close">
                <label class="label">
                  <span class="label-text font-medium">Branża / kod CPV</span>
                </label>
                <input
                  type="text"
                  id="cpv-input"
                  name="cpv_query"
                  value={@cpv_query}
                  placeholder="Wpisz kod lub szukaj np. budowlane, informatyczne, medyczne..."
                  class="input input-bordered w-full"
                  phx-change="cpv_search"
                  phx-focus="cpv_focus"
                  phx-debounce="150"
                  autocomplete="off"
                />
                <div
                  :if={@show_suggestions}
                  class="absolute top-full left-0 right-0 z-50 mt-1 bg-base-100 border border-base-300 rounded-lg shadow-lg max-h-72 overflow-y-auto"
                >
                  <ul class="menu menu-sm p-1">
                    <%= for {prefix, full_code, desc} <- @cpv_suggestions do %>
                      <li>
                        <a
                          href="#"
                          phx-click="cpv_select"
                          phx-value-prefix={prefix}
                          phx-value-code={full_code}
                          phx-value-desc={desc}
                          class="flex gap-2"
                        >
                          <span class="font-mono text-primary font-medium shrink-0">{full_code}</span>
                          <span class="text-left flex-1 truncate">{desc}</span>
                        </a>
                      </li>
                    <% end %>
                  </ul>
                </div>
              </div>

              <button type="submit" class="btn btn-primary">
                Analizuj rynek
              </button>
            </div>
          </div>
        </form>

        <div :if={@loading} class="flex justify-center py-12">
          <span class="loading loading-spinner loading-lg text-primary"></span>
        </div>

        <div :if={@analysis && !@loading} id="dashboard-charts" phx-hook="MarketCharts">
          <!-- Summary cards -->
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div class="stat bg-base-100 rounded-box shadow">
              <div class="stat-title">Zamknięte postępowania</div>
              <div class="stat-value text-primary">{@analysis.total_tenders}</div>
              <div class="stat-desc">z wynikami</div>
            </div>
            <div class="stat bg-base-100 rounded-box shadow">
              <div class="stat-title">Podpisane kontrakty</div>
              <div class="stat-value text-secondary">{@analysis.total_contracts}</div>
              <div class="stat-desc">z wykonawcami</div>
            </div>
            <div class="stat bg-base-100 rounded-box shadow">
              <div class="stat-title">Aktywne przetargi</div>
              <div class="stat-value text-accent">{@analysis.total_open}</div>
              <div class="stat-desc">otwarte ogłoszenia</div>
            </div>
            <div class="stat bg-base-100 rounded-box shadow">
              <div class="stat-title">Tylko kryterium ceny</div>
              <div class="stat-value">
                {if @analysis.criteria.price_only_pct, do: "#{@analysis.criteria.price_only_pct}%", else: "b/d"}
              </div>
              <div class="stat-desc">postępowań</div>
            </div>
          </div>

          <!-- Charts row 1 -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <!-- Top contractors chart -->
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Top wykonawcy (wygrane kontrakty)</h2>
                <canvas id="contractors-chart" phx-update="ignore"></canvas>
                <p :if={@analysis.top_contractors == []} class="text-base-content/50 text-center py-8">
                  Brak danych o wykonawcach
                </p>
              </div>
            </div>

            <!-- Monthly trends -->
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Trend miesięczny</h2>
                <canvas id="trends-chart" phx-update="ignore"></canvas>
              </div>
            </div>
          </div>

          <!-- Charts row 2 -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <!-- Criteria analysis -->
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Kryteria oceny ofert</h2>
                <canvas id="criteria-chart" phx-update="ignore"></canvas>
                <p :if={@analysis.criteria.top_criteria == []} class="text-base-content/50 text-center py-8">
                  Brak danych o kryteriach
                </p>
              </div>
            </div>

            <!-- Price distribution (if available) -->
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Wartości kontraktów</h2>
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
                    <p class="text-xs mt-1">Wartości kontraktów nie są jeszcze dostępne dla tych postępowań</p>
                  </div>
                <% end %>
              </div>
            </div>
          </div>

          <!-- Tables -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <!-- Top contractors table -->
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Wiodący wykonawcy</h2>
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
            <div class="card bg-base-100 shadow">
              <div class="card-body">
                <h2 class="card-title text-lg">Wiodący zamawiający</h2>
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
          <div class="card bg-base-100 shadow mb-6">
            <div class="card-body">
              <h2 class="card-title text-lg">Segmenty zamówień</h2>
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
          <div :if={@analysis.criteria.top_criteria != []} class="card bg-base-100 shadow mb-6">
            <div class="card-body">
              <h2 class="card-title text-lg">Najczęstsze kryteria oceny</h2>
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
                          <span :if={k.avg_weight} class="badge badge-outline">{k.avg_weight}%</span>
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
          <p class="text-lg text-base-content/60">Brak danych dla wybranego kodu CPV.</p>
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
