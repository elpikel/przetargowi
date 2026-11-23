defmodule Przetargowi.Repo.Migrations.RestyleBlogArticleInlineColors do
  use Ecto.Migration

  # Blog articles carry inline styles written for the old cream/navy/gold look
  # (dark gradient callouts with gold text, gold buttons and highlights). The
  # site now uses white surfaces with a blue accent, so rewrite those inline
  # colours to match. Order matters: compound declarations (background + text
  # colour of the same element) are rewritten before the single-colour rules.
  @replacements [
    # Dark gradient callout -> light tinted callout
    {"background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border: 1px solid rgba(212, 175, 55, 0.3);",
     "background: #f3f6ff; border: 1px solid #d5defa;"},
    # Buttons
    {"display: inline-block; background: linear-gradient(135deg, #d4af37 0%, #c9a227 100%); color: #1a1a2e;",
     "display: inline-block; background: #2347d9; color: #ffffff;"},
    {"display: inline-block; background: #d4af37; color: #1a1a2e;",
     "display: inline-block; background: #2347d9; color: #ffffff;"},
    {"display: inline-block; background: #1a1a2e; color: #d4af37;",
     "display: inline-block; background: #2347d9; color: #ffffff;"},
    # Gold gradient banner -> light tinted callout
    {"background: linear-gradient(135deg, #d4af37 0%, #c9a227 100%); border-radius: 12px;",
     "background: #f3f6ff; border: 1px solid #d5defa; border-radius: 12px;"},
    # Dark table headers
    {"background: #1a1a2e; color: #d4af37;", "background: #0f172a; color: #ffffff;"},
    {"background: linear-gradient(135deg, #12233d 0%, #1a3052 100%); color: #fefcf8;",
     "background: #0f172a; color: #ffffff;"},
    {"border: 1px solid #234168", "border: 1px solid #1e293b"},
    # Borders, highlights and surfaces
    {"border: 1px solid rgba(212, 175, 55, 0.3)", "border: 1px solid #d5defa"},
    {"background: rgba(212, 175, 55, 0.2)", "background: rgba(35, 71, 217, 0.1)"},
    {"border-left: 4px solid #d4af37", "border-left: 4px solid #2347d9"},
    {"background: #f3e4c3", "background: #e4e7ec"},
    {"border: 1px solid #f3e4c3", "border: 1px solid #e4e7ec"},
    {"background: #fdf8ed", "background: #f6f7f9"},
    # Text colours that assumed a dark background
    {"color: #d4af37", "color: #2347d9"},
    {"color: #e0e0e0", "color: #334155"},
    {"color: #1a1a2e", "color: #0f172a"}
  ]

  def up do
    for {from, to} <- @replacements do
      execute(fn ->
        repo().query!(
          """
          UPDATE articles
          SET content = replace(content, $1, $2), updated_at = now()
          WHERE position($1 in content) > 0
          """,
          [from, to]
        )
      end)
    end
  end

  # Presentation-only rewrite; the old colours are not worth restoring.
  def down, do: :ok
end
