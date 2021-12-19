defmodule TeamThinkWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias TeamThink.Accounts

  def on_mount(:default, _params, session, socket) do
    socket =
      socket
      |> assign_user(session)


      {:cont, socket}
  end

  def on_mount(:team_members, %{"project_id" => project_id}, session, socket) do
    socket =
      socket
      |> assign_user(session)

      case team_member?(socket.assigns.user, project_id) do
        true ->
          {:cont, socket}
        false ->
          {:halt,
            socket
            |> push_redirect(to: "/")
            |> put_flash(:alert, "Not a member of this team")
          }
      end
  end

  defp team_member?(user, project_id) do
    project_id
    |> TeamThink.Teams.get_team_by_project_id!()
    |> then(&(user in &1.team_mates))
  end

  defp assign_user(socket, session) do
    socket
      |> assign_new(:user, fn -> Accounts.get_user_by_session_token(session["user_token"]) end)
      |> assign_new(:session_id, fn -> session["live_socket_id"] end)
  end
end
