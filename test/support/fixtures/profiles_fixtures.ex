defmodule Przetargowi.ProfilesFixtures do
  @moduledoc """
  Test helpers for creating entities via the `Przetargowi.Profiles` context.
  """

  alias Przetargowi.Profiles

  import Przetargowi.AccountsFixtures

  def valid_nip, do: "5261040828"
  def valid_regon_9, do: "012100784"
  def valid_krs, do: "0000123456"

  # Pool of verified valid NIPs (all have correct checksums)
  @valid_nips [
    "5261040828",
    "7811767696",
    "5213017228",
    "5252344078",
    "5272525995",
    "1132191233",
    "5260250995"
  ]

  def unique_nip do
    index = System.unique_integer([:positive])
    Enum.at(@valid_nips, rem(index, length(@valid_nips)))
  end

  def valid_profile_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      company_name: "Firma Testowa Sp. z o.o.",
      company_short_name: "Firma Testowa",
      nip: unique_nip(),
      regon: valid_regon_9(),
      krs: valid_krs(),
      legal_form: :sp_z_oo,
      street: "ul. Testowa 1",
      postal_code: "00-001",
      city: "Warszawa",
      voivodeship: "mazowieckie",
      country: "Polska",
      email: "kontakt@firma-testowa.pl",
      phone: "+48 123 456 789",
      website: "https://firma-testowa.pl",
      epuap_address: "/FirmaTestowa/SkrytkaESP",
      msp_status: :small,
      capital_group_members: [],
      bank_name: "PKO BP",
      bank_account: "PL61109010140000071219812874",
      representatives: [
        %{full_name: "Jan Kowalski", position: "Prezes Zarządu", is_primary: true}
      ]
    })
  end

  def profile_fixture(attrs \\ []) do
    attrs = Map.new(attrs)
    user = Map.get_lazy(attrs, :user, fn -> user_fixture() end)

    {:ok, profile} =
      attrs
      |> Map.delete(:user)
      |> valid_profile_attributes()
      |> Map.put(:user_id, user.id)
      |> Profiles.create_profile()

    profile
  end
end
