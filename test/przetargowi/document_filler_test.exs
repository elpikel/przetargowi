defmodule Przetargowi.DocumentFillerTest do
  use ExUnit.Case, async: true

  alias Przetargowi.DocumentFiller
  alias Przetargowi.DocxTestHelper
  alias Przetargowi.Profiles.CompanyProfile

  @sample_profile %CompanyProfile{
    id: 1,
    company_name: "Test Sp. z o.o.",
    company_short_name: "Test",
    legal_form: :sp_z_oo,
    nip: "1234567890",
    regon: "123456789",
    krs: "0000123456",
    street: "ul. Testowa 15/3",
    postal_code: "00-001",
    city: "Warszawa",
    voivodeship: "mazowieckie",
    email: "test@example.com",
    phone: "+48 123 456 789",
    website: "https://test.pl",
    epuap_address: "/test/SkrytkaESP",
    msp_status: :small,
    bank_name: "Bank Test S.A.",
    bank_account: "PL 12 3456 7890 1234 5678 9012 3456",
    is_primary: true,
    representatives: [
      %{full_name: "Jan Kowalski", position: "Prezes Zarządu", is_primary: true},
      %{full_name: "Anna Nowak", position: "Wiceprezes", is_primary: false}
    ]
  }

  describe "fill_document_from_file/2" do
    test "fills formularz ofertowy placeholders" do
      docx = DocxTestHelper.create_formularz_ofertowy()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "Test Sp. z o.o.")
      assert String.contains?(text, "ul. Testowa 15/3, 00-001 Warszawa")
      assert String.contains?(text, "1234567890")
      assert String.contains?(text, "123456789")
      assert String.contains?(text, "0000123456")
      assert String.contains?(text, "+48 123 456 789")
      assert String.contains?(text, "test@example.com")
      assert String.contains?(text, "/test/SkrytkaESP")
      assert String.contains?(text, "Jan Kowalski, Prezes Zarządu")

      File.rm!(tmp_path)
    end

    test "fills oświadczenie placeholders" do
      docx = DocxTestHelper.create_oswiadczenie()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "Test Sp. z o.o.")
      assert String.contains?(text, "ul. Testowa 15/3, 00-001 Warszawa")
      assert String.contains?(text, "1234567890")
      assert String.contains?(text, "123456789")
      assert String.contains?(text, "Jan Kowalski")
      assert String.contains?(text, "Prezes Zarządu")

      File.rm!(tmp_path)
    end

    test "handles mixed case placeholders" do
      docx = DocxTestHelper.create_mixed_case_placeholders()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      # Should fill both lowercase and uppercase variants
      refute String.contains?(text, "[nazwa wykonawcy]")
      refute String.contains?(text, "[NAZWA WYKONAWCY]")
      refute String.contains?(text, "[nip]")
      refute String.contains?(text, "[NIP]")

      # Should contain the actual values
      assert String.contains?(text, "Test Sp. z o.o.")
      assert String.contains?(text, "1234567890")
      assert String.contains?(text, "test@example.com")

      File.rm!(tmp_path)
    end

    test "preserves document without placeholders" do
      docx = DocxTestHelper.create_no_placeholders()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "Ten dokument nie zawiera żadnych pól do wypełnienia.")
      assert String.contains?(text, "Jest to zwykły tekst bez placeholderów.")

      File.rm!(tmp_path)
    end

    test "returns valid DOCX that can be reopened" do
      docx = DocxTestHelper.create_formularz_ofertowy()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      # Verify it's a valid ZIP (DOCX)
      assert String.starts_with?(filled_binary, "PK")

      # Verify we can open it as a ZIP
      {:ok, zip_handle} = :zip.zip_open(filled_binary, [:memory])
      {:ok, entries} = :zip.zip_list_dir(zip_handle)
      :zip.zip_close(zip_handle)

      entry_names =
        Enum.map(entries, fn
          {:zip_file, name, _, _, _, _} -> to_string(name)
          _ -> nil
        end)
        |> Enum.filter(& &1)

      assert "word/document.xml" in entry_names
      assert "[Content_Types].xml" in entry_names

      File.rm!(tmp_path)
    end

    test "handles profile with missing optional fields" do
      profile = %CompanyProfile{
        id: 2,
        company_name: "Simple Company",
        nip: "9876543210",
        regon: "987654321",
        street: "ul. Prosta 1",
        postal_code: "00-002",
        city: "Kraków",
        voivodeship: "malopolskie",
        email: "simple@example.com",
        phone: "+48 987 654 321",
        msp_status: :micro,
        legal_form: :jdg,
        is_primary: false,
        # Missing: krs, website, epuap_address, bank_name, bank_account, representatives
        krs: nil,
        website: nil,
        epuap_address: nil,
        bank_name: nil,
        bank_account: nil,
        representatives: []
      }

      docx = DocxTestHelper.create_formularz_ofertowy()
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "Simple Company")
      assert String.contains?(text, "9876543210")
      # KRS placeholder should remain empty or unchanged
      # since the profile has no KRS

      File.rm!(tmp_path)
    end

    test "returns error for non-existent file" do
      result = DocumentFiller.fill_document_from_file("/nonexistent/file.docx", @sample_profile)

      assert {:error, :enoent} = result
    end

    test "returns error for invalid file (not a DOCX)" do
      tmp_path = System.tmp_dir!() |> Path.join("invalid_#{:rand.uniform(10000)}.docx")
      File.write!(tmp_path, "not a valid docx file")

      result = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      assert {:error, _} = result

      File.rm!(tmp_path)
    end
  end

  describe "fill_documents/2" do
    test "fills multiple documents with stored content and returns ZIP" do
      docx1 = DocxTestHelper.create_formularz_ofertowy()
      docx2 = DocxTestHelper.create_oswiadczenie()

      documents = [
        %{content: docx1, file_name: "Formularz_ofertowy.docx", name: "Formularz"},
        %{content: docx2, file_name: "Oswiadczenie.docx", name: "Oswiadczenie"}
      ]

      {:ok, zip_binary, success_count, total_count} =
        DocumentFiller.fill_documents(documents, @sample_profile)

      assert success_count == 2
      assert total_count == 2

      # Verify it's a valid ZIP
      assert String.starts_with?(zip_binary, "PK")

      # Extract and verify contents
      {:ok, zip_handle} = :zip.zip_open(zip_binary, [:memory])

      {:ok, {~c"Formularz_ofertowy.docx", filled1}} =
        :zip.zip_get(~c"Formularz_ofertowy.docx", zip_handle)

      {:ok, {~c"Oswiadczenie.docx", filled2}} = :zip.zip_get(~c"Oswiadczenie.docx", zip_handle)

      :zip.zip_close(zip_handle)

      text1 = DocxTestHelper.extract_text(IO.iodata_to_binary(filled1))
      text2 = DocxTestHelper.extract_text(IO.iodata_to_binary(filled2))

      assert String.contains?(text1, "Test Sp. z o.o.")
      assert String.contains?(text2, "Test Sp. z o.o.")
    end

    test "handles partial failures when some documents lack content" do
      docx1 = DocxTestHelper.create_formularz_ofertowy()

      documents = [
        %{content: docx1, file_name: "Formularz_ofertowy.docx", name: "Formularz"},
        %{content: nil, file_name: "Missing.docx", name: "Missing"}
      ]

      {:ok, zip_binary, success_count, total_count} =
        DocumentFiller.fill_documents(documents, @sample_profile)

      # Should still succeed with partial results
      assert success_count == 1
      assert total_count == 2
      assert String.starts_with?(zip_binary, "PK")
    end

    test "returns error when all documents lack content" do
      documents = [
        %{content: nil, file_name: "Failed.docx", name: "Failed"}
      ]

      result = DocumentFiller.fill_documents(documents, @sample_profile)

      assert {:error, :no_documents_filled} = result
    end
  end

  describe "preview_field_mapping/1" do
    test "returns mapping of all fields" do
      mapping = DocumentFiller.preview_field_mapping(@sample_profile)

      assert mapping.company_name == "Test Sp. z o.o."
      assert mapping.nip == "1234567890"
      assert mapping.regon == "123456789"
      assert mapping.krs == "0000123456"
      assert mapping.address == "ul. Testowa 15/3, 00-001 Warszawa"
      assert mapping.phone == "+48 123 456 789"
      assert mapping.email == "test@example.com"
      assert mapping.epuap == "/test/SkrytkaESP"
      assert mapping.representative == "Jan Kowalski, Prezes Zarządu"
      assert mapping.bank_account == "Bank Test S.A.: PL 12 3456 7890 1234 5678 9012 3456"
    end

    test "handles profile with minimal data" do
      profile = %CompanyProfile{
        id: 3,
        company_name: "Minimal",
        nip: "1111111111",
        regon: "111111111",
        street: nil,
        postal_code: nil,
        city: nil,
        voivodeship: nil,
        email: nil,
        phone: nil,
        msp_status: :not_msp,
        legal_form: :jdg,
        is_primary: false,
        representatives: nil
      }

      mapping = DocumentFiller.preview_field_mapping(profile)

      assert mapping.company_name == "Minimal"
      assert mapping.nip == "1111111111"
      assert mapping.address == ""
      assert mapping.representative == ""
    end
  end

  describe "address formatting" do
    test "formats full address correctly" do
      docx = DocxTestHelper.create_docx(["Adres: [adres]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "ul. Testowa 15/3, 00-001 Warszawa")

      File.rm!(tmp_path)
    end

    test "handles missing address components" do
      profile = %CompanyProfile{
        @sample_profile
        | street: nil,
          postal_code: "00-001",
          city: "Warszawa"
      }

      docx = DocxTestHelper.create_docx(["Adres: [adres]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, profile)

      text = DocxTestHelper.extract_text(filled_binary)

      # Should still include city and postal code
      assert String.contains?(text, "00-001 Warszawa")

      File.rm!(tmp_path)
    end
  end

  describe "representative formatting" do
    test "uses primary representative" do
      docx = DocxTestHelper.create_docx(["Osoba: [osoba reprezentująca]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      # Should use Jan Kowalski (is_primary: true)
      assert String.contains?(text, "Jan Kowalski, Prezes Zarządu")
      refute String.contains?(text, "Anna Nowak")

      File.rm!(tmp_path)
    end

    test "uses first representative when none is primary" do
      profile = %CompanyProfile{
        @sample_profile
        | representatives: [
            %{full_name: "Adam Pierwszy", position: "Dyrektor", is_primary: false},
            %{full_name: "Barbara Druga", position: "Manager", is_primary: false}
          ]
      }

      docx = DocxTestHelper.create_docx(["Osoba: [osoba reprezentująca]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "Adam Pierwszy, Dyrektor")

      File.rm!(tmp_path)
    end

    test "handles empty representatives list" do
      profile = %CompanyProfile{@sample_profile | representatives: []}

      docx = DocxTestHelper.create_docx(["Osoba: [osoba reprezentująca]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, profile)

      text = DocxTestHelper.extract_text(filled_binary)

      # When there's no representative data, placeholder remains unchanged
      # (empty values are filtered out to avoid replacing with empty strings)
      assert String.contains?(text, "[osoba reprezentująca]")

      File.rm!(tmp_path)
    end
  end

  describe "bank account formatting" do
    test "includes bank name with account number" do
      docx = DocxTestHelper.create_docx(["Konto: [rachunek bankowy]"])
      tmp_path = write_temp_file(docx)

      {:ok, filled_binary} = DocumentFiller.fill_document_from_file(tmp_path, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)

      assert String.contains?(text, "PL 12 3456 7890 1234 5678 9012 3456")

      File.rm!(tmp_path)
    end
  end

  describe "real government documents" do
    @fixtures_path "test/support/fixtures/documents"

    @tag :real_documents
    test "fills real GUS formularz ofertowy" do
      path = Path.join(@fixtures_path, "formularz_ofertowy_gus.docx")

      if File.exists?(path) do
        {:ok, filled_binary} = DocumentFiller.fill_document_from_file(path, @sample_profile)

        # Verify it's still a valid DOCX
        assert String.starts_with?(filled_binary, "PK")

        # Extract and verify content was processed
        text = DocxTestHelper.extract_text(filled_binary)
        assert is_binary(text)
        assert String.length(text) > 0
      else
        IO.puts("Skipping test - real document not found: #{path}")
      end
    end

    @tag :real_documents
    test "fills real GUS formularz ofertowy 2025" do
      path = Path.join(@fixtures_path, "formularz_ofertowy_gus_2025.docx")

      if File.exists?(path) do
        {:ok, filled_binary} = DocumentFiller.fill_document_from_file(path, @sample_profile)

        assert String.starts_with?(filled_binary, "PK")

        text = DocxTestHelper.extract_text(filled_binary)
        assert is_binary(text)
        assert String.length(text) > 0
      else
        IO.puts("Skipping test - real document not found: #{path}")
      end
    end

    @tag :real_documents
    test "fills real GUS oświadczenie art 125" do
      path = Path.join(@fixtures_path, "oswiadczenie_art125_gus.docx")

      if File.exists?(path) do
        {:ok, filled_binary} = DocumentFiller.fill_document_from_file(path, @sample_profile)

        assert String.starts_with?(filled_binary, "PK")

        text = DocxTestHelper.extract_text(filled_binary)
        assert is_binary(text)
        assert String.length(text) > 0
      else
        IO.puts("Skipping test - real document not found: #{path}")
      end
    end

    @tag :real_documents
    test "fills real ABM oświadczenie art 125" do
      path = Path.join(@fixtures_path, "oswiadczenie_art125_abm.docx")

      if File.exists?(path) do
        {:ok, filled_binary} = DocumentFiller.fill_document_from_file(path, @sample_profile)

        assert String.starts_with?(filled_binary, "PK")

        text = DocxTestHelper.extract_text(filled_binary)
        assert is_binary(text)
        assert String.length(text) > 0
      else
        IO.puts("Skipping test - real document not found: #{path}")
      end
    end

    @tag :real_documents
    test "processes multiple real documents successfully" do
      paths = [
        Path.join(@fixtures_path, "formularz_ofertowy_gus.docx"),
        Path.join(@fixtures_path, "oswiadczenie_art125_gus.docx")
      ]

      existing_paths = Enum.filter(paths, &File.exists?/1)

      if length(existing_paths) >= 2 do
        results =
          existing_paths
          |> Enum.map(fn path ->
            DocumentFiller.fill_document_from_file(path, @sample_profile)
          end)

        # All should succeed
        assert Enum.all?(results, &match?({:ok, _}, &1))

        # Each result should be valid DOCX
        for {:ok, binary} <- results do
          assert String.starts_with?(binary, "PK")
        end
      else
        IO.puts("Skipping test - not enough real documents found")
      end
    end
  end

  describe "fill_documents/2 with TenderDocument structs" do
    test "uses stored content when available" do
      docx = DocxTestHelper.create_docx(["Nazwa: [nazwa wykonawcy]"])

      doc = %{
        content: docx,
        file_name: "formularz.docx",
        name: "Formularz",
        url: "https://example.com/doc.docx"
      }

      {:ok, zip_binary, success_count, total_count} =
        DocumentFiller.fill_documents([doc], @sample_profile)

      assert success_count == 1
      assert total_count == 1
      assert String.starts_with?(zip_binary, "PK")
    end

    test "handles multiple documents with stored content" do
      docx1 = DocxTestHelper.create_docx(["Firma: [nazwa firmy]"])
      docx2 = DocxTestHelper.create_docx(["NIP: [nip]"])

      docs = [
        %{content: docx1, file_name: "doc1.docx", name: "Doc 1", url: "https://example.com/1"},
        %{content: docx2, file_name: "doc2.docx", name: "Doc 2", url: "https://example.com/2"}
      ]

      {:ok, zip_binary, success_count, total_count} =
        DocumentFiller.fill_documents(docs, @sample_profile)

      assert success_count == 2
      assert total_count == 2
      assert String.starts_with?(zip_binary, "PK")
    end

    test "falls back to URL download when content is nil" do
      # Document without content will try to download from URL
      # Since URL is fake, it will fail
      doc = %{
        content: nil,
        file_name: "empty.docx",
        name: "Empty",
        url: "https://example.com/fake.docx"
      }

      # Should return error because the only document fails to download
      {:error, :no_documents_filled} = DocumentFiller.fill_documents([doc], @sample_profile)
    end

    test "mixes stored content and URL documents" do
      docx = DocxTestHelper.create_docx(["Test: [nip]"])

      docs = [
        %{
          content: docx,
          file_name: "with_content.docx",
          name: "With Content",
          url: "https://x.com/1"
        },
        # This will fail because URL is fake
        %{content: nil, file_name: "no_content.docx", name: "No Content", url: "https://x.com/2"}
      ]

      # Should succeed with partial results (1 out of 2)
      {:ok, _zip_binary, success_count, total_count} =
        DocumentFiller.fill_documents(docs, @sample_profile)

      assert success_count == 1
      assert total_count == 2
    end

    test "uses file_name from document struct" do
      docx = DocxTestHelper.create_docx(["Test"])

      doc = %{
        content: docx,
        file_name: "custom_name.docx",
        name: "Different Name",
        url: "https://example.com/doc.docx"
      }

      {:ok, zip_binary, _, _} = DocumentFiller.fill_documents([doc], @sample_profile)

      # Verify the zip contains file with correct name
      {:ok, zip_handle} = :zip.zip_open(zip_binary, [:memory])
      {:ok, entries} = :zip.zip_list_dir(zip_handle)
      :zip.zip_close(zip_handle)

      file_names =
        entries
        |> Enum.filter(fn
          {:zip_file, _, _, _, _, _} -> true
          _ -> false
        end)
        |> Enum.map(fn {:zip_file, name, _, _, _, _} -> to_string(name) end)

      assert "custom_name.docx" in file_names
    end

    test "falls back to name.docx when file_name is nil" do
      docx = DocxTestHelper.create_docx(["Test"])

      doc = %{
        content: docx,
        file_name: nil,
        name: "My Document",
        url: "https://example.com/doc.docx"
      }

      {:ok, zip_binary, _, _} = DocumentFiller.fill_documents([doc], @sample_profile)

      {:ok, zip_handle} = :zip.zip_open(zip_binary, [:memory])
      {:ok, entries} = :zip.zip_list_dir(zip_handle)
      :zip.zip_close(zip_handle)

      file_names =
        entries
        |> Enum.filter(fn
          {:zip_file, _, _, _, _, _} -> true
          _ -> false
        end)
        |> Enum.map(fn {:zip_file, name, _, _, _, _} -> to_string(name) end)

      assert "My Document.docx" in file_names
    end
  end

  describe "fill_document_from_binary/2" do
    test "fills placeholders in binary content" do
      docx = DocxTestHelper.create_docx(["Nazwa: [nazwa wykonawcy]", "NIP: [nip]"])

      {:ok, filled_binary} = DocumentFiller.fill_document_from_binary(docx, @sample_profile)

      text = DocxTestHelper.extract_text(filled_binary)
      assert String.contains?(text, "Test Sp. z o.o.")
      assert String.contains?(text, "1234567890")
    end

    test "returns valid DOCX binary" do
      docx = DocxTestHelper.create_docx(["Test"])

      {:ok, filled_binary} = DocumentFiller.fill_document_from_binary(docx, @sample_profile)

      assert String.starts_with?(filled_binary, "PK")
    end
  end

  # Helper functions

  defp write_temp_file(binary) do
    path = System.tmp_dir!() |> Path.join("test_#{:rand.uniform(100_000)}.docx")
    File.write!(path, binary)
    path
  end
end
