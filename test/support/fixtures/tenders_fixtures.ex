defmodule Przetargowi.TendersFixtures do
  @moduledoc """
  Test helpers for creating entities via the `Przetargowi.Tenders` context.
  """

  alias Przetargowi.Repo
  alias Przetargowi.Tenders.TenderDocument

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

    %TenderDocument{}
    |> TenderDocument.changeset(attrs)
    |> Repo.insert!()
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
end
