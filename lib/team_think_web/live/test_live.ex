defmodule TeamThinkWeb.TestLive do
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
    <div class="min-h-screen flex justify-center items-center">
      <p class="px-12 py-8 bg-primary-100">This is a live view</p>
    </div>
    """
  end
end
