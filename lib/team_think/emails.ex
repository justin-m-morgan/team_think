defmodule TeamThink.Emails do
  @moduledoc """
  Functions for composing email templates
  """
  use Phoenix.Swoosh,
    view: TeamThink.UserNotifierView,
    layout: {TeamThink.EmailLayoutView, :base_layout}

  alias TeamThink.{Mailer}

  @theme_color "#14532d"

  # Delivers the email using the application mailer.
  def deliver(email) do
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def new_email(recipient, subject, template, assigns) do
    new()
    |> to(recipient)
    |> from({"TeamThink", "justin.coocookachoo@gmail.com"})
    |> subject(subject)
    |> render_body(template, Map.put(assigns, :theme_color, @theme_color))
    |> transform_mjml()
  end

  defp transform_mjml(email) do
    {:ok, mjml_compiled} =
      email
      |> Map.get(:html_body)
      |> Mjml.to_html()

    Map.put(email, :html_body, mjml_compiled)
  end
end
