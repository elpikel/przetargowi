defmodule Przetargowi.MarketAnalysisTest do
  use Przetargowi.DataCase, async: true

  alias Przetargowi.MarketAnalysis
  alias Przetargowi.Repo
  alias Przetargowi.Tenders.TenderNotice

  defp insert_tender!(attrs) do
    defaults = %{
      object_id: "tn-#{System.unique_integer([:positive])}",
      notice_type: "ContractPerformingNotice",
      notice_number: "2026/BZP/#{System.unique_integer([:positive])}",
      bzp_number: "BZP-#{System.unique_integer([:positive])}",
      is_tender_amount_below_eu: true,
      publication_date: ~U[2026-03-15 10:00:00Z],
      cpv_codes: ["45000000-7"],
      cpv_main: "45000000-7",
      order_type: "Works",
      organization_name: "Test Org",
      organization_city: "Warszawa",
      organization_province: "PL14",
      organization_country: "Polska",
      organization_national_id: "1234567890",
      organization_id: "ORG-#{System.unique_integer([:positive])}",
      html_body: "<html>Test</html>",
      order_object: "Test tender",
      slug: "test-tender-#{System.unique_integer([:positive])}"
    }

    merged = Map.merge(defaults, attrs)

    %TenderNotice{}
    |> TenderNotice.changeset(merged)
    |> Repo.insert!()
  end

  describe "analyze/2" do
    test "returns zeroed analysis for nonexistent CPV" do
      result = MarketAnalysis.analyze("99")

      assert result.total_tenders == 0
      assert result.total_contracts == 0
      assert result.total_open == 0
      assert result.top_contractors == []
      assert result.top_ordering_parties == []
    end

    test "counts closed tenders matching CPV prefix" do
      insert_tender!(%{cpv_main: "45000000-7", notice_type: "ContractPerformingNotice"})
      insert_tender!(%{cpv_main: "45200000-9", notice_type: "ContractPerformingNotice"})
      insert_tender!(%{cpv_main: "72000000-5", notice_type: "ContractPerformingNotice"})

      result = MarketAnalysis.analyze("45")

      assert result.total_tenders == 2
    end

    test "counts open tenders separately" do
      insert_tender!(%{cpv_main: "45000000-7", notice_type: "ContractPerformingNotice"})
      insert_tender!(%{cpv_main: "45000000-7", notice_type: "ContractNotice"})
      insert_tender!(%{cpv_main: "45000000-7", notice_type: "ContractNotice"})

      result = MarketAnalysis.analyze("45")

      assert result.total_tenders == 1
      assert result.total_open == 2
    end

    test "filters by province when provided" do
      insert_tender!(%{cpv_main: "45000000-7", organization_province: "PL14"})
      insert_tender!(%{cpv_main: "45000000-7", organization_province: "PL02"})

      result = MarketAnalysis.analyze("45", "PL14")

      assert result.total_tenders == 1
    end

    test "province empty string means all provinces" do
      insert_tender!(%{cpv_main: "45000000-7", organization_province: "PL14"})
      insert_tender!(%{cpv_main: "45000000-7", organization_province: "PL02"})

      result = MarketAnalysis.analyze("45", "")

      assert result.total_tenders == 2
    end
  end

  describe "top_contractors" do
    test "extracts contractors from signed contracts" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "Firma ABC",
            contractor_city: "Warszawa",
            contractor_nip: "1234567890"
          }
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.total_contracts == 1
      assert [contractor] = result.top_contractors
      assert contractor.name == "Firma ABC"
      assert contractor.wins == 1
    end

    test "ignores cancelled contracts" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{part: 1, status: "cancelled", contractor_name: "Cancelled Co", contractor_nip: "111"}
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.total_contracts == 0
      assert result.top_contractors == []
    end

    test "groups contractors by NIP" do
      for _ <- 1..3 do
        insert_tender!(%{
          cpv_main: "45000000-7",
          notice_type: "ContractPerformingNotice",
          contractors_contract_details: [
            %{
              part: 1,
              status: "contract_signed",
              contractor_name: "Same Company",
              contractor_city: "Gdansk",
              contractor_nip: "9999999999"
            }
          ]
        })
      end

      result = MarketAnalysis.analyze("45")

      assert [contractor] = result.top_contractors
      assert contractor.wins == 3
      assert contractor.name == "Same Company"
    end

    test "deduplicates contractors by NIP despite different case" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "AMB BUDOWNICTWO",
            contractor_city: "Warszawa",
            contractor_nip: "1112223344"
          }
        ]
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "AMB Budownictwo",
            contractor_city: "Warszawa",
            contractor_nip: "1112223344"
          }
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert [contractor] = result.top_contractors
      assert contractor.wins == 2
    end

    test "deduplicates contractors without NIP by normalized name" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "FIRMA BUDOWLANA SP. Z O.O.",
            contractor_city: "Krakow",
            contractor_nip: ""
          }
        ]
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "Firma Budowlana Sp. z o.o.",
            contractor_city: "Krakow",
            contractor_nip: ""
          }
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert [contractor] = result.top_contractors
      assert contractor.wins == 2
    end

    test "deduplicates ordering parties by normalized name" do
      for _ <- 1..2 do
        insert_tender!(%{
          cpv_main: "45000000-7",
          notice_type: "ContractPerformingNotice",
          organization_name: "URZĄD MIASTA KRAKOWA"
        })
      end

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        organization_name: "Urząd Miasta Krakowa"
      })

      result = MarketAnalysis.analyze("45")

      assert [party] = result.top_ordering_parties
      assert party.count == 3
    end

    test "filters out contractors with empty names" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{part: 1, status: "contract_signed", contractor_name: "", contractor_nip: ""}
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.top_contractors == []
    end

    test "sorts by wins descending and takes top 15" do
      for i <- 1..20 do
        for _ <- 1..i do
          insert_tender!(%{
            cpv_main: "45000000-7",
            notice_type: "ContractPerformingNotice",
            contractors_contract_details: [
              %{
                part: 1,
                status: "contract_signed",
                contractor_name: "Company #{i}",
                contractor_city: "City",
                contractor_nip: "NIP#{i}"
              }
            ]
          })
        end
      end

      result = MarketAnalysis.analyze("45")

      assert length(result.top_contractors) == 15
      assert hd(result.top_contractors).wins == 20
      assert List.last(result.top_contractors).wins == 6
    end
  end

  describe "top_ordering_parties" do
    test "groups by organization name" do
      for _ <- 1..3 do
        insert_tender!(%{
          cpv_main: "45000000-7",
          notice_type: "ContractPerformingNotice",
          organization_name: "Urząd Miasta Krakowa",
          organization_city: "Kraków"
        })
      end

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        organization_name: "Urząd Miasta Warszawy",
        organization_city: "Warszawa"
      })

      result = MarketAnalysis.analyze("45")

      assert hd(result.top_ordering_parties).name == "Urząd Miasta Krakowa"
      assert hd(result.top_ordering_parties).count == 3
    end
  end

  describe "price_distribution" do
    test "returns empty when no prices available" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{part: 1, status: "contract_signed", contractor_name: "X", contractor_nip: "1"}
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.price_distribution.count == 0
      assert result.price_distribution.buckets == []
    end

    test "computes stats when winning_price is available" do
      for price <- [100_000, 200_000, 300_000, 400_000] do
        insert_tender!(%{
          cpv_main: "45000000-7",
          notice_type: "ContractPerformingNotice",
          contractors_contract_details: [
            %{
              part: 1,
              status: "contract_signed",
              contractor_name: "Firm",
              contractor_nip: "N#{price}",
              winning_price: Decimal.new(price)
            }
          ]
        })
      end

      result = MarketAnalysis.analyze("45")

      assert result.price_distribution.count == 4
      assert result.price_distribution.min == 100_000.0
      assert result.price_distribution.max == 400_000.0
      assert result.price_distribution.avg == 250_000.0
    end

    test "uses contract_value as fallback when winning_price nil" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "Firm",
            contractor_nip: "N1",
            winning_price: nil,
            contract_value: Decimal.new(500_000)
          }
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.price_distribution.count == 1
      assert result.price_distribution.min == 500_000.0
    end

    test "ignores zero prices" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        contractors_contract_details: [
          %{
            part: 1,
            status: "contract_signed",
            contractor_name: "Firm",
            contractor_nip: "N1",
            winning_price: Decimal.new(0),
            contract_value: Decimal.new(0)
          }
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.price_distribution.count == 0
    end
  end

  describe "criteria" do
    test "analyzes criteria from open tenders" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractNotice",
        kryteria: [
          %{"name" => "Cena", "weight" => 60},
          %{"name" => "Gwarancja", "weight" => 40}
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.criteria.total_tenders_with_criteria == 1
      assert result.criteria.price_only_pct == 0.0

      names = Enum.map(result.criteria.top_criteria, & &1.name)
      assert "Cena" in names
      assert "Gwarancja" in names
    end

    test "detects price-only tenders" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractNotice",
        kryteria: [%{"name" => "Cena", "weight" => 100}]
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractNotice",
        kryteria: [
          %{"name" => "Cena", "weight" => 60},
          %{"name" => "Termin", "weight" => 40}
        ]
      })

      result = MarketAnalysis.analyze("45")

      assert result.criteria.price_only_pct == 50.0
    end

    test "handles empty criteria gracefully" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractNotice",
        kryteria: []
      })

      result = MarketAnalysis.analyze("45")

      assert result.criteria.price_only_pct == nil
      assert result.criteria.top_criteria == []
    end
  end

  describe "trends" do
    test "groups tenders by month" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        publication_date: ~U[2026-01-15 10:00:00Z]
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        publication_date: ~U[2026-01-20 10:00:00Z]
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        publication_date: ~U[2026-02-10 10:00:00Z]
      })

      result = MarketAnalysis.analyze("45")

      jan = Enum.find(result.trends, &(&1.month == "2026-01"))
      feb = Enum.find(result.trends, &(&1.month == "2026-02"))

      assert jan.count == 2
      assert feb.count == 1
    end
  end

  describe "best_segments" do
    test "translates order types to Polish" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        order_type: "Works"
      })

      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        order_type: "Services"
      })

      result = MarketAnalysis.analyze("45")
      types = Enum.map(result.best_segments, & &1.order_type)

      assert "Roboty budowlane" in types
      assert "Usługi" in types
      refute "Works" in types
    end

    test "handles nil order_type" do
      insert_tender!(%{
        cpv_main: "45000000-7",
        notice_type: "ContractPerformingNotice",
        order_type: nil
      })

      result = MarketAnalysis.analyze("45")

      assert [segment] = result.best_segments
      assert segment.order_type == "Nieokreślone"
    end
  end

  describe "translate_order_type/1" do
    test "translates all known types" do
      assert MarketAnalysis.translate_order_type("Works") == "Roboty budowlane"
      assert MarketAnalysis.translate_order_type("Services") == "Usługi"
      assert MarketAnalysis.translate_order_type("Delivery") == "Dostawy"
      assert MarketAnalysis.translate_order_type(nil) == "Nieokreślone"
    end

    test "passes through unknown types" do
      assert MarketAnalysis.translate_order_type("CustomType") == "CustomType"
    end
  end

  describe "provinces/0" do
    test "returns all 16 provinces plus all-Poland option" do
      provinces = MarketAnalysis.provinces()

      assert length(provinces) == 17
      assert {"", "Cała Polska"} in provinces
      assert {"PL14", "Mazowieckie"} in provinces
    end
  end
end
