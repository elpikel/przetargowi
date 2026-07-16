defmodule Przetargowi.Cpv do
  @moduledoc """
  CPV (Common Procurement Vocabulary) dictionary with Polish descriptions.
  Based on Regulation (EC) No 2195/2002 (CPV 2008 revision).
  """

  # {code_prefix, full_code, description}
  # Division level (2-digit) — official Polish names from portalzp.pl
  # Group level (3-digit) — from BZP API data
  @entries [
    {"03", "03000000-1", "Produkty rolnictwa, hodowli, rybołówstwa, leśnictwa i podobne"},
    {"031", "03100000-2", "Produkty rolnictwa i ogrodnictwa"},
    {"032", "03200000-3", "Zboża, ziemniaki, warzywa, owoce i orzechy"},
    {"033", "03300000-2", "Produkty hodowli, mięso i produkty mięsne"},
    {"09", "09000000-3", "Produkty naftowe, paliwo, energia elektryczna i inne źródła energii"},
    {"091", "09100000-0", "Paliwa"},
    {"093", "09300000-2", "Energia elektryczna, cieplna, słoneczna i jądrowa"},
    {"14", "14000000-1", "Górnictwo, metale podstawowe i produkty pokrewne"},
    {"142", "14200000-3", "Piasek i glina"},
    {"15", "15000000-8", "Żywność, napoje, tytoń i produkty pokrewne"},
    {"151", "15100000-9", "Produkty zwierzęce, mięso i produkty mięsne"},
    {"152", "15200000-0", "Ryby przetworzone i konserwowane"},
    {"153", "15300000-1", "Owoce, warzywa i podobne produkty"},
    {"154", "15400000-2", "Oleje i tłuszcze zwierzęce lub roślinne"},
    {"155", "15500000-3", "Produkty mleczarskie"},
    {"156", "15600000-4", "Produkty przemiału ziarna, skrobi i produktów skrobiowych"},
    {"158", "15800000-6", "Różne produkty spożywcze"},
    {"16", "16000000-5", "Maszyny rolnicze"},
    {"167", "16700000-2", "Ciągniki"},
    {"18", "18000000-9", "Odzież, obuwie, artykuły bagażowe i dodatki"},
    {"181", "18100000-0", "Odzież branżowa, specjalna odzież robocza"},
    {"188", "18800000-7", "Obuwie"},
    {"19", "19000000-6", "Skóra i tkaniny włókiennicze, tworzywa sztuczne i guma"},
    {"22", "22000000-0", "Druki i produkty podobne"},
    {"24", "24000000-4", "Produkty chemiczne"},
    {"249", "24900000-3", "Produkty chemiczne wysokowartościowe i różne"},
    {"30", "30000000-9",
     "Maszyny biurowe i liczące, sprzęt i materiały, z wyjątkiem mebli i pakietów oprogramowania"},
    {"301", "30100000-0", "Maszyny biurowe, sprzęt i materiały biurowe"},
    {"302", "30200000-1", "Urządzenia komputerowe"},
    {"31", "31000000-6", "Maszyny, aparatura, urządzenia i wyroby elektryczne; oświetlenie"},
    {"311", "31100000-7", "Silniki elektryczne, generatory i transformatory"},
    {"315", "31500000-1", "Urządzenia oświetleniowe i lampy elektryczne"},
    {"32", "32000000-3",
     "Sprzęt radiowy, telewizyjny, komunikacyjny, telekomunikacyjny i podobny"},
    {"324", "32400000-7", "Sieci"},
    {"325", "32500000-8", "Urządzenia i artykuły telekomunikacyjne"},
    {"33", "33000000-0", "Urządzenia medyczne, farmaceutyki i produkty do pielęgnacji ciała"},
    {"331", "33100000-1", "Urządzenia medyczne"},
    {"336", "33600000-6", "Produkty farmaceutyczne"},
    {"337", "33700000-7", "Produkty do pielęgnacji ciała"},
    {"34", "34000000-7", "Sprzęt transportowy i produkty pomocnicze dla transportu"},
    {"341", "34100000-8", "Pojazdy silnikowe"},
    {"343", "34300000-0", "Części i akcesoria do pojazdów i silników"},
    {"35", "35000000-4", "Sprzęt bezpieczeństwa, gaśniczy, policyjny i obronny"},
    {"351", "35100000-5", "Urządzenia awaryjne i zabezpieczające"},
    {"37", "37000000-8",
     "Instrumenty muzyczne, artykuły sportowe, gry, zabawki, wyroby rzemieślnicze"},
    {"374", "37400000-2", "Artykuły i sprzęt sportowy"},
    {"38", "38000000-5", "Sprzęt laboratoryjny, optyczny i precyzyjny (z wyjątkiem szklanego)"},
    {"39", "39000000-2",
     "Meble (włącznie z biurowymi), wyposażenie, urządzenia domowe i środki czyszczące"},
    {"391", "39100000-3", "Meble"},
    {"395", "39500000-7", "Wyroby włókiennicze"},
    {"398", "39800000-0", "Środki czyszczące i polerujące"},
    {"41", "41000000-9", "Woda zbierana i oczyszczona"},
    {"42", "42000000-6", "Maszyny przemysłowe"},
    {"43", "43000000-3", "Maszyny górnicze, do pracy w kamieniołomach, sprzęt budowlany"},
    {"44", "44000000-0", "Konstrukcje i materiały budowlane; wyroby pomocnicze dla budownictwa"},
    {"441", "44100000-1", "Materiały konstrukcyjne i elementy podobne"},
    {"45", "45000000-7", "Roboty budowlane"},
    {"451", "45100000-8", "Przygotowanie terenu pod budowę"},
    {"452", "45200000-9",
     "Roboty budowlane w zakresie wznoszenia kompletnych obiektów budowlanych lub ich części oraz roboty w zakresie inżynierii lądowej i wodnej"},
    {"453", "45300000-0", "Roboty instalacyjne w budynkach"},
    {"454", "45400000-1", "Roboty wykończeniowe w zakresie obiektów budowlanych"},
    {"455", "45500000-2", "Wynajem maszyn i urządzeń wraz z obsługą operatorską"},
    {"48", "48000000-8", "Pakiety oprogramowania i systemy informatyczne"},
    {"481", "48100000-9", "Przemysłowe specyficzne pakiety oprogramowania"},
    {"486", "48600000-4", "Pakiety oprogramowania dla baz danych i operacyjne"},
    {"487", "48700000-5", "Pakiety oprogramowania użytkowego"},
    {"488", "48800000-6", "Systemy i serwery informacyjne"},
    {"50", "50000000-5", "Usługi naprawcze i konserwacyjne"},
    {"501", "50100000-6", "Usługi napraw i konserwacji pojazdów i podobnego sprzętu"},
    {"504", "50400000-9", "Usługi napraw i konserwacji urządzeń medycznych i precyzyjnych"},
    {"507", "50700000-2", "Usługi napraw i konserwacji instalacji budynkowych"},
    {"51", "51000000-9", "Usługi instalowania (z wyjątkiem oprogramowania komputerowego)"},
    {"55", "55000000-0", "Usługi hotelarskie, restauracyjne i handlu detalicznego"},
    {"551", "55100000-1", "Usługi hotelarskie"},
    {"553", "55300000-3", "Usługi restauracyjne i dotyczące podawania posiłków"},
    {"555", "55500000-5", "Usługi bufetowe oraz w zakresie podawania posiłków"},
    {"60", "60000000-8", "Usługi transportowe (z wyłączeniem transportu odpadów)"},
    {"601", "60100000-9", "Usługi w zakresie transportu drogowego"},
    {"63", "63000000-9",
     "Usługi dodatkowe i pomocnicze w zakresie transportu, usługi biur podróży"},
    {"64", "64000000-6", "Usługi pocztowe i telekomunikacyjne"},
    {"641", "64100000-7", "Usługi pocztowe i kurierskie"},
    {"642", "64200000-8", "Usługi telekomunikacyjne"},
    {"65", "65000000-3", "Obiekty użyteczności publicznej"},
    {"66", "66000000-0", "Usługi finansowe i ubezpieczeniowe"},
    {"661", "66100000-1", "Usługi bankowe i inwestycyjne"},
    {"70", "70000000-1", "Usługi w zakresie nieruchomości"},
    {"71", "71000000-8", "Usługi architektoniczne, budowlane, inżynieryjne i kontrolne"},
    {"712", "71200000-0", "Usługi architektoniczne i podobne"},
    {"713", "71300000-1", "Usługi inżynieryjne"},
    {"715", "71500000-3", "Usługi związane z budownictwem"},
    {"717", "71700000-5", "Usługi nadzoru i kontroli"},
    {"72", "72000000-5",
     "Usługi informatyczne: konsultacyjne, opracowywania oprogramowania, internetowe i wsparcia"},
    {"721", "72100000-6", "Usługi doradcze w zakresie sprzętu komputerowego"},
    {"722", "72200000-7", "Usługi doradcze w zakresie programowania oprogramowania"},
    {"723", "72300000-8", "Usługi w zakresie danych"},
    {"725", "72500000-0", "Komputerowe usługi pokrewne"},
    {"73", "73000000-2",
     "Usługi badawcze i eksperymentalno-rozwojowe oraz pokrewne usługi doradcze"},
    {"75", "75000000-6", "Usługi administracji publicznej, obrony i zabezpieczenia socjalnego"},
    {"76", "76000000-3", "Usługi przemysłu naftowego oraz gazowniczego"},
    {"77", "77000000-0", "Usługi rolnicze, leśne, ogrodnicze, hydroponiczne i pszczelarskie"},
    {"771", "77100000-1", "Usługi rolnicze"},
    {"773", "77300000-3", "Usługi ogrodnicze"},
    {"79", "79000000-4",
     "Usługi biznesowe: prawnicze, marketingowe, konsultingowe, rekrutacji, drukowania i zabezpieczania"},
    {"791", "79100000-5", "Usługi prawnicze"},
    {"793", "79300000-7", "Badania rynkowe i ekonomiczne; ankietowanie i statystyka"},
    {"797", "79700000-1", "Usługi detektywistyczne i ochroniarskie"},
    {"799", "79900000-3", "Różne usługi branżowe i podobne"},
    {"80", "80000000-4", "Usługi edukacyjne i szkoleniowe"},
    {"805", "80500000-9", "Usługi szkoleniowe"},
    {"85", "85000000-9", "Usługi w zakresie zdrowia i opieki społecznej"},
    {"851", "85100000-0", "Usługi ochrony zdrowia"},
    {"853", "85300000-2", "Usługi pracy społecznej i podobnej"},
    {"90", "90000000-7",
     "Usługi odbioru ścieków, usuwania odpadów, czyszczenia/sprzątania i usługi ekologiczne"},
    {"905", "90500000-2", "Usługi związane z odpadami"},
    {"906", "90600000-3",
     "Usługi sprzątania oraz usługi sanitarne na obszarach miejskich lub wiejskich"},
    {"909", "90900000-6", "Usługi w zakresie sprzątania i odkażania"},
    {"92", "92000000-1", "Usługi rekreacyjne, kulturalne i sportowe"},
    {"98", "98000000-3", "Inne usługi komunalne, socjalne i osobiste"}
  ]

  @doc """
  Returns all CPV entries sorted by code.
  Each entry is a tuple: {code_prefix, full_code, description}
  """
  def all, do: @entries

  @doc """
  Searches CPV entries by code prefix or description text.
  Returns up to `limit` matching entries.
  """
  def search(query, limit \\ 20)
  def search("", limit), do: Enum.take(@entries, limit)
  def search(nil, limit), do: Enum.take(@entries, limit)

  def search(query, limit) do
    query = String.trim(query)
    query_down = String.downcase(query)
    digits = String.replace(query, ~r/[^0-9]/, "")

    @entries
    |> Enum.filter(fn {prefix, full_code, description} ->
      code_match =
        digits != "" and
          (String.starts_with?(prefix, digits) or String.starts_with?(full_code, digits))

      text_match = String.contains?(String.downcase(description), query_down)
      code_match or text_match
    end)
    |> Enum.sort_by(fn {prefix, _full_code, _desc} ->
      cond do
        digits != "" and String.starts_with?(prefix, digits) -> {0, prefix}
        true -> {1, prefix}
      end
    end)
    |> Enum.take(limit)
  end

  @doc """
  Returns the description for a given CPV code prefix or full code.
  """
  def description(code) do
    case find(code) do
      {_, _, desc} -> desc
      nil -> nil
    end
  end

  @doc """
  Finds an entry by prefix or full code. Returns {prefix, full_code, description} or nil.
  """
  def find(code) do
    Enum.find(@entries, fn {prefix, full_code, _} ->
      prefix == code or full_code == code
    end)
  end

  @doc """
  Returns the prefix for a given full code or prefix.
  """
  def to_prefix(code) do
    case find(code) do
      {prefix, _, _} -> prefix
      nil -> String.replace(code, ~r/[^0-9]/, "") |> String.slice(0, 2)
    end
  end
end
