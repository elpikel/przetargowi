defmodule Przetargowi.Repo.Migrations.AddCpvPrefixIndexToTenderNotices do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  # The market analysis filters by CPV prefix (`cpv_main LIKE '45%'`) and
  # notice type, newest first. The plain cpv_main index only serves a prefix
  # match when the database collation is "C"; `text_pattern_ops` serves it under
  # any collation. notice_type and publication_date are in the index so the
  # notice-type and date conditions are checked before the table is read.
  def change do
    create_if_not_exists index(
                           :tender_notices,
                           ["cpv_main text_pattern_ops", :notice_type, :publication_date],
                           name: :tender_notices_cpv_prefix_notice_type_publication_date_index,
                           concurrently: true
                         )
  end
end
