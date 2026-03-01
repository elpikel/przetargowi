defmodule PrzetargowiWeb.SubscriptionController do
  use PrzetargowiWeb, :controller

  alias Przetargowi.Payments

  require Logger

  @doc """
  Shows the subscription management page.
  Displays current subscription status, next billing date, and payment history.
  """
  def show(conn, _params) do
    user = conn.assigns.current_scope.user
    subscription = Payments.get_user_subscription(user.id)
    transactions = Payments.list_user_transactions(user.id, limit: 10)

    render(conn, :show,
      subscription: subscription,
      transactions: transactions,
      plan_amounts: Payments.plan_amounts(),
      plan_names: Payments.plan_names()
    )
  end

  @doc """
  Shows the new subscription form / upgrade page with three plan options.
  """
  def new(conn, _params) do
    user = conn.assigns.current_scope.user
    subscription = Payments.get_user_subscription(user.id)

    # If user already has an active subscription, redirect to show
    if subscription && Payments.Subscription.active?(subscription) do
      conn
      |> put_flash(:info, "Masz już aktywną subskrypcję.")
      |> redirect(to: ~p"/subskrypcja")
    else
      render(conn, :new,
        plan_amounts: Payments.plan_amounts(),
        plan_names: Payments.plan_names()
      )
    end
  end

  @doc """
  Creates a new subscription by initiating Stripe checkout.
  Redirects user to Stripe Checkout page.
  """
  def create(conn, params) do
    user = conn.assigns.current_scope.user
    plan_type = get_in(params, ["plan_type"]) || "razem"

    # Validate plan type
    unless plan_type in ["alert", "wyszukiwarka", "razem"] do
      conn
      |> put_flash(:error, "Nieprawidłowy typ planu.")
      |> redirect(to: ~p"/subskrypcja/nowa")
    end

    callbacks = %{
      success_url: url(~p"/subskrypcja/sukces"),
      error_url: url(~p"/subskrypcja/blad"),
      notification_url: url(~p"/webhooks/stripe")
    }

    case Payments.create_subscription(user, callbacks, plan_type: plan_type) do
      {:ok, %{redirect_url: redirect_url}} ->
        redirect(conn, external: redirect_url)

      {:error, :already_subscribed} ->
        conn
        |> put_flash(:info, "Masz już aktywną subskrypcję.")
        |> redirect(to: ~p"/subskrypcja")

      {:error, reason} ->
        Logger.error("Failed to create subscription: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Nie udało się rozpocząć płatności. Spróbuj ponownie później.")
        |> redirect(to: ~p"/subskrypcja/nowa")
    end
  end

  @doc """
  Cancels the user's subscription.
  By default, cancels at the end of the current billing period.
  """
  def cancel(conn, _params) do
    user = conn.assigns.current_scope.user

    case Payments.cancel_user_subscription(user.id, false) do
      {:ok, _subscription} ->
        conn
        |> put_flash(
          :info,
          "Subskrypcja została anulowana. Dostęp Premium będzie aktywny do końca okresu rozliczeniowego."
        )
        |> redirect(to: ~p"/subskrypcja")

      {:error, :no_subscription} ->
        conn
        |> put_flash(:error, "Nie masz aktywnej subskrypcji.")
        |> redirect(to: ~p"/subskrypcja")

      {:error, reason} ->
        Logger.error("Failed to cancel subscription: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Nie udało się anulować subskrypcji. Spróbuj ponownie później.")
        |> redirect(to: ~p"/subskrypcja")
    end
  end

  @doc """
  Reactivates a cancelled subscription.
  Only works if the subscription was set to cancel at period end but is still active.
  """
  def reactivate(conn, _params) do
    user = conn.assigns.current_scope.user

    case Payments.reactivate_user_subscription(user.id) do
      {:ok, _subscription} ->
        conn
        |> put_flash(:info, "Subskrypcja została wznowiona. Automatyczne odnowienie zostało włączone.")
        |> redirect(to: ~p"/subskrypcja")

      {:error, :no_subscription} ->
        conn
        |> put_flash(:error, "Nie masz aktywnej subskrypcji.")
        |> redirect(to: ~p"/subskrypcja")

      {:error, :cannot_reactivate} ->
        conn
        |> put_flash(:error, "Nie można wznowić tej subskrypcji.")
        |> redirect(to: ~p"/subskrypcja")

      {:error, reason} ->
        Logger.error("Failed to reactivate subscription: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Nie udało się wznowić subskrypcji. Spróbuj ponownie później.")
        |> redirect(to: ~p"/subskrypcja")
    end
  end

  @doc """
  Handles successful return from Stripe Checkout.
  Note: The actual subscription activation happens via webhook.
  """
  def payment_success(conn, _params) do
    conn
    |> put_flash(
      :info,
      "Płatność została zainicjowana. Twoja subskrypcja zostanie aktywowana po potwierdzeniu płatności."
    )
    |> redirect(to: ~p"/subskrypcja")
  end

  @doc """
  Handles error return from Stripe Checkout.
  """
  def payment_error(conn, _params) do
    conn
    |> put_flash(:error, "Wystąpił błąd podczas płatności. Spróbuj ponownie.")
    |> redirect(to: ~p"/subskrypcja/nowa")
  end
end
