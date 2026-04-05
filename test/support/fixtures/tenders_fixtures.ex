defmodule Przetargowi.TendersFixtures do
  @moduledoc """
  Test helpers for creating entities via the `Przetargowi.Tenders` context.
  """

  alias Przetargowi.Repo
  alias Przetargowi.Tenders.TenderDocument
  alias Przetargowi.Tenders.TenderNotice

  def unique_object_id do
    "doc-#{System.unique_integer([:positive])}"
  end

  def unique_tender_id do
    "tender-#{System.unique_integer([:positive])}"
  end

  def valid_tender_document_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      object_id: unique_object_id(),
      tender_id: unique_tender_id(),
      name: "Formularz ofertowy",
      file_name: "formularz_ofertowy.docx",
      url: "https://example.com/docs/formularz.docx",
      state: "ACTIVE"
    })
  end

  def tender_document_fixture(attrs \\ %{}) do
    attrs = valid_tender_document_attributes(attrs)

    # Create a linked TenderNotice so documents can be found by get_documents_to_download
    ensure_tender_notice_exists(attrs[:tender_id])

    %TenderDocument{}
    |> TenderDocument.changeset(attrs)
    |> Repo.insert!()
  end

  defp ensure_tender_notice_exists(tender_id) do
    unless Repo.get_by(TenderNotice, tender_id: tender_id) do
      %TenderNotice{}
      |> TenderNotice.changeset(%{
        object_id: "notice-for-#{tender_id}",
        tender_id: tender_id,
        notice_type: "ContractNotice",
        notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
        bzp_number: "BZP-#{System.unique_integer([:positive])}",
        is_tender_amount_below_eu: true,
        publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
        cpv_codes: ["45000000-7"],
        organization_name: "Test Organization",
        organization_city: "Warszawa",
        organization_country: "Polska",
        organization_national_id: "1234567890",
        organization_id: "ORG-#{System.unique_integer([:positive])}",
        html_body: "<html>Test</html>"
      })
      |> Repo.insert!()
    end
  end

  def tender_document_with_content_fixture(attrs \\ %{}) do
    doc = tender_document_fixture(attrs)
    sample_docx = create_sample_docx()

    doc
    |> TenderDocument.download_changeset(%{
      content: sample_docx,
      downloaded_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    |> Repo.update!()
  end

  def tender_document_with_error_fixture(attrs \\ %{}) do
    doc = tender_document_fixture(attrs)

    doc
    |> TenderDocument.download_changeset(%{
      download_error: "spa_redirect"
    })
    |> Repo.update!()
  end

  defp create_sample_docx do
    # Minimal valid DOCX structure
    content_types = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
      <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
      <Default Extension="xml" ContentType="application/xml"/>
      <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
    </Types>
    """

    rels = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
      <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
    </Relationships>
    """

    document = """
    <?xml version="1.0" encoding="UTF-8"?>
    <w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <w:body>
        <w:p><w:r><w:t>Nazwa firmy: [nazwa wykonawcy]</w:t></w:r></w:p>
        <w:p><w:r><w:t>NIP: [nip]</w:t></w:r></w:p>
      </w:body>
    </w:document>
    """

    entries = [
      {~c"[Content_Types].xml", content_types},
      {~c"_rels/.rels", rels},
      {~c"word/document.xml", document}
    ]

    {:ok, {~c"document.docx", binary}} = :zip.create(~c"document.docx", entries, [:memory])
    binary
  end

  # TenderNotice fixtures

  def unique_notice_object_id do
    "notice-#{System.unique_integer([:positive])}"
  end

  def valid_tender_notice_attributes(attrs \\ %{}) do
    object_id = unique_notice_object_id()

    Enum.into(attrs, %{
      object_id: object_id,
      notice_type: "ContractNotice",
      notice_number: "2024/BZP/#{System.unique_integer([:positive])}",
      bzp_number: "BZP-#{System.unique_integer([:positive])}",
      is_tender_amount_below_eu: true,
      publication_date: DateTime.utc_now() |> DateTime.truncate(:second),
      cpv_codes: ["45000000-7"],
      organization_name: "Test Organization",
      organization_city: "Warszawa",
      organization_country: "Polska",
      organization_national_id: "1234567890",
      organization_id: "ORG-#{System.unique_integer([:positive])}",
      html_body: "<html>Test</html>",
      order_object: "Dostawa sprzętu komputerowego",
      slug: "dostawa-sprzetu-komputerowego-#{object_id}"
    })
  end

  def tender_notice_fixture(attrs \\ %{}) do
    attrs = valid_tender_notice_attributes(attrs)

    %TenderNotice{}
    |> TenderNotice.changeset(attrs)
    |> Repo.insert!()
  end
end
