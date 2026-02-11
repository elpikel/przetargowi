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
  end

  scope "/", PrzetargowiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/ustawienia", UserSettingsController, :edit
    put "/ustawienia", UserSettingsController, :update
    get "/ustawienia/potwierdz-email/:token", UserSettingsController, :confirm_email
  end

  scope "/", PrzetargowiWeb do
    pipe_through [:browser]

    get "/logowanie", UserSessionController, :new
    get "/logowanie/:token", UserSessionController, :confirm
    post "/logowanie", UserSessionController, :create
    delete "/wyloguj", UserSessionController, :delete
  end
end
