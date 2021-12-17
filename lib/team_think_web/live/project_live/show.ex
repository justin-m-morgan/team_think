defmodule TeamThinkWeb.ProjectLive.Show do
  @moduledoc """
  The single project view
  """

  use TeamThinkWeb, :live_view

  import TeamThink.Accounts, only: [get_user_by_session_token: 1]

  alias TeamThink.Projects
  alias TeamThinkWeb.Components.ResourceShow

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign_current_user(session)
    }
  end

  @impl true
  def handle_params(%{"project_id" => id}, _, socket) do
    project = Projects.get_project!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, project)
     |> assign(:navigation_items, navigation_item(socket, project.id))
  }
  end

  defp assign_current_user(socket, session) do
    assign(socket,
      user: get_user_by_session_token(session["user_token"]),
      session_id: session["live_socket_id"]
    )
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"

  defp navigation_item(socket, project_id) do
    [
      %{
        illustration_name: "team",
        to: Routes.dashboard_path(socket, :index),
        label: "Team"
      },
      %{
        illustration_name: "next_tasks",
        to: Routes.task_list_index_path(socket, :index, project_id ),
        label: "Task Lists"
      },
      %{
        illustration_name: "respond",
        to: Routes.dashboard_path(socket, :index),
        label: "Conversation"
      }
    ]
  end

end
