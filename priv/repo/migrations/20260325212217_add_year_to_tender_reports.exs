defmodule Przetargowi.Repo.Migrations.AddYearToTenderReports do
  use Ecto.Migration

  def change do
    alter table(:tender_reports) do
      add :year, :integer
    end

    create index(:tender_reports, [:year])

    # Backfill year from report_month
    execute(
      "UPDATE tender_reports SET year = EXTRACT(YEAR FROM report_month)::integer",
      "SELECT 1"
    )
  end
end
