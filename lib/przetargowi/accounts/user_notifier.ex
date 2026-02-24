defmodule Przetargowi.Accounts.UserNotifier do
  import Swoosh.Email
  require Logger

  alias Przetargowi.Mailer
  alias Przetargowi.Accounts.User

  defp deliver(recipient, subject, text_body, html_body) do
    email =
      new()
      |> to(recipient)
      |> from({"Przetargowi", "kontakt@przetargowi.pl"})
      |> subject(subject)
      |> text_body(text_body)
      |> html_body(html_body)

    case Mailer.deliver(email) do
      {:ok, metadata} ->
        Logger.info("Email sent to #{recipient}: #{inspect(metadata)}")
        {:ok, email}

      {:error, reason} ->
        Logger.error("Failed to send email to #{recipient}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp email_layout(content, button_text, button_url) do
    """
    <!DOCTYPE html>
    <html lang="pl">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Przetargowi</title>
    </head>
    <body style="margin: 0; padding: 0; background-color: #f8f6f1; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
      <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f8f6f1;">
        <tr>
          <td align="center" style="padding: 40px 20px;">
            <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="max-width: 480px;">
              <!-- Header -->
              <tr>
                <td align="center" style="padding-bottom: 32px;">
                  <table role="presentation" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="background-color: #12233d; width: 40px; height: 40px; border-radius: 12px; text-align: center; vertical-align: middle;">
                        <span style="color: #fefcf8; font-size: 18px;">&#9878;</span>
                      </td>
                      <td style="padding-left: 12px;">
                        <span style="font-size: 20px; font-weight: 600; color: #0a1628;">Przetargowi</span>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!-- Content Card -->
              <tr>
                <td style="background-color: #ffffff; border-radius: 16px; box-shadow: 0 1px 3px rgba(10,22,40,0.1);">
                  <table role="presentation" width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="padding: 40px 32px;">
                        #{content}

                        <!-- Button -->
                        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="margin-top: 32px;">
                          <tr>
                            <td align="center">
                              <a href="#{button_url}" style="display: inline-block; background-color: #12233d; color: #fefcf8; text-decoration: none; font-weight: 600; font-size: 14px; padding: 14px 28px; border-radius: 12px;">
                                #{button_text}
                              </a>
                            </td>
                          </tr>
                        </table>

                        <!-- Alternative Link -->
                        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="margin-top: 24px;">
                          <tr>
                            <td style="padding: 16px; background-color: #f8f6f1; border-radius: 8px;">
                              <p style="margin: 0 0 8px 0; font-size: 12px; color: #5a6a7a;">
                                Możesz też skopiować i wkleić ten link do przeglądarki:
                              </p>
                              <p style="margin: 0; font-size: 12px; color: #c9a227; word-break: break-all;">
                                #{button_url}
                              </p>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!-- Footer -->
              <tr>
                <td align="center" style="padding-top: 32px;">
                  <p style="margin: 0; font-size: 12px; color: #5a6a7a;">
                    &copy; #{Date.utc_today().year} Przetargowi. Wszelkie prawa zastrzeżone.
                  </p>
                  <p style="margin: 8px 0 0 0; font-size: 11px; color: #8a9aaa;">
                    Jeśli nie oczekiwałeś tej wiadomości, zignoruj ją.
                  </p>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </body>
    </html>
    """
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = """
    Cześć,

    Otrzymaliśmy prośbę o zmianę adresu e-mail dla Twojego konta Przetargowi.

    Aby potwierdzić zmianę, kliknij w poniższy link:
    #{url}

    Jeśli nie prosiłeś o zmianę adresu e-mail, zignoruj tę wiadomość.

    Pozdrawiamy,
    Zespół Przetargowi
    """

    html_content = """
    <h1 style="margin: 0 0 16px 0; font-size: 24px; font-weight: 600; color: #0a1628;">
      Zmiana adresu e-mail
    </h1>
    <p style="margin: 0 0 16px 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Cześć,
    </p>
    <p style="margin: 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Otrzymaliśmy prośbę o zmianę adresu e-mail dla Twojego konta. Kliknij przycisk poniżej, aby potwierdzić zmianę.
    </p>
    """

    html_body = email_layout(html_content, "Potwierdź zmianę", url)
    deliver(user.email, "Potwierdź zmianę adresu e-mail", text_body, html_body)
  end

  @doc """
  Deliver instructions to log in with a magic link.
  """
  def deliver_login_instructions(user, url) do
    case user do
      %User{confirmed_at: nil} -> deliver_confirmation_instructions(user, url)
      _ -> deliver_magic_link_instructions(user, url)
    end
  end

  defp deliver_magic_link_instructions(user, url) do
    text_body = """
    Cześć,

    Oto Twój link do logowania w serwisie Przetargowi:
    #{url}

    Link jest ważny przez ograniczony czas.

    Jeśli nie prosiłeś o ten link, zignoruj tę wiadomość.

    Pozdrawiamy,
    Zespół Przetargowi
    """

    html_content = """
    <h1 style="margin: 0 0 16px 0; font-size: 24px; font-weight: 600; color: #0a1628;">
      Zaloguj się do Przetargowi
    </h1>
    <p style="margin: 0 0 16px 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Cześć,
    </p>
    <p style="margin: 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Kliknij przycisk poniżej, aby zalogować się na swoje konto. Link jest ważny przez ograniczony czas.
    </p>
    """

    html_body = email_layout(html_content, "Zaloguj się", url)
    deliver(user.email, "Twój link do logowania", text_body, html_body)
  end

  defp deliver_confirmation_instructions(user, url) do
    text_body = """
    Cześć,

    Dziękujemy za rejestrację w Przetargowi!

    Aby aktywować swoje konto, kliknij w poniższy link:
    #{url}

    Jeśli nie zakładałeś konta, zignoruj tę wiadomość.

    Pozdrawiamy,
    Zespół Przetargowi
    """

    html_content = """
    <h1 style="margin: 0 0 16px 0; font-size: 24px; font-weight: 600; color: #0a1628;">
      Witaj w Przetargowi!
    </h1>
    <p style="margin: 0 0 16px 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Dziękujemy za rejestrację!
    </p>
    <p style="margin: 0; font-size: 15px; line-height: 1.6; color: #2a3a4a;">
      Kliknij przycisk poniżej, aby potwierdzić swój adres e-mail i aktywować konto.
    </p>
    """

    html_body = email_layout(html_content, "Aktywuj konto", url)
    deliver(user.email, "Potwierdź swoje konto w Przetargowi", text_body, html_body)
  end
end
