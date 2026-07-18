defmodule Przetargowi.Workers.SendAlertsTest do
  use Przetargowi.DataCase
  use Oban.Testing, repo: Przetargowi.Repo

  alias Przetargowi.Alerts
  alias Przetargowi.Workers.SendAlerts

  import Przetargowi.AccountsFixtures
  import Przetargowi.TendersFixtures

  # mazowieckie maps to province code PL14 (see SendAlerts.region_to_province_code/1)
  @mazowieckie_province "PL14"

  # Drain all emails from the mailbox
  defp flush_emails do
    receive do
      {:email, _} -> flush_emails()
    after
      0 -> :ok
    end
  end

  # Returns true if an email whose subject contains `fragment` was sent
  defp email_sent_with_subject_containing?(fragment) do
    receive do
      {:email, %{subject: subject}} ->
        if String.contains?(subject, fragment),
          do: true,
          else: email_sent_with_subject_containing?(fragment)
    after
      100 -> false
    end
  end

  defp future_deadline do
    DateTime.utc_now() |> DateTime.add(5, :day) |> DateTime.truncate(:second)
  end

  # Mirrors what AlertController stores: the region *slug* and the order_type *code*
  # ("Delivery"/"Services"/"Works") as submitted by the tender filter form.
  defp simple_alert(user, rules) do
    {:ok, alert} = Alerts.create_simple_alert(Map.put(rules, "user_id", user.id))
    alert
  end

  describe "perform/1" do
    test "sends an email for an alert whose region and category match a notice" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Delivery"})

      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: @mazowieckie_province,
        notice_type: "ContractNotice",
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      assert email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "shows the Polish category label in the subject, not the raw code" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Delivery"})

      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: @mazowieckie_province,
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      assert email_sent_with_subject_containing?("Dostawy")
      refute email_sent_with_subject_containing?("Delivery")
    end

    test "sends an email for a region-only alert (no category selected)" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => nil})

      tender_notice_fixture(
        order_type: "Works",
        organization_province: @mazowieckie_province,
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      assert email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "sends an email for a category-only alert (no region selected)" do
      user = user_fixture()

      simple_alert(user, %{"region" => nil, "tender_category" => "Services"})

      tender_notice_fixture(
        order_type: "Services",
        organization_province: "PL22",
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      assert email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "still handles legacy alerts that stored the Polish label" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Dostawy"})

      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: @mazowieckie_province,
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      assert email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "does not send when no notices match the alert" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Delivery"})

      # Notice in a different province
      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: "PL22",
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      refute email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "does not send for notices whose deadline has passed" do
      user = user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Delivery"})

      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: @mazowieckie_province,
        submitting_offers_date:
          DateTime.utc_now() |> DateTime.add(-1, :day) |> DateTime.truncate(:second)
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      refute email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "does not send to users who have not confirmed their account" do
      user = unconfirmed_user_fixture()

      simple_alert(user, %{"region" => "mazowieckie", "tender_category" => "Delivery"})

      tender_notice_fixture(
        order_type: "Delivery",
        organization_province: @mazowieckie_province,
        submitting_offers_date: future_deadline()
      )

      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      refute email_sent_with_subject_containing?("Nowe przetargi")
    end

    test "returns :ok when there are no alerts" do
      flush_emails()

      assert :ok = perform_job(SendAlerts, %{})

      refute email_sent_with_subject_containing?("Nowe przetargi")
    end
  end
end
