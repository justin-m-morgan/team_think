defmodule TeamThinkWeb.TeamLive.Show do
  use TeamThinkWeb, :live_view


  alias TeamThink.Teams
  alias TeamThink.Projects
  alias TeamThinkWeb.TeamLive.FormComponent
  alias TeamThinkWeb.Components.Ui.Breadcrumbs
  alias TeamThinkWeb.Components.ResourceShow

  @impl true
  def mount(%{"project_id" => project_id, "team_id" => team_id}, _session, socket) do
    {
      :ok,
      socket
        |> assign(:project, Projects.get_project!(project_id))
        |> assign(:team, Teams.get_team!(team_id, preload: [:team_mates]))
    }
  end



  @impl true
  def handle_params(params, _, socket) do
    %{"project_id" => project_id, "team_id" => team_id} = params

    {:noreply,
     socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:navigation_items, navigation_items(socket, project_id, team_id))
    }
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"

  defp navigation_items(socket, project_id, team_id) do
    [
      %{
        illustration_name: "respond",
        to: Routes.team_show_path(socket, :show, project_id, team_id),
        label: "Conversation"
      }
    ]
  end

  @impl true
  def handle_event("remove_team_mate", %{"id" => team_mate_id}, socket) do
      team = socket.assigns.team
      team_mates = socket.assigns.team.team_mates
      team_mate_to_remove = Enum.find(team_mates, fn tm -> tm.id == String.to_integer(team_mate_id) end)

      case Teams.remove_team_member(team, team_mate_to_remove) do
        {:ok, updated_team } ->
          {:noreply, assign(socket, :team, updated_team)}
        {:error_changeset} ->
          {:noreply, put_flash(socket, :warning, "Can't remove person right now")}

      end
  end

  @impl true
  def handle_info({:updated_team, updated_team}, socket) do
    {
      :noreply,
      socket
        |> assign(:team, updated_team)
        |> put_flash(:info, "Team Updated")
    }
  end
end
