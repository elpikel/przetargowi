defmodule Przetargowi.Repo.Migrations.CreateCompanyProfiles do
  use Ecto.Migration

  def change do
    create table(:company_profiles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      # Identity
      add :company_name, :string, null: false
      add :company_short_name, :string
      add :nip, :string, null: false
      add :regon, :string, null: false
      add :krs, :string
      add :legal_form, :string, null: false

      # Address
      add :street, :string, null: false
      add :postal_code, :string, null: false
      add :city, :string, null: false
      add :voivodeship, :string, null: false
      add :country, :string, null: false, default: "Polska"

      # Contact
      add :email, :string, null: false
      add :phone, :string, null: false
      add :website, :string
      add :epuap_address, :string

      # Representatives (embedded as JSONB)
      add :representatives, {:array, :map}, null: false, default: []

      # Procurement-specific
      add :msp_status, :string, null: false
      add :capital_group_members, {:array, :string}, null: false, default: []
      add :bank_name, :string
      add :bank_account, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:company_profiles, [:nip])
    create unique_index(:company_profiles, [:user_id])
    create index(:company_profiles, [:legal_form])
    create index(:company_profiles, [:city])
    create index(:company_profiles, [:voivodeship])
  end
end
