defmodule PrzetargowiWeb.DocumentFillHTML do
  use PrzetargowiWeb, :html

  import PrzetargowiWeb.ProfileHTML, only: [format_legal_form: 1]

  embed_templates "document_fill_html/*"

  def document_type_badge(file_name) do
    cond do
      String.ends_with?(file_name, ".docx") -> "DOCX"
      String.ends_with?(file_name, ".doc") -> "DOC"
      String.ends_with?(file_name, ".pdf") -> "PDF"
      String.ends_with?(file_name, ".xlsx") -> "XLSX"
      String.ends_with?(file_name, ".xls") -> "XLS"
      true -> "PLIK"
    end
  end

  def fillable_badge_class(file_name) do
    if String.ends_with?(file_name, ".docx") or String.ends_with?(file_name, ".doc") do
      "badge-success"
    else
      "badge-warning"
    end
  end
end
