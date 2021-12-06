defmodule TeamThink.Accounts.UserNotifier do
  @moduledoc """
  Notifier for user communications
  """
  import Swoosh.Email

  alias TeamThink.{Emails, Mailer}


  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, text_body, html_body) do
    email =
      new()
      |> to(recipient)
      |> from({"TeamThink", "justin.coocookachoo@gmail.com"})
      |> subject(subject)
      |> html_body(html_body)
      |> text_body(text_body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    text_email = confirmation_instructions_text(user, url)
    html_email = confirmation_instructions_html(user, url)
    deliver(user.email, "Confirmation instructions", text_email, html_email)
  end

  defp confirmation_instructions_text(user, url) do
    """
    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """
  end

  defp confirmation_instructions_html(user, url) do
    Emails.generate_template(
      "confirmation_instructions.mjml",
      [
        {"$url$", url},
        {"{{email}}", user.email}
      ])
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    text_email = reset_password_instructions_text(user, url)
    html_email = reset_password_instructions_html(user, url)
    deliver(user.email, "Reset password instructions", text_email, html_email)
  end

  defp reset_password_instructions_text(user, url) do
    """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end

  defp reset_password_instructions_html(user, url) do
    Emails.generate_template(
      "reset_password_instructions.mjml",
      [
        {"$url$", url},
        {"{{email}}", user.email}
      ])
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_email = update_email_instructions_text(user, url)
    html_email = update_email_instructions_html(user, url)

    deliver(user.email, "Update email instructions", text_email, html_email)
  end

  defp update_email_instructions_text(user, url) do
    """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end
  defp update_email_instructions_html(user, url) do
    Emails.generate_template(
      "update_email_instructions.mjml",
      [
        {"$url$", url},
        {"{{email}}", user.email}
      ])
  end
end
