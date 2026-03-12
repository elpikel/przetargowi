defmodule Przetargowi.Profiles.CompanyProfile do
  @moduledoc """
  Schema for company profiles used to auto-fill Polish public procurement
  (zamówienia publiczne) documents for an executor (wykonawca).
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Przetargowi.Accounts.User
  alias Przetargowi.Profiles.Representative

  @legal_forms ~w(osoba_fizyczna spolka_cywilna sp_z_oo spolka_akcyjna jednoosobowa_dg other)a
  @msp_statuses ~w(micro small medium large)a

  schema "company_profiles" do
    # Identity
    field :company_name, :string
    field :company_short_name, :string
    field :nip, :string
    field :regon, :string
    field :krs, :string
    field :legal_form, Ecto.Enum, values: @legal_forms

    # Address
    field :street, :string
    field :postal_code, :string
    field :city, :string
    field :voivodeship, :string
    field :country, :string, default: "Polska"

    # Contact
    field :email, :string
    field :phone, :string
    field :website, :string
    field :epuap_address, :string

    # Representatives
    embeds_many :representatives, Representative, on_replace: :delete

    # Procurement-specific
    field :msp_status, Ecto.Enum, values: @msp_statuses
    field :capital_group_members, {:array, :string}, default: []
    field :bank_name, :string
    field :bank_account, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc """
  Returns all valid legal forms.
  """
  def legal_forms, do: @legal_forms

  @doc """
  Returns all valid MSP statuses.
  """
  def msp_statuses, do: @msp_statuses

  @doc """
  Changeset for creating a new company profile.
  """
  def create_changeset(profile \\ %__MODULE__{}, attrs) do
    profile
    |> cast(attrs, [
      :user_id,
      :company_name,
      :company_short_name,
      :nip,
      :regon,
      :krs,
      :legal_form,
      :street,
      :postal_code,
      :city,
      :voivodeship,
      :country,
      :email,
      :phone,
      :website,
      :epuap_address,
      :msp_status,
      :capital_group_members,
      :bank_name,
      :bank_account
    ])
    |> cast_embed(:representatives)
    |> validate_required([
      :user_id,
      :company_name,
      :nip,
      :regon,
      :legal_form,
      :street,
      :postal_code,
      :city,
      :voivodeship,
      :email,
      :phone,
      :msp_status
    ])
    |> validate_nip()
    |> validate_regon()
    |> validate_krs()
    |> validate_postal_code()
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/, message: "nieprawidłowy format email")
    |> validate_format(:phone, ~r/^[+]?[\d\s\-()]{9,20}$/, message: "nieprawidłowy format telefonu")
    |> validate_inclusion(:legal_form, @legal_forms)
    |> validate_inclusion(:msp_status, @msp_statuses)
    |> unique_constraint(:nip)
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end

  @doc """
  Changeset for updating an existing company profile.
  """
  def update_changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :company_name,
      :company_short_name,
      :nip,
      :regon,
      :krs,
      :legal_form,
      :street,
      :postal_code,
      :city,
      :voivodeship,
      :country,
      :email,
      :phone,
      :website,
      :epuap_address,
      :msp_status,
      :capital_group_members,
      :bank_name,
      :bank_account
    ])
    |> cast_embed(:representatives)
    |> validate_required([
      :company_name,
      :nip,
      :regon,
      :legal_form,
      :street,
      :postal_code,
      :city,
      :voivodeship,
      :email,
      :phone,
      :msp_status
    ])
    |> validate_nip()
    |> validate_regon()
    |> validate_krs()
    |> validate_postal_code()
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/, message: "nieprawidłowy format email")
    |> validate_format(:phone, ~r/^[+]?[\d\s\-()]{9,20}$/, message: "nieprawidłowy format telefonu")
    |> validate_inclusion(:legal_form, @legal_forms)
    |> validate_inclusion(:msp_status, @msp_statuses)
    |> unique_constraint(:nip)
  end

  # NIP validation with check digit algorithm
  defp validate_nip(changeset) do
    case get_change(changeset, :nip) do
      nil -> changeset
      nip -> do_validate_nip(changeset, nip)
    end
  end

  defp do_validate_nip(changeset, nip) do
    # Remove any non-digit characters
    digits = String.replace(nip, ~r/\D/, "")

    cond do
      String.length(digits) != 10 ->
        add_error(changeset, :nip, "musi mieć 10 cyfr")

      not valid_nip_checksum?(digits) ->
        add_error(changeset, :nip, "nieprawidłowa suma kontrolna")

      true ->
        # Store normalized (digits only) version
        put_change(changeset, :nip, digits)
    end
  end

  defp valid_nip_checksum?(digits) do
    weights = [6, 5, 7, 2, 3, 4, 5, 6, 7]

    {check_digit, first_nine} =
      digits
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> List.pop_at(9)

    sum =
      first_nine
      |> Enum.zip(weights)
      |> Enum.reduce(0, fn {digit, weight}, acc -> acc + digit * weight end)

    rem(sum, 11) == check_digit
  end

  # REGON validation with check digit algorithm
  defp validate_regon(changeset) do
    case get_change(changeset, :regon) do
      nil -> changeset
      regon -> do_validate_regon(changeset, regon)
    end
  end

  defp do_validate_regon(changeset, regon) do
    # Remove any non-digit characters
    digits = String.replace(regon, ~r/\D/, "")

    cond do
      String.length(digits) not in [9, 14] ->
        add_error(changeset, :regon, "musi mieć 9 lub 14 cyfr")

      not valid_regon_checksum?(digits) ->
        add_error(changeset, :regon, "nieprawidłowa suma kontrolna")

      true ->
        # Store normalized (digits only) version
        put_change(changeset, :regon, digits)
    end
  end

  defp valid_regon_checksum?(digits) when byte_size(digits) == 9 do
    weights = [8, 9, 2, 3, 4, 5, 6, 7]

    {check_digit, first_eight} =
      digits
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> List.pop_at(8)

    sum =
      first_eight
      |> Enum.zip(weights)
      |> Enum.reduce(0, fn {digit, weight}, acc -> acc + digit * weight end)

    calculated = rem(sum, 11)
    # If remainder is 10, check digit should be 0
    (calculated == 10 and check_digit == 0) or calculated == check_digit
  end

  defp valid_regon_checksum?(digits) when byte_size(digits) == 14 do
    # First validate the 9-digit base
    base_9 = String.slice(digits, 0, 9)

    if valid_regon_checksum?(base_9) do
      # Then validate the full 14-digit REGON
      weights = [2, 4, 8, 5, 0, 9, 7, 3, 6, 1, 2, 4, 8]

      {check_digit, first_thirteen} =
        digits
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
        |> List.pop_at(13)

      sum =
        first_thirteen
        |> Enum.zip(weights)
        |> Enum.reduce(0, fn {digit, weight}, acc -> acc + digit * weight end)

      calculated = rem(sum, 11)
      (calculated == 10 and check_digit == 0) or calculated == check_digit
    else
      false
    end
  end

  defp valid_regon_checksum?(_), do: false

  # KRS validation (10 digits, nullable)
  defp validate_krs(changeset) do
    case get_change(changeset, :krs) do
      nil -> changeset
      "" -> changeset
      krs -> do_validate_krs(changeset, krs)
    end
  end

  defp do_validate_krs(changeset, krs) do
    digits = String.replace(krs, ~r/\D/, "")

    if String.length(digits) == 10 do
      put_change(changeset, :krs, digits)
    else
      add_error(changeset, :krs, "musi mieć 10 cyfr")
    end
  end

  # Postal code validation (XX-XXX format)
  defp validate_postal_code(changeset) do
    validate_format(changeset, :postal_code, ~r/^\d{2}-\d{3}$/,
      message: "musi być w formacie XX-XXX"
    )
  end

end
