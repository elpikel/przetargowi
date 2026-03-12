defmodule Przetargowi.ProfilesTest do
  use Przetargowi.DataCase

  alias Przetargowi.Profiles
  alias Przetargowi.Profiles.CompanyProfile

  import Przetargowi.AccountsFixtures
  import Przetargowi.ProfilesFixtures

  describe "get_profile/1" do
    test "returns profile by id" do
      profile = profile_fixture()
      assert %CompanyProfile{id: id} = Profiles.get_profile(profile.id)
      assert id == profile.id
    end

    test "returns nil for non-existent id" do
      assert Profiles.get_profile(-1) == nil
    end
  end

  describe "get_profile_by_user/1" do
    test "returns profile by user_id" do
      user = user_fixture()
      profile = profile_fixture(user: user)
      assert %CompanyProfile{id: id} = Profiles.get_profile_by_user(user.id)
      assert id == profile.id
    end

    test "returns nil when user has no profile" do
      user = user_fixture()
      assert Profiles.get_profile_by_user(user.id) == nil
    end
  end

  describe "create_profile/1" do
    test "creates profile with valid attributes" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id)

      assert {:ok, %CompanyProfile{} = profile} = Profiles.create_profile(attrs)
      assert profile.company_name == "Firma Testowa Sp. z o.o."
      assert String.length(profile.nip) == 10
      assert profile.legal_form == :sp_z_oo
      assert profile.msp_status == :small
      assert length(profile.representatives) == 1
    end

    test "fails without required fields" do
      assert {:error, changeset} = Profiles.create_profile(%{})
      assert %{user_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "enforces unique nip" do
      profile = profile_fixture()
      user = user_fixture()

      attrs = valid_profile_attributes(user_id: user.id, nip: profile.nip)
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{nip: ["has already been taken"]} = errors_on(changeset)
    end

    test "enforces unique user_id" do
      user = user_fixture()
      _profile = profile_fixture(user: user)

      # Use a different valid NIP
      attrs = valid_profile_attributes(user_id: user.id, nip: "7811767696")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{user_id: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "update_profile/2" do
    test "updates profile with valid attributes" do
      profile = profile_fixture()

      assert {:ok, updated} =
               Profiles.update_profile(profile, %{company_name: "Nowa Nazwa Sp. z o.o."})

      assert updated.company_name == "Nowa Nazwa Sp. z o.o."
    end

    test "fails with invalid attributes" do
      profile = profile_fixture()
      assert {:error, changeset} = Profiles.update_profile(profile, %{nip: "invalid"})
      assert %{nip: ["musi mieć 10 cyfr"]} = errors_on(changeset)
    end
  end

  describe "NIP validation" do
    test "accepts valid NIP" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, nip: "5261040828")
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.nip == "5261040828"
    end

    test "normalizes NIP with dashes" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, nip: "526-104-08-28")
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.nip == "5261040828"
    end

    test "rejects NIP with wrong length" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, nip: "123456789")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{nip: ["musi mieć 10 cyfr"]} = errors_on(changeset)
    end

    test "rejects NIP with invalid checksum" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, nip: "1234567890")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{nip: ["nieprawidłowa suma kontrolna"]} = errors_on(changeset)
    end
  end

  describe "REGON validation" do
    test "accepts valid 9-digit REGON" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, regon: "012100784")
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.regon == "012100784"
    end

    test "rejects 14-digit REGON with invalid checksum" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, regon: "01210078400000")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{regon: ["nieprawidłowa suma kontrolna"]} = errors_on(changeset)
    end

    test "rejects REGON with wrong length" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, regon: "12345678")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{regon: ["musi mieć 9 lub 14 cyfr"]} = errors_on(changeset)
    end

    test "rejects REGON with invalid checksum" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, regon: "123456789")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{regon: ["nieprawidłowa suma kontrolna"]} = errors_on(changeset)
    end
  end

  describe "KRS validation" do
    test "accepts valid KRS" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, krs: "0000123456")
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.krs == "0000123456"
    end

    test "allows nil KRS" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id) |> Map.delete(:krs)
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.krs == nil
    end

    test "rejects KRS with wrong length" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, krs: "123456")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{krs: ["musi mieć 10 cyfr"]} = errors_on(changeset)
    end
  end

  describe "postal code validation" do
    test "accepts valid postal code format" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, postal_code: "00-001")
      assert {:ok, _} = Profiles.create_profile(attrs)
    end

    test "rejects invalid postal code format" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, postal_code: "00001")
      assert {:error, changeset} = Profiles.create_profile(attrs)
      assert %{postal_code: ["musi być w formacie XX-XXX"]} = errors_on(changeset)
    end
  end

  describe "representatives" do
    test "creates profile with multiple representatives" do
      user = user_fixture()

      attrs =
        valid_profile_attributes(
          user_id: user.id,
          representatives: [
            %{full_name: "Jan Kowalski", position: "Prezes Zarządu", is_primary: true},
            %{full_name: "Anna Nowak", position: "Wiceprezes", is_primary: false}
          ]
        )

      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert length(profile.representatives) == 2
    end

    test "updates representatives" do
      profile = profile_fixture()

      assert {:ok, updated} =
               Profiles.update_profile(profile, %{
                 representatives: [
                   %{full_name: "Nowy Prezes", position: "Prezes Zarządu", is_primary: true}
                 ]
               })

      assert length(updated.representatives) == 1
      assert hd(updated.representatives).full_name == "Nowy Prezes"
    end
  end

  describe "legal_form enum" do
    test "accepts osoba_fizyczna" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, legal_form: :osoba_fizyczna)
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.legal_form == :osoba_fizyczna
    end

    test "accepts sp_z_oo" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, legal_form: :sp_z_oo)
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.legal_form == :sp_z_oo
    end
  end

  describe "msp_status enum" do
    test "accepts micro status" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, msp_status: :micro)
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.msp_status == :micro
    end

    test "accepts large status" do
      user = user_fixture()
      attrs = valid_profile_attributes(user_id: user.id, msp_status: :large)
      assert {:ok, profile} = Profiles.create_profile(attrs)
      assert profile.msp_status == :large
    end
  end
end
