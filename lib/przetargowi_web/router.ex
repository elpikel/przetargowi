defmodule PrzetargowiWeb.Router do
  use PrzetargowiWeb, :router

  import PrzetargowiWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PrzetargowiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PrzetargowiWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/szukaj", SearchController, :index
    get "/orzeczenie/:slug", JudgementController, :show
    get "/o-nas", StaticPageController, :about
    get "/kontakt", StaticPageController, :contact
    get "/regulamin", StaticPageController, :terms
    get "/polityka-prywatnosci", StaticPageController, :privacy

    # Tenders (BZP)
    get "/przetargi", TenderController, :index
    get "/przetargi/:slug", TenderController, :show

    # Document download
    get "/dokumenty/:id", DocumentController, :download

    # Reports
    get "/raporty", ReportController, :index
    get "/raporty/:slug", ReportController, :show
  end

  scope "/", PrzetargowiWeb do
    get "/sitemap.xml", SitemapController, :index
    get "/sitemap-static.xml", SitemapController, :static
    get "/sitemap/judgements/:page", SitemapController, :judgements
    get "/sitemap/tenders/:page", SitemapController, :tenders
  end

  # Analytics proxy to avoid ad blockers
  scope "/", PrzetargowiWeb do
    get "/js/stats.js", AnalyticsController, :script
    post "/api/event", AnalyticsController, :event
  end

  # Other scopes may use custom stacks.
  # scope "/api", PrzetargowiWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:przetargowi, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PrzetargowiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PrzetargowiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/rejestracja", UserRegistrationController, :new
    post "/rejestracja", UserRegistrationController, :create
    get "/rejestracja/potwierdz/:token", UserRegistrationController, :confirm

    # Password reset
    get "/zapomnialem-hasla", UserPasswordResetController, :new
    post "/zapomnialem-hasla", UserPasswordResetController, :create
    get "/resetuj-haslo/:token", UserPasswordResetController, :edit
    put "/resetuj-haslo/:token", UserPasswordResetController, :update
  end

  scope "/", PrzetargowiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/ustawienia", UserSettingsController, :edit
    put "/ustawienia", UserSettingsController, :update
    get "/ustawienia/potwierdz-email/:token", UserSettingsController, :confirm_email

    # Subscription management
    get "/subskrypcja", SubscriptionController, :show
    get "/subskrypcja/nowa", SubscriptionController, :new
    post "/subskrypcja", SubscriptionController, :create
    delete "/subskrypcja", SubscriptionController, :cancel
    post "/subskrypcja/wznow", SubscriptionController, :reactivate
    get "/subskrypcja/sukces", SubscriptionController, :payment_success
    get "/subskrypcja/blad", SubscriptionController, :payment_error

    # Alerts
    get "/alerty", AlertController, :index
    post "/alerty", AlertController, :create
    delete "/alerty/:id", AlertController, :delete

    # Company profiles
    get "/profil-firmy", ProfileController, :index
    get "/profil-firmy/nowy", ProfileController, :new
    post "/profil-firmy", ProfileController, :create
    get "/profil-firmy/:id/edycja", ProfileController, :edit
    put "/profil-firmy/:id", ProfileController, :update
    patch "/profil-firmy/:id", ProfileController, :update
    delete "/profil-firmy/:id", ProfileController, :delete
    post "/profil-firmy/:id/ustaw-domyslny", ProfileController, :set_primary

    # Document filling
    get "/przetargi/:slug/wypelnij", DocumentFillController, :show
    post "/przetargi/:slug/wypelnij", DocumentFillController, :create
  end

  # Webhook endpoints (no CSRF protection)
  scope "/webhooks", PrzetargowiWeb do
    pipe_through :api

    post "/stripe", WebhookController, :stripe
  end

  scope "/", PrzetargowiWeb do
    pipe_through [:browser]

    get "/logowanie", UserSessionController, :new
    post "/logowanie", UserSessionController, :create
    delete "/wyloguj", UserSessionController, :delete
  end
end
