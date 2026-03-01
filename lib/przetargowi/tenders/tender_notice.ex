defmodule Przetargowi.Tenders.TenderNotice do
  @moduledoc """
  Schema for public tenders notices from BZP.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @notice_types [
    "ContractNotice",
    "AgreementIntentionNotice",
    "TenderResultNotice",
    "CompetitionNotice",
    "CompetitionResultNotice",
    "NoticeUpdateNotice",
    "AgreementUpdateNotice",
    "ContractPerformingNotice",
    "CircumstancesFulfillmentNotice",
    "SmallContractNotice",
    "ConcessionNotice",
    "ConcessionIntentionAgreementNotice",
    "NoticeUpdateConcession",
    "ConcessionAgreementNotice",
    "ConcessionUpdateAgreementNotice"
  ]

  @primary_key {:object_id, :string, autogenerate: false}
  schema "tender_notices" do
    field :client_type, :string
    field :order_type, :string
    field :tender_type, :string
    field :notice_type, :string
    field :notice_number, :string
    field :bzp_number, :string
    field :is_tender_amount_below_eu, :boolean
    field :publication_date, :utc_datetime
    field :order_object, :string
    field :cpv_codes, {:array, :string}, default: []
    field :submitting_offers_date, :utc_datetime
    field :procedure_result, :string
    field :organization_name, :string
    field :organization_city, :string
    field :organization_province, :string
    field :organization_country, :string
    field :organization_national_id, :string
    field :organization_id, :string
    field :tender_id, :string
    field :html_body, :string
    field :estimated_values, {:array, :decimal}, default: []
    field :estimated_value, :decimal
    field :total_contract_value, :decimal
    field :total_contractors_contracts_count, :integer
    field :cancelled_count, :integer

    # Parsed fields from BZP HTML
    field :wadium, :string
    field :wadium_amount, :decimal
    field :kryteria, {:array, :map}, default: []
    field :okres_realizacji_from, :date
    field :okres_realizacji_to, :date
    field :okres_realizacji_raw, :string
    field :opis_przedmiotu, :string
    field :warunki_udzialu, :string
    field :cpv_main, :string
    field :cpv_additional, {:array, :string}, default: []
    field :numer_referencyjny, :string
    field :oferty_czesciowe, :boolean
    field :zabezpieczenie, :boolean
    field :organization_email, :string
    field :organization_www, :string
    field :organization_regon, :string
    field :organization_street, :string
    field :organization_postal_code, :string
    field :evaluation_criteria, :string
    field :slug, :string

    embeds_many :contractors, Przetargowi.Tenders.Contractor
    embeds_many :contractors_contract_details, Przetargowi.Tenders.ContractDetails

    timestamps()
  end

  @doc false
  def changeset(tender, attrs) do
    tender
    |> cast(attrs, [
      :object_id,
      :client_type,
      :order_type,
      :tender_type,
      :notice_type,
      :notice_number,
      :bzp_number,
      :is_tender_amount_below_eu,
      :publication_date,
      :order_object,
      :cpv_codes,
      :submitting_offers_date,
      :procedure_result,
      :organization_name,
      :organization_city,
      :organization_province,
      :organization_country,
      :organization_national_id,
      :organization_id,
      :tender_id,
      :html_body,
      :estimated_values,
      :estimated_value,
      :total_contract_value,
      :total_contractors_contracts_count,
      :cancelled_count,
      :wadium,
      :wadium_amount,
      :kryteria,
      :okres_realizacji_from,
      :okres_realizacji_to,
      :okres_realizacji_raw,
      :opis_przedmiotu,
      :warunki_udzialu,
      :cpv_main,
      :cpv_additional,
      :numer_referencyjny,
      :oferty_czesciowe,
      :zabezpieczenie,
      :organization_email,
      :organization_www,
      :organization_regon,
      :organization_street,
      :organization_postal_code,
      :evaluation_criteria,
      :slug
    ])
    |> cast_embed(:contractors)
    |> cast_embed(:contractors_contract_details)
    |> validate_required([
      :object_id,
      :notice_type,
      :notice_number,
      :bzp_number,
      :is_tender_amount_below_eu,
      :publication_date,
      :cpv_codes,
      :organization_name,
      :organization_city,
      :organization_country,
      :organization_national_id,
      :organization_id,
      :html_body
    ])
    |> maybe_generate_slug()
    |> unique_constraint(:slug)
  end

  defp maybe_generate_slug(changeset) do
    case {get_field(changeset, :slug), get_field(changeset, :order_object),
          get_field(changeset, :object_id)} do
      {nil, order_object, object_id} when is_binary(order_object) and is_binary(object_id) ->
        put_change(changeset, :slug, generate_slug(order_object, object_id))

      {nil, _, object_id} when is_binary(object_id) ->
        put_change(changeset, :slug, object_id)

      _ ->
        changeset
    end
  end

  @doc """
  Generates a URL-friendly slug from the order_object (tender title) and object_id.
  """
  def generate_slug(order_object, object_id)
      when is_binary(order_object) and is_binary(object_id) do
    base_slug =
      order_object
      |> String.downcase()
      |> String.replace(~r/[\/\\]/, "-")
      |> String.replace(~r/\s+/, "-")
      |> String.replace(~r/[^a-z0-9\-]/, "")
      |> String.replace(~r/-+/, "-")
      |> String.trim("-")
      |> String.slice(0, 100)

    "#{base_slug}-#{object_id}"
  end

  def generate_slug(_, object_id) when is_binary(object_id), do: object_id
  def generate_slug(_, _), do: nil

  def notice_types, do: @notice_types
end
