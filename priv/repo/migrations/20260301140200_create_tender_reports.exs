defmodule Przetargowi.Repo.Migrations.CreateTenderReports do
  use Ecto.Migration

  def change do
    create table(:tender_reports) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :region, :string
      add :order_type, :string
      add :report_month, :date, null: false
      add :cover_image_url, :string
      add :report_type, :string, null: false
      add :report_data, :map, null: false
      add :introduction_html, :text, null: false
      add :analysis_html, :text, null: false
      add :upsell_html, :text
      add :graphs, :map
      add :meta_description, :string

      timestamps()
    end

    create unique_index(:tender_reports, [:slug])
    create index(:tender_reports, [:region])
    create index(:tender_reports, [:order_type])
    create index(:tender_reports, [:report_month])
    create index(:tender_reports, [:report_type])
  end
end
