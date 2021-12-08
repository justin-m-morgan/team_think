defmodule TeamThinkWeb.DashboardLive do
  @moduledoc """
  Main User dashboard
  """

  use TeamThinkWeb, :live_view

  import TeamThink.Accounts, only: [get_user_by_session_token: 1]

  def mount(_params, session, socket) do
    {
      :ok,
      assign(socket,
        user: get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
    }
  end

  def render(assigns) do
    ~H"""
    <div class="grid md:grid-cols-2 gap-8">
      <Ui.card>
        <:icon>
          <Svg.Illustrations.working_late class="h-64" />
        </:icon>
        <:heading>Your Projects</:heading>
      </Ui.card>
      <Ui.card>
        <:icon>
          <Svg.Illustrations.our_solution class="h-64" />
        </:icon>
        <:heading>Your Team's Projects</:heading>
      </Ui.card>

    </div>
    """
  end
end
