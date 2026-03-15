defmodule Przetargowi.DocumentParserTest do
  use ExUnit.Case, async: true

  alias Przetargowi.DocumentParser

  describe "categorize_field/1" do
    test "categorizes company name fields" do
      assert DocumentParser.categorize_field("Nazwa firmy") == :company_name
      assert DocumentParser.categorize_field("Pełna nazwa wykonawcy") == :company_name
      assert DocumentParser.categorize_field("Nazwa podmiotu") == :company_name
    end

    test "categorizes NIP fields" do
      assert DocumentParser.categorize_field("NIP") == :nip
      assert DocumentParser.categorize_field("NIP wykonawcy") == :nip
      assert DocumentParser.categorize_field("Numer NIP") == :nip
    end

    test "categorizes REGON fields" do
      assert DocumentParser.categorize_field("REGON") == :regon
      assert DocumentParser.categorize_field("Numer REGON") == :regon
    end

    test "categorizes KRS fields" do
      assert DocumentParser.categorize_field("KRS") == :krs
      assert DocumentParser.categorize_field("Numer KRS") == :krs
    end

    test "categorizes address fields" do
      assert DocumentParser.categorize_field("Adres") == :address
      assert DocumentParser.categorize_field("Adres siedziby") == :address
      assert DocumentParser.categorize_field("Siedziba firmy") == :address
      assert DocumentParser.categorize_field("Miejscowość") == :address
    end

    test "categorizes phone fields" do
      assert DocumentParser.categorize_field("Telefon") == :phone
      assert DocumentParser.categorize_field("Tel.") == :phone
      assert DocumentParser.categorize_field("Tel: ") == :phone
      assert DocumentParser.categorize_field("Numer telefonu") == :phone
    end

    test "categorizes email fields" do
      assert DocumentParser.categorize_field("E-mail") == :email
      assert DocumentParser.categorize_field("Email") == :email
      assert DocumentParser.categorize_field("Adres e-mail") == :email
    end

    test "categorizes ePUAP fields" do
      assert DocumentParser.categorize_field("Adres ePUAP") == :epuap
      assert DocumentParser.categorize_field("Skrzynka ePUAP") == :epuap
    end

    test "categorizes price fields" do
      assert DocumentParser.categorize_field("Cena brutto") == :price
      assert DocumentParser.categorize_field("Cena netto") == :price
      assert DocumentParser.categorize_field("Cena oferty") == :price
      assert DocumentParser.categorize_field("Cena ofertowa brutto") == :price
    end

    test "categorizes warranty fields" do
      assert DocumentParser.categorize_field("Okres gwarancji") == :warranty
      assert DocumentParser.categorize_field("Gwarancja") == :warranty
    end

    test "categorizes representative fields" do
      assert DocumentParser.categorize_field("Osoba reprezentująca") == :representative
      assert DocumentParser.categorize_field("Osoba upoważniona") == :representative
    end

    test "categorizes proceeding reference fields" do
      assert DocumentParser.categorize_field("Numer postępowania") == :proceeding_ref
      assert DocumentParser.categorize_field("Numer referencyjny") == :proceeding_ref
    end

    test "categorizes proceeding name fields" do
      assert DocumentParser.categorize_field("Nazwa zamówienia") == :proceeding_name
    end

    test "categorizes bank account fields" do
      assert DocumentParser.categorize_field("Numer rachunku bankowego") == :bank_account
      assert DocumentParser.categorize_field("Konto bankowe") == :bank_account
    end

    test "categorizes date fields" do
      assert DocumentParser.categorize_field("Data") == :date
      assert DocumentParser.categorize_field("Dnia") == :date
    end

    test "categorizes signature fields" do
      assert DocumentParser.categorize_field("Podpis") == :signature
      assert DocumentParser.categorize_field("Podpis wykonawcy") == :signature
    end

    test "returns :unknown for unrecognized fields" do
      assert DocumentParser.categorize_field("Jakieś pole") == :unknown
      assert DocumentParser.categorize_field("Inne informacje") == :unknown
    end
  end

  describe "identify_fillable_fields/1" do
    test "identifies dot fields" do
      paragraphs = [
        %{index: 0, text: "Nazwa firmy: …………………………………", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 1
      [field] = fields
      assert field.paragraph_index == 0
      assert field.field_type == :dots
      assert field.suggested_category == :company_name
      assert String.contains?(field.placeholder, "…")
    end

    test "identifies underscore fields" do
      paragraphs = [
        %{index: 0, text: "NIP: ________________", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 1
      [field] = fields
      assert field.field_type == :underscores
      assert field.suggested_category == :nip
    end

    test "identifies bracket placeholder fields" do
      paragraphs = [
        %{index: 0, text: "Adres: [wpisz adres siedziby]", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 1
      [field] = fields
      assert field.field_type == :brackets
      assert field.suggested_category == :address
      assert field.placeholder == "[wpisz adres siedziby]"
    end

    test "identifies checkbox fields" do
      paragraphs = [
        %{index: 0, text: "☐ TAK, jestem mikroprzedsiębiorcą", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 1
      [field] = fields
      assert field.field_type == :checkbox
      assert field.placeholder == "☐"
    end

    test "identifies multiple fields in one paragraph" do
      paragraphs = [
        %{
          index: 0,
          text: "Nazwa firmy: ……………………… NIP: ________________",
          style: nil
        }
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 2
      types = Enum.map(fields, & &1.field_type)
      assert :dots in types
      assert :underscores in types
    end

    test "identifies fields across multiple paragraphs" do
      paragraphs = [
        %{index: 0, text: "Nazwa firmy: ……………………", style: nil},
        %{index: 1, text: "Adres: ________________", style: nil},
        %{index: 2, text: "Treść bez pól", style: nil},
        %{index: 3, text: "E-mail: [adres email]", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 3
      assert Enum.any?(fields, &(&1.paragraph_index == 0 && &1.suggested_category == :company_name))
      assert Enum.any?(fields, &(&1.paragraph_index == 1 && &1.suggested_category == :address))
      assert Enum.any?(fields, &(&1.paragraph_index == 3 && &1.suggested_category == :email))
    end

    test "handles empty paragraphs" do
      paragraphs = [
        %{index: 0, text: "", style: nil},
        %{index: 1, text: "   ", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert fields == []
    end

    test "handles Polish characters in labels" do
      paragraphs = [
        %{index: 0, text: "Miejscowość: ……………………", style: nil},
        %{index: 1, text: "Numer postępowania: ________", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      assert length(fields) == 2
      assert Enum.any?(fields, &(&1.suggested_category == :address))
      assert Enum.any?(fields, &(&1.suggested_category == :proceeding_ref))
    end

    test "extracts field labels correctly" do
      paragraphs = [
        %{index: 0, text: "1. Pełna nazwa wykonawcy: ……………………", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      [field] = fields
      # Should have cleaned up the "1. " prefix
      assert String.contains?(field.field_label, "nazwa wykonawcy")
    end
  end

  describe "group_fields_by_category/1" do
    test "groups fields by category" do
      fields = [
        %{paragraph_index: 0, suggested_category: :company_name, field_label: "Nazwa"},
        %{paragraph_index: 1, suggested_category: :nip, field_label: "NIP"},
        %{paragraph_index: 2, suggested_category: :company_name, field_label: "Nazwa 2"},
        %{paragraph_index: 3, suggested_category: :address, field_label: "Adres"}
      ]

      grouped = DocumentParser.group_fields_by_category(fields)

      assert length(grouped[:company_name]) == 2
      assert length(grouped[:nip]) == 1
      assert length(grouped[:address]) == 1
    end
  end

  describe "filter_fields_by_category/2" do
    test "filters fields by category" do
      fields = [
        %{paragraph_index: 0, suggested_category: :company_name, field_label: "Nazwa"},
        %{paragraph_index: 1, suggested_category: :nip, field_label: "NIP"},
        %{paragraph_index: 2, suggested_category: :company_name, field_label: "Nazwa 2"}
      ]

      company_fields = DocumentParser.filter_fields_by_category(fields, :company_name)

      assert length(company_fields) == 2
      assert Enum.all?(company_fields, &(&1.suggested_category == :company_name))
    end
  end

  describe "convert_doc_to_docx/1" do
    test "returns error when soffice is not installed" do
      # Mock by using a non-existent file - the function should check for soffice first
      # This test will only pass if soffice is not installed
      # In CI, we'd mock System.find_executable

      result = DocumentParser.convert_doc_to_docx("/nonexistent/file.doc")

      # Either soffice is not installed, or file doesn't exist
      assert match?({:error, _}, result)
    end
  end

  describe "integration scenarios" do
    test "typical formularz ofertowy fields" do
      paragraphs = [
        %{index: 0, text: "FORMULARZ OFERTOWY", style: "Heading1"},
        %{index: 1, text: "1. Nazwa wykonawcy: ………………………………………………", style: nil},
        %{index: 2, text: "2. Adres siedziby: ………………………………………………", style: nil},
        %{index: 3, text: "3. NIP: ________________ REGON: ________________", style: nil},
        %{index: 4, text: "4. Telefon: __________ E-mail: __________________", style: nil},
        %{index: 5, text: "5. Cena oferty brutto: ……………………… PLN", style: nil},
        %{index: 6, text: "6. Okres gwarancji: ……… miesięcy", style: nil},
        %{index: 7, text: "☐ Jestem mikroprzedsiębiorcą", style: nil},
        %{index: 8, text: "☐ Jestem małym przedsiębiorcą", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      categories = Enum.map(fields, & &1.suggested_category)

      assert :company_name in categories
      assert :address in categories
      assert :nip in categories
      assert :regon in categories
      assert :phone in categories
      assert :email in categories
      assert :price in categories
      assert :warranty in categories
    end

    test "oświadczenie art. 125 fields" do
      paragraphs = [
        %{index: 0, text: "OŚWIADCZENIE", style: "Heading1"},
        %{index: 1, text: "Nazwa wykonawcy: [wpisz nazwę]", style: nil},
        %{index: 2, text: "Adres: [wpisz adres]", style: nil},
        %{index: 3, text: "KRS/CEIDG: ________________", style: nil},
        %{index: 4, text: "Osoba reprezentująca: ………………………", style: nil},
        %{index: 5, text: "Data: __________ Podpis: __________", style: nil}
      ]

      fields = DocumentParser.identify_fillable_fields(paragraphs)

      categories = Enum.map(fields, & &1.suggested_category)

      assert :company_name in categories
      assert :address in categories
      assert :krs in categories
      assert :representative in categories
      assert :date in categories
      assert :signature in categories
    end
  end
end
