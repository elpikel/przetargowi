defmodule Przetargowi.DocxTestHelper do
  @moduledoc """
  Helper for creating test DOCX files with placeholders.

  A DOCX file is a ZIP archive containing XML files.
  The main content is in word/document.xml.
  """

  @doc """
  Creates a minimal valid DOCX binary with the given content paragraphs.

  Each paragraph can contain placeholders like [nazwa wykonawcy], [NIP], etc.
  """
  def create_docx(paragraphs) when is_list(paragraphs) do
    document_xml = build_document_xml(paragraphs)

    entries = [
      {~c"[Content_Types].xml", content_types_xml()},
      {~c"_rels/.rels", rels_xml()},
      {~c"word/_rels/document.xml.rels", document_rels_xml()},
      {~c"word/document.xml", document_xml},
      {~c"word/styles.xml", styles_xml()}
    ]

    {:ok, {~c"document.docx", binary}} = :zip.create(~c"document.docx", entries, [:memory])
    binary
  end

  @doc """
  Creates a formularz ofertowy (offer form) DOCX with typical Polish tender placeholders.
  """
  def create_formularz_ofertowy do
    create_docx([
      "FORMULARZ OFERTOWY",
      "1. Nazwa wykonawcy: [nazwa wykonawcy]",
      "2. Adres siedziby: [adres siedziby]",
      "3. NIP: [NIP] REGON: [REGON]",
      "4. KRS: [KRS]",
      "5. Telefon: [telefon] E-mail: [e-mail]",
      "6. Adres ePUAP: [adres ePUAP]",
      "7. Osoba reprezentująca: [osoba reprezentująca]",
      "8. Rachunek bankowy: [rachunek bankowy]"
    ])
  end

  @doc """
  Creates an oświadczenie (declaration) DOCX with typical placeholders.
  """
  def create_oswiadczenie do
    create_docx([
      "OŚWIADCZENIE",
      "Działając w imieniu:",
      "Nazwa firmy: [nazwa firmy]",
      "Adres: [Adres]",
      "NIP: [nip] REGON: [regon]",
      "oświadczam, że spełniam warunki udziału w postępowaniu.",
      "Imię i nazwisko: [Imię i nazwisko]",
      "Stanowisko: [stanowisko]"
    ])
  end

  @doc """
  Creates a DOCX with mixed case placeholders to test case sensitivity.
  """
  def create_mixed_case_placeholders do
    create_docx([
      "Nazwa: [nazwa wykonawcy]",
      "NAZWA: [NAZWA WYKONAWCY]",
      "NIP: [nip]",
      "nip: [NIP]",
      "Email: [email]",
      "E-Mail: [E-mail]"
    ])
  end

  @doc """
  Creates a DOCX with no placeholders (plain text only).
  """
  def create_no_placeholders do
    create_docx([
      "Ten dokument nie zawiera żadnych pól do wypełnienia.",
      "Jest to zwykły tekst bez placeholderów."
    ])
  end

  @doc """
  Extracts text content from a DOCX binary for verification.
  """
  def extract_text(docx_binary) do
    {:ok, zip_handle} = :zip.zip_open(docx_binary, [:memory])

    result =
      case :zip.zip_get(~c"word/document.xml", zip_handle) do
        {:ok, {~c"word/document.xml", content}} ->
          content
          |> IO.iodata_to_binary()
          |> extract_text_from_xml()

        _ ->
          ""
      end

    :zip.zip_close(zip_handle)
    result
  end

  defp extract_text_from_xml(xml) do
    # Extract text from <w:t>...</w:t> elements
    Regex.scan(~r/<w:t[^>]*>([^<]*)<\/w:t>/, xml)
    |> Enum.map(fn [_, text] -> text end)
    |> Enum.join("")
  end

  defp build_document_xml(paragraphs) do
    paragraph_xml =
      paragraphs
      |> Enum.map(&build_paragraph_xml/1)
      |> Enum.join("\n")

    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <w:body>
        #{paragraph_xml}
      </w:body>
    </w:document>
    """
  end

  defp build_paragraph_xml(text) do
    """
    <w:p>
      <w:r>
        <w:t>#{escape_xml(text)}</w:t>
      </w:r>
    </w:p>
    """
  end

  defp escape_xml(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&apos;")
  end

  defp content_types_xml do
    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
      <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
      <Default Extension="xml" ContentType="application/xml"/>
      <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
      <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
    </Types>
    """
  end

  defp rels_xml do
    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
      <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
    </Relationships>
    """
  end

  defp document_rels_xml do
    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
      <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
    </Relationships>
    """
  end

  defp styles_xml do
    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <w:docDefaults>
        <w:rPrDefault>
          <w:rPr>
            <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
            <w:sz w:val="22"/>
          </w:rPr>
        </w:rPrDefault>
      </w:docDefaults>
    </w:styles>
    """
  end
end
