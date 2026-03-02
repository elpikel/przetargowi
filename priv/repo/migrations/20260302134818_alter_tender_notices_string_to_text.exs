defmodule Przetargowi.Repo.Migrations.AlterTenderNoticesStringToText do
  use Ecto.Migration

  def change do
    alter table(:tender_notices) do
      # All string fields to text
      modify :client_type, :text, from: :string
      modify :order_type, :text, from: :string
      modify :tender_type, :text, from: :string
      modify :notice_type, :text, from: :string
      modify :notice_number, :text, from: :string
      modify :bzp_number, :text, from: :string
      modify :procedure_result, :text, from: :string
      modify :organization_name, :text, from: :string
      modify :organization_city, :text, from: :string
      modify :organization_province, :text, from: :string
      modify :organization_country, :text, from: :string
      modify :organization_national_id, :text, from: :string
      modify :organization_id, :text, from: :string
      modify :tender_id, :text, from: :string
      modify :wadium, :text, from: :string
      modify :okres_realizacji_raw, :text, from: :string
      modify :cpv_main, :text, from: :string
      modify :numer_referencyjny, :text, from: :string
      modify :organization_email, :text, from: :string
      modify :organization_www, :text, from: :string
      modify :organization_regon, :text, from: :string
      modify :organization_street, :text, from: :string
      modify :organization_postal_code, :text, from: :string
      modify :slug, :text, from: :string

      # Array fields to text arrays
      modify :cpv_codes, {:array, :text}, from: {:array, :string}
      modify :cpv_additional, {:array, :text}, from: {:array, :string}
    end
  end
end
