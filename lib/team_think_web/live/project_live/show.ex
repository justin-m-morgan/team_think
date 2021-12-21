defmodule TeamThinkWeb.ProjectLive.Show do
  @moduledoc """
  The single project view
  """

  use TeamThinkWeb, :live_view

  alias TeamThink.Projects
  alias TeamThink.Teams
  alias TeamThinkWeb.Components.ResourceShow

  @impl true
  def handle_params(%{"project_id" => id}, _, socket) do
    project = Projects.get_project!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, project)
     |> assign_team(project)
     |> assign_navigation_items(project)}
  end

  defp assign_team(socket, project) do
    assign(socket, :team, Teams.get_team_by_project_id!(project.id, preload: :team_mates))
  end

  defp assign_navigation_items(socket, project) do
    assign(socket, :navigation_items, navigation_items(socket, project.id))
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"

  defp navigation_items(socket, project_id) do
    [
      %{
        illustration_name: "team",
        to: Routes.team_show_path(socket, :show, project_id, socket.assigns.team),
        label: "Team"
      },
      %{
        illustration_name: "next_tasks",
        to: Routes.task_list_index_path(socket, :index, project_id),
        label: "Task Lists"
      },
      %{
        illustration_name: "respond",
        to: Routes.conversation_show_path(socket, :show, project_id),
        label: "Conversation"
      }
    ]
  end
end
