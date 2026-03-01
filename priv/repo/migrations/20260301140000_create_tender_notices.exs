defmodule Przetargowi.Repo.Migrations.CreateTenderNotices do
  use Ecto.Migration

  def change do
    create table(:tender_notices, primary_key: false) do
      add :object_id, :string, primary_key: true
      add :client_type, :string
      add :order_type, :string
      add :tender_type, :string
      add :notice_type, :string
      add :notice_number, :string
      add :bzp_number, :string
      add :is_tender_amount_below_eu, :boolean
      add :publication_date, :utc_datetime
      add :order_object, :text
      add :cpv_codes, {:array, :string}, default: []
      add :submitting_offers_date, :utc_datetime
      add :procedure_result, :string
      add :organization_name, :string
      add :organization_city, :string
      add :organization_province, :string
      add :organization_country, :string
      add :organization_national_id, :string
      add :organization_id, :string
      add :tender_id, :string
      add :html_body, :text
      add :estimated_values, {:array, :decimal}, default: []
      add :estimated_value, :decimal
      add :total_contract_value, :decimal
      add :total_contractors_contracts_count, :integer
      add :cancelled_count, :integer

      # Parsed fields from BZP HTML
      add :wadium, :string
      add :wadium_amount, :decimal
      add :kryteria, {:array, :map}, default: []
      add :okres_realizacji_from, :date
      add :okres_realizacji_to, :date
      add :okres_realizacji_raw, :string
      add :opis_przedmiotu, :text
      add :warunki_udzialu, :text
      add :cpv_main, :string
      add :cpv_additional, {:array, :string}, default: []
      add :numer_referencyjny, :string
      add :oferty_czesciowe, :boolean
      add :zabezpieczenie, :boolean
      add :organization_email, :string
      add :organization_www, :string
      add :organization_regon, :string
      add :organization_street, :string
      add :organization_postal_code, :string
      add :evaluation_criteria, :text

      # Embedded JSON for contractors
      add :contractors, {:array, :map}, default: []
      add :contractors_contract_details, {:array, :map}, default: []

      timestamps()
    end

    create index(:tender_notices, [:notice_type])
    create index(:tender_notices, [:organization_province])
    create index(:tender_notices, [:order_type])
    create index(:tender_notices, [:submitting_offers_date])
    create index(:tender_notices, [:publication_date])
    create unique_index(:tender_notices, [:bzp_number])
  end
end
