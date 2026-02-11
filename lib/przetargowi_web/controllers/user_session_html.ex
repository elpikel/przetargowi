defmodule PrzetargowiWeb.UserSessionHTML do
  use PrzetargowiWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:przetargowi, Przetargowi.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
