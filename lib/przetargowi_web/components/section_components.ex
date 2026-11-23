defmodule PrzetargowiWeb.SectionComponents do
  @moduledoc """
  Building blocks shared by the two content sections of the site — KIO case
  law (`/orzecznictwo-kio`) and tenders (`/przetargi`).

  Both sections have the same three page types and must look and behave the
  same:

    * landing — `page_hero`, `search_bar`, `stat_tiles`, `hub_grid`, a short
      list of the newest items, `faq_section`
    * hub — `hub_header`, `stat_tiles`, `search_bar`, a `result_card` list with
      `pager` beside `side_card`s, then `prose_card`, `faq_section` and
      `link_columns`
    * search results — the filter form, a `result_card` list and `pager`

  A template for one section should differ from its twin only in the data it
  passes in. When a block needs to change, change it here.
  """
  use Phoenix.Component

  import PrzetargowiWeb.CoreComponents, only: [icon: 1, breadcrumb_nav: 1]

  @doc "Formats an integer with a non-breaking space as thousands separator."
  def format_count(number) when is_integer(number) do
    number
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1\u00A0")
    |> String.reverse()
  end

  def format_count(other), do: to_string(other)

  @doc "Centered heading for a section's landing page."
  attr :title, :string, required: true
  slot :inner_block, required: true, doc: "the lead paragraph"

  def page_hero(assigns) do
    ~H"""
    <header class="text-center mb-10">
      <h1 class="text-4xl md:text-5xl font-bold text-base-content mb-4">{@title}</h1>
      <p class="text-xl text-base-content/70 max-w-3xl mx-auto">{render_slot(@inner_block)}</p>
    </header>
    """
  end

  @doc "Breadcrumbs, heading and lead of a hub or search page."
  attr :crumbs, :list, required: true
  attr :title, :string, required: true
  attr :lead, :string, default: nil
  slot :inner_block, doc: "optional line under the lead"

  def hub_header(assigns) do
    ~H"""
    <.breadcrumb_nav crumbs={@crumbs} />
    <header class="mb-8 max-w-3xl">
      <h1 class="text-3xl md:text-4xl font-bold text-base-content mb-4">{@title}</h1>
      <p :if={@lead} class="text-lg text-base-content/70 leading-relaxed">{@lead}</p>
      {render_slot(@inner_block)}
    </header>
    """
  end

  @doc """
  One-field search box. Submits `q` (plus any `hidden` params) to `action`;
  `advanced` links to the section's full filter form.
  """
  attr :id, :string, required: true
  attr :action, :string, required: true
  attr :placeholder, :string, required: true
  attr :label, :string, required: true
  attr :hidden, :list, default: [], doc: "list of {name, value}"
  attr :advanced, :string, default: nil
  attr :advanced_label, :string, default: "Wyszukiwanie zaawansowane"
  attr :centered, :boolean, default: false

  def search_bar(assigns) do
    ~H"""
    <div class={["mb-8", @centered && "max-w-3xl mx-auto"]}>
      <form action={@action} method="get" id={@id} class="card-base p-4 sm:p-5">
        <input :for={{name, value} <- @hidden} type="hidden" name={name} value={value} />
        <label for={"#{@id}-input"} class="sr-only">{@label}</label>
        <div class="flex flex-col sm:flex-row gap-3">
          <input
            type="text"
            name="q"
            id={"#{@id}-input"}
            placeholder={@placeholder}
            class="search-input flex-1 px-4 py-3 rounded-lg"
          />
          <button
            type="submit"
            class="btn-gold px-6 py-3 rounded-lg font-semibold inline-flex items-center justify-center gap-2"
          >
            <.icon name="hero-magnifying-glass" class="size-5" /> Szukaj
          </button>
        </div>
      </form>
      <p :if={@advanced} class={["mt-3 text-sm text-base-content/60", @centered && "text-center"]}>
        Potrzebujesz filtrów?
        <a href={@advanced} rel="nofollow" class="text-primary font-medium hover:underline">
          {@advanced_label}
        </a>
      </p>
    </div>
    """
  end

  @doc "Row of headline figures. `items` is a list of `{label, value}`."
  attr :id, :string, required: true
  attr :items, :list, required: true

  def stat_tiles(assigns) do
    ~H"""
    <section id={@id} class="grid sm:grid-cols-3 gap-4 mb-8">
      <div :for={{label, value} <- @items} class="card-base p-5">
        <div class="text-sm text-base-content/60 mb-1">{label}</div>
        <div class="text-2xl font-bold text-base-content tabular-nums">{value}</div>
      </div>
    </section>
    """
  end

  @doc "Grid of links to a section's hubs. `items` is a list of `%{path, name, lead}`."
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :lead, :string, default: nil
  attr :items, :list, required: true

  def hub_grid(assigns) do
    ~H"""
    <section class="mb-14" id={@id}>
      <h2 class="text-2xl font-bold text-base-content mb-2">{@title}</h2>
      <p :if={@lead} class="text-base-content/60 mb-6 max-w-3xl">{@lead}</p>
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <a :for={item <- @items} href={item.path} class="pricing-card p-5 block group">
          <h3 class="font-semibold text-base-content mb-2 flex items-start justify-between gap-3">
            {item.name}
            <.icon
              name="hero-arrow-right"
              class="size-4 mt-1 shrink-0 text-base-content/30 group-hover:text-primary group-hover:translate-x-0.5 transition-all"
            />
          </h3>
          <p class="text-sm text-base-content/60 line-clamp-2">{item.lead}</p>
        </a>
      </div>
    </section>
    """
  end

  @doc """
  A single search/list result. The whole card is the click target; anything in
  the `actions` slot (buttons, forms) stays clickable above it.
  """
  attr :href, :string, required: true
  attr :title, :string, required: true
  attr :cue, :string, required: true, doc: "call to action, e.g. \"Zobacz orzeczenie\""
  attr :compact, :boolean, default: false, doc: "smaller card for landing-page grids"
  slot :meta, doc: "date and status, shown beside the title"
  slot :inner_block, doc: "summary text and tags"
  slot :actions, doc: "interactive controls"

  def result_card(assigns) do
    ~H"""
    <article class={[
      "result-card group relative focus-within:border-primary",
      if(@compact, do: "p-5", else: "p-5 sm:p-6")
    ]}>
      <div class="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1 mb-2">
        <h3 class={["font-semibold", if(@compact, do: "text-base", else: "text-lg")]}>
          <a
            href={@href}
            class="text-primary group-hover:underline underline-offset-4 after:absolute after:inset-0 after:content-[''] focus-visible:outline-none"
          >
            {@title}
          </a>
        </h3>
        <div :if={@meta != []} class="flex flex-wrap items-center gap-3 text-sm text-base-content/60">
          {render_slot(@meta)}
        </div>
      </div>
      <div class="text-base-content/70 leading-relaxed">{render_slot(@inner_block)}</div>
      <div class="mt-3 flex flex-wrap items-center justify-between gap-3">
        <span class="inline-flex items-center gap-1 text-sm font-medium text-primary">
          {@cue}
          <.icon
            name="hero-arrow-right-mini"
            class="size-4 transition-transform group-hover:translate-x-0.5"
          />
        </span>
        <div :if={@actions != []} class="relative z-10">{render_slot(@actions)}</div>
      </div>
    </article>
    """
  end

  @doc "Small neutral tag used inside result cards. Pass `dot` for a coloured marker."
  attr :dot, :string, default: nil, doc: "background class of the marker"
  attr :tone, :string, default: "neutral", values: ~w(neutral accent urgent)
  slot :inner_block, required: true

  def tag(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-medium",
      @tone == "neutral" && "bg-base-200 text-base-content/80",
      @tone == "accent" && "bg-primary/10 text-primary",
      @tone == "urgent" && "bg-error/10 text-error"
    ]}>
      <span :if={@dot} class={["size-1.5 rounded-full", @dot]}></span>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc "Shown in place of a result list that has nothing to show."
  attr :title, :string, required: true
  attr :hint, :string, default: nil

  def empty_results(assigns) do
    ~H"""
    <div class="card-base p-12 text-center">
      <.icon name="hero-document-magnifying-glass" class="size-12 text-base-content/30 mx-auto mb-4" />
      <p class="text-base-content/70 mb-1">{@title}</p>
      <p :if={@hint} class="text-sm text-base-content/50">{@hint}</p>
    </div>
    """
  end

  @doc "Previous / next pagination. `path` builds the URL for a page number."
  attr :id, :string, default: nil
  attr :page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :path, :any, required: true, doc: "1-arity function: page -> URL"
  attr :nofollow, :boolean, default: false

  def pager(assigns) do
    ~H"""
    <nav
      :if={@total_pages > 1}
      id={@id}
      class="mt-8 flex items-center justify-center gap-3"
      aria-label="Paginacja"
    >
      <a
        :if={@page > 1}
        href={@path.(@page - 1)}
        class="btn-outline px-4 py-2 rounded-lg text-sm"
        rel={if(@nofollow, do: "nofollow", else: "prev")}
      >
        Poprzednia
      </a>
      <span class="px-3 py-2 text-base-content/60 text-sm">Strona {@page} z {@total_pages}</span>
      <a
        :if={@page < @total_pages}
        href={@path.(@page + 1)}
        class="btn-outline px-4 py-2 rounded-lg text-sm"
        rel={if(@nofollow, do: "nofollow", else: "next")}
      >
        Następna
      </a>
    </nav>
    """
  end

  @doc "Sidebar card."
  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :lead, :string, default: nil
  slot :inner_block, required: true

  def side_card(assigns) do
    ~H"""
    <div class="card-base p-6" id={@id}>
      <h2 class={["text-lg font-semibold text-base-content", if(@lead, do: "mb-1", else: "mb-4")]}>
        {@title}
      </h2>
      <p :if={@lead} class="text-sm text-base-content/60 mb-4">{@lead}</p>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc "Sidebar list of `{label, path | nil, count}` rows."
  attr :id, :string, default: nil
  attr :rows, :list, required: true

  def count_list(assigns) do
    ~H"""
    <ul class="space-y-1.5 text-sm" id={@id}>
      <li :for={{label, path, count} <- @rows} class="flex justify-between gap-3">
        <%= if path do %>
          <a href={path} class="text-primary hover:underline">{label}</a>
        <% else %>
          <span class="text-base-content/80">{label}</span>
        <% end %>
        <span class="tabular-nums text-base-content/60">{format_count(count)}</span>
      </li>
    </ul>
    """
  end

  @doc "Editorial copy of a hub, with an optional link to a guide."
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :paragraphs, :list, required: true
  attr :guide, :any, default: nil, doc: "{blog_slug, title} or nil"

  def prose_card(assigns) do
    ~H"""
    <section :if={@paragraphs != []} id={@id} class="card-base p-6 sm:p-8">
      <h2 class="text-xl font-bold text-base-content mb-4">{@title}</h2>
      <div class="space-y-4 text-base-content/80 leading-relaxed">
        <p :for={paragraph <- @paragraphs}>{paragraph}</p>
      </div>
      <%= if @guide do %>
        <% {slug, guide_title} = @guide %>
        <a
          href={"/blog/#{slug}"}
          class="mt-6 inline-flex items-center gap-2 text-primary font-medium hover:underline"
        >
          <.icon name="hero-book-open" class="size-5" /> Poradnik: {guide_title}
        </a>
      <% end %>
    </section>
    """
  end

  @doc "Links to the newest guides. Renders nothing when there are none."
  attr :articles, :list, required: true
  attr :title, :string, default: "Poradniki dotyczące zamówień publicznych"

  def guides(assigns) do
    ~H"""
    <section :if={@articles != []} class="mb-14" id="guides">
      <h2 class="text-2xl font-bold text-base-content mb-6">{@title}</h2>
      <div class="grid gap-4 md:grid-cols-3">
        <a :for={article <- @articles} href={"/blog/#{article.slug}"} class="pricing-card p-5 block">
          <h3 class="font-semibold text-base-content mb-2 line-clamp-2">{article.title}</h3>
          <p class="text-sm text-base-content/60 line-clamp-3">{article.excerpt}</p>
        </a>
      </div>
    </section>
    """
  end

  @doc "FAQ accordion with FAQPage structured data. Renders nothing for an empty list."
  attr :id, :string, required: true
  attr :faqs, :list, required: true
  attr :title, :string, default: "Najczęstsze pytania"

  def faq_section(assigns) do
    ~H"""
    <section :if={@faqs != []}>
      <script type="application/ld+json">
        <%= Phoenix.HTML.raw(Jason.encode!(%{
          "@context" => "https://schema.org",
          "@type" => "FAQPage",
          "mainEntity" => Enum.map(@faqs, fn faq ->
            %{
              "@type" => "Question",
              "name" => faq.question,
              "acceptedAnswer" => %{"@type" => "Answer", "text" => faq.answer}
            }
          end)
        })) %>
      </script>
      <h2 class="text-xl font-bold text-base-content mb-5">{@title}</h2>
      <div id={@id} class="space-y-4">
        <details :for={faq <- @faqs} class="card-base p-5 group">
          <summary class="font-semibold text-base-content cursor-pointer list-none flex items-center justify-between gap-4">
            {faq.question}
            <.icon
              name="hero-chevron-down"
              class="size-5 shrink-0 text-base-content/50 group-open:rotate-180 transition-transform"
            />
          </summary>
          <p class="mt-4 text-base-content/70 leading-relaxed">{faq.answer}</p>
        </details>
      </div>
    </section>
    """
  end

  @doc """
  "Browse" block at the foot of hub pages. `columns` is a list of
  `%{id, title, links: [{path, label}]}`; the link matching `current` is
  rendered as the current page.
  """
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :columns, :list, required: true
  attr :current, :string, default: nil

  def link_columns(assigns) do
    ~H"""
    <section id={@id} class="mt-14 card-base p-6 sm:p-8">
      <h2 class="text-xl font-bold text-base-content mb-6">{@title}</h2>
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
        <div :for={column <- @columns}>
          <h3 class="text-sm font-semibold uppercase tracking-wider text-base-content/60 mb-3">
            {column.title}
          </h3>
          <ul class="space-y-2 text-sm" id={column.id}>
            <li :for={{path, label} <- column.links}>
              <%= if path == @current do %>
                <span class="font-semibold text-base-content" aria-current="page">{label}</span>
              <% else %>
                <a href={path} class="text-primary hover:underline">{label}</a>
              <% end %>
            </li>
          </ul>
        </div>
      </div>
    </section>
    """
  end
end
