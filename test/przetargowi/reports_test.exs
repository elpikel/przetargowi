defmodule Przetargowi.ReportsTest do
  use Przetargowi.DataCase

  alias Przetargowi.Reports
  alias Przetargowi.Reports.TenderReport

  defp report_attrs(attrs \\ %{}) do
    Map.merge(
      %{
        title: "Test Report #{System.unique_integer()}",
        slug: "test-report-#{System.unique_integer()}",
        report_month: ~D[2026-01-01],
        report_type: "detailed",
        region: "mazowieckie",
        order_type: "Delivery",
        report_data: %{total_tenders: 100},
        introduction_html: "<p>Introduction</p>",
        analysis_html: "<p>Analysis</p>"
      },
      attrs
    )
  end

  defp create_report(attrs \\ %{}) do
    {:ok, report} = Reports.upsert_report(report_attrs(attrs))
    report
  end

  describe "upsert_report/1" do
    test "creates a report with valid attributes" do
      attrs = report_attrs()
      assert {:ok, report} = Reports.upsert_report(attrs)
      assert report.title == attrs.title
      assert report.region == "mazowieckie"
      assert report.year == 2026
    end

    test "fills year from report_month automatically" do
      attrs = report_attrs(%{report_month: ~D[2025-06-15]})
      {:ok, report} = Reports.upsert_report(attrs)
      assert report.year == 2025
    end

    test "updates existing report" do
      report = create_report()

      {:ok, updated} =
        Reports.upsert_report(%{
          title: "Updated Title",
          slug: report.slug,
          report_month: report.report_month,
          report_type: report.report_type,
          region: report.region,
          order_type: report.order_type,
          report_data: %{total_tenders: 200},
          introduction_html: "<p>New intro</p>",
          analysis_html: "<p>New analysis</p>"
        })

      assert updated.id == report.id
      assert updated.title == "Updated Title"
    end
  end

  describe "list_tender_reports/1" do
    test "returns all reports without filters" do
      report1 = create_report(%{region: "mazowieckie"})
      report2 = create_report(%{region: "slaskie"})

      result = Reports.list_tender_reports()

      assert result.total_count == 2
      assert length(result.reports) == 2
      report_ids = Enum.map(result.reports, & &1.id)
      assert report1.id in report_ids
      assert report2.id in report_ids
    end

    test "filters by region" do
      create_report(%{region: "mazowieckie"})
      report2 = create_report(%{region: "slaskie"})

      result = Reports.list_tender_reports(region: "slaskie")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by report_type" do
      create_report(%{report_type: "detailed", region: "mazowieckie", order_type: "Delivery"})

      report2 =
        create_report(%{
          report_type: "region_summary",
          region: "mazowieckie",
          order_type: nil,
          slug: "summary-#{System.unique_integer()}"
        })

      result = Reports.list_tender_reports(report_type: "region_summary")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by year" do
      create_report(%{report_month: ~D[2025-01-01]})
      report2 = create_report(%{report_month: ~D[2026-06-01]})

      result = Reports.list_tender_reports(year: 2026)

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by year as string" do
      create_report(%{report_month: ~D[2025-01-01]})
      report2 = create_report(%{report_month: ~D[2026-06-01]})

      result = Reports.list_tender_reports(year: "2026")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by month" do
      create_report(%{report_month: ~D[2026-01-15]})
      report2 = create_report(%{report_month: ~D[2026-06-15]})

      result = Reports.list_tender_reports(month: 6)

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by month as string" do
      create_report(%{report_month: ~D[2026-01-15]})
      report2 = create_report(%{report_month: ~D[2026-06-15]})

      result = Reports.list_tender_reports(month: "6")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by order_type" do
      create_report(%{order_type: "Delivery"})
      report2 = create_report(%{order_type: "Services"})

      result = Reports.list_tender_reports(order_type: "Services")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "filters by text query" do
      create_report(%{title: "January Report"})
      report2 = create_report(%{title: "Special Analysis"})

      result = Reports.list_tender_reports(query: "Special")

      assert result.total_count == 1
      assert hd(result.reports).id == report2.id
    end

    test "combines multiple filters" do
      create_report(%{region: "mazowieckie", report_month: ~D[2026-01-01]})
      create_report(%{region: "slaskie", report_month: ~D[2026-01-01]})
      report3 = create_report(%{region: "mazowieckie", report_month: ~D[2026-06-01]})

      result = Reports.list_tender_reports(region: "mazowieckie", month: 6)

      assert result.total_count == 1
      assert hd(result.reports).id == report3.id
    end

    test "paginates results" do
      for i <- 1..15 do
        create_report(%{
          slug: "report-page-#{i}-#{System.unique_integer()}",
          region: "mazowieckie",
          report_month: Date.add(~D[2026-01-01], i)
        })
      end

      result = Reports.list_tender_reports(page: 1, per_page: 10)
      assert length(result.reports) == 10
      assert result.total_count == 15
      assert result.total_pages == 2

      result2 = Reports.list_tender_reports(page: 2, per_page: 10)
      assert length(result2.reports) == 5
    end
  end

  describe "get_filter_options/0" do
    test "returns available filter options" do
      create_report(%{
        region: "mazowieckie",
        report_type: "detailed",
        order_type: "Delivery",
        report_month: ~D[2026-01-01]
      })

      create_report(%{
        region: "slaskie",
        report_type: "region_summary",
        order_type: nil,
        report_month: ~D[2026-06-01]
      })

      options = Reports.get_filter_options()

      assert "mazowieckie" in options.regions
      assert "slaskie" in options.regions
      assert "detailed" in options.report_types
      assert "region_summary" in options.report_types
      assert 2026 in options.years
      assert 1 in options.months
      assert 6 in options.months
      assert "Delivery" in options.order_types
    end

    test "returns empty lists when no reports exist" do
      options = Reports.get_filter_options()

      assert options.regions == []
      assert options.report_types == []
      assert options.years == []
      assert options.months == []
      assert options.order_types == []
    end
  end

  describe "get_report_by_slug/1" do
    test "returns report by slug" do
      report = create_report()
      found = Reports.get_report_by_slug(report.slug)
      assert found.id == report.id
    end

    test "returns nil for non-existent slug" do
      assert is_nil(Reports.get_report_by_slug("non-existent"))
    end
  end

  describe "TenderReport.changeset/2" do
    test "validates required fields" do
      changeset = TenderReport.changeset(%TenderReport{}, %{})

      assert %{
               title: ["can't be blank"],
               slug: ["can't be blank"],
               report_month: ["can't be blank"],
               report_type: ["can't be blank"],
               report_data: ["can't be blank"],
               introduction_html: ["can't be blank"],
               analysis_html: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates report_type inclusion" do
      changeset =
        TenderReport.changeset(%TenderReport{}, %{
          title: "Test",
          slug: "test",
          report_month: ~D[2026-01-01],
          report_type: "invalid",
          report_data: %{},
          introduction_html: "test",
          analysis_html: "test"
        })

      assert %{report_type: ["is invalid"]} = errors_on(changeset)
    end

    test "validates detailed reports require region and order_type" do
      changeset =
        TenderReport.changeset(%TenderReport{}, %{
          title: "Test",
          slug: "test",
          report_month: ~D[2026-01-01],
          report_type: "detailed",
          report_data: %{},
          introduction_html: "test",
          analysis_html: "test"
        })

      assert %{region: ["can't be blank"], order_type: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates region_summary requires region" do
      changeset =
        TenderReport.changeset(%TenderReport{}, %{
          title: "Test",
          slug: "test",
          report_month: ~D[2026-01-01],
          report_type: "region_summary",
          report_data: %{},
          introduction_html: "test",
          analysis_html: "test"
        })

      assert %{region: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
