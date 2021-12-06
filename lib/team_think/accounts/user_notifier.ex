defmodule TeamThink.Accounts.UserNotifier do
  @moduledoc """
  Notifier for user communications
  """

  import TeamThink.Emails, only: [new_email: 4, deliver: 1]

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    user.email
    |> new_email("Confirmation instructions", :confirmation_instructions, %{user: user, url: url})
    |> deliver()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    user.email
    |> new_email("Reset password instructions", :reset_password_instructions, %{
      user: user,
      url: url
    })
    |> deliver()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    user.email
    |> new_email("Update email instructions", :update_email_instructions, %{user: user, url: url})
    |> deliver()
  end
end
