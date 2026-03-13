defmodule Przetargowi.TenderDocumentsTest do
  use ExUnit.Case, async: true

  alias Przetargowi.TenderDocuments
  alias Przetargowi.TenderDocuments.DownloadableDocument

  describe "classify_document/2" do
    test "classifies formularz ofertowy" do
      assert TenderDocuments.classify_document("Formularz ofertowy", "formularz.docx") ==
               :offer_form

      assert TenderDocuments.classify_document("Załącznik - formularz oferty", "zal.doc") ==
               :offer_form
    end

    test "classifies oświadczenie art. 125" do
      assert TenderDocuments.classify_document("Oświadczenie art. 125 ust. 1", "oswiadczenie.docx") ==
               :declaration_art125

      assert TenderDocuments.classify_document("Oświadczenie z art.125", "zal.docx") ==
               :declaration_art125
    end

    test "classifies oświadczenie o grupie kapitałowej" do
      assert TenderDocuments.classify_document(
               "Oświadczenie o przynależności do grupy kapitałowej",
               "grupa.docx"
             ) == :declaration_capital_group
    end

    test "classifies oświadczenie o aktualności" do
      assert TenderDocuments.classify_document(
               "Oświadczenie o aktualności informacji",
               "aktualnosc.docx"
             ) == :declaration_actuality
    end

    test "classifies oświadczenie dotyczące Ukrainy" do
      assert TenderDocuments.classify_document(
               "Oświadczenie dot. wykluczenia - Ukraina",
               "ukraina.docx"
             ) == :declaration_ukraine

      assert TenderDocuments.classify_document("Oświadczenie art. 7 ust. 1", "art7.docx") ==
               :declaration_ukraine
    end

    test "classifies SWZ" do
      assert TenderDocuments.classify_document("Specyfikacja", "SWZ.pdf") == :swz
      # But not załącznik do SWZ
      assert TenderDocuments.classify_document("Załącznik nr 1 do SWZ", "zal_swz.pdf") != :swz
    end

    test "classifies opis przedmiotu zamówienia" do
      assert TenderDocuments.classify_document("Opis przedmiotu zamówienia", "opz.pdf") ==
               :description_of_object
    end

    test "classifies umowa" do
      assert TenderDocuments.classify_document("Wzór umowy", "umowa.pdf") == :contract_template
      assert TenderDocuments.classify_document("Projekt umowy", "projekt.pdf") == :contract_template
    end

    test "classifies zmiana/modyfikacja" do
      assert TenderDocuments.classify_document("Zmiana SWZ", "zmiana.pdf") == :amendment
      assert TenderDocuments.classify_document("Modyfikacja treści", "mod.pdf") == :amendment
    end

    test "returns :other for unrecognized documents" do
      assert TenderDocuments.classify_document("Jakiś dokument", "plik.pdf") == :other
    end
  end

  describe "fillable?/2" do
    test "returns true for forms and declarations" do
      assert TenderDocuments.fillable?("Formularz ofertowy", "form.docx")
      assert TenderDocuments.fillable?("Oświadczenie", "osw.docx")
      assert TenderDocuments.fillable?("Załącznik nr 3", "zal3.docx")
      assert TenderDocuments.fillable?("Wykaz robót", "wykaz.docx")
    end

    test "returns false for non-fillable documents" do
      refute TenderDocuments.fillable?("SWZ", "swz.pdf")
      refute TenderDocuments.fillable?("Umowa", "umowa.pdf")
    end
  end

  describe "parse_tender_page/1" do
    test "extracts documents from HTML with ezamowienia links" do
      html = """
      <html>
      <body>
        <a href="https://ezamowienia.gov.pl/mp-client/search/tenderdocument/ocds-148610-abc/ocds-148610-abc_1">
          <div><p>Formularz ofertowy</p><p>formularz.docx</p></div>
        </a>
        <a href="https://ezamowienia.gov.pl/mp-client/search/tenderdocument/ocds-148610-abc/ocds-148610-abc_2">
          <div><p>SWZ</p><p>swz.pdf</p></div>
        </a>
        <a href="https://example.com/other">Other link</a>
      </body>
      </html>
      """

      docs = TenderDocuments.parse_tender_page(html)

      assert length(docs) == 2
      assert Enum.any?(docs, &(&1.name == "Formularz ofertowy"))
      assert Enum.any?(docs, &(&1.filename == "swz.pdf"))
    end

    test "classifies documents during parsing" do
      html = """
      <html>
      <body>
        <a href="https://ezamowienia.gov.pl/mp-client/search/tenderdocument/ocds/ocds_1">
          <div><p>Formularz ofertowy</p><p>form.docx</p></div>
        </a>
      </body>
      </html>
      """

      [doc] = TenderDocuments.parse_tender_page(html)

      assert doc.document_type == :offer_form
      assert doc.fillable == true
    end

    test "returns empty list when no ezamowienia links" do
      html = "<html><body><a href='https://example.com'>Link</a></body></html>"

      assert TenderDocuments.parse_tender_page(html) == []
    end
  end

  describe "DownloadableDocument" do
    test "creates document with defaults" do
      doc = %DownloadableDocument{
        name: "Test",
        filename: "test.pdf",
        url: "https://example.com/test.pdf"
      }

      assert doc.document_type == :other
      assert doc.fillable == false
      assert doc.downloaded_path == nil
    end

    test "document_types/0 returns all types" do
      types = DownloadableDocument.document_types()

      assert :swz in types
      assert :offer_form in types
      assert :declaration_art125 in types
      assert :other in types
    end
  end

  describe "filter functions" do
    setup do
      docs = [
        %DownloadableDocument{
          name: "SWZ",
          filename: "swz.pdf",
          url: "url1",
          document_type: :swz,
          fillable: false
        },
        %DownloadableDocument{
          name: "Formularz",
          filename: "form.docx",
          url: "url2",
          document_type: :offer_form,
          fillable: true
        },
        %DownloadableDocument{
          name: "Oświadczenie",
          filename: "osw.docx",
          url: "url3",
          document_type: :declaration_art125,
          fillable: true
        }
      ]

      {:ok, docs: docs}
    end

    test "filter_by_type/2 filters by document type", %{docs: docs} do
      assert length(TenderDocuments.filter_by_type(docs, :swz)) == 1
      assert length(TenderDocuments.filter_by_type(docs, :offer_form)) == 1
      assert length(TenderDocuments.filter_by_type(docs, :other)) == 0
    end

    test "filter_fillable/1 returns only fillable documents", %{docs: docs} do
      fillable = TenderDocuments.filter_fillable(docs)

      assert length(fillable) == 2
      assert Enum.all?(fillable, & &1.fillable)
    end
  end

  describe "set_downloaded_path/2" do
    test "updates document with downloaded path" do
      doc = %DownloadableDocument{
        name: "Test",
        filename: "test.pdf",
        url: "https://example.com/test.pdf"
      }

      updated = TenderDocuments.set_downloaded_path(doc, "/tmp/test.pdf")

      assert updated.downloaded_path == "/tmp/test.pdf"
    end
  end
end
