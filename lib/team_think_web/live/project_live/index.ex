defmodule TeamThinkWeb.ProjectLive.Index do
  @moduledoc """
  View for displaying projects that a user is associated with
  """

  use TeamThinkWeb, :live_view
  on_mount TeamThinkWeb.UserLiveAuth

  alias TeamThink.Accounts
  alias TeamThink.Projects
  alias TeamThink.Projects.Project
  alias TeamThinkWeb.Components.ResourceIndex

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_projects()
      |> group_projects()
    }
  end

  defp assign_projects(socket) do
    %{teams: teams} = Accounts.get_user!(socket.assigns.user.id, preload: [teams: [:project]])

    socket
    |> assign(:teams, teams)
    |> assign(:projects, Enum.map(teams, &(&1.project)))
  end

  defp group_projects(socket) do
    %{projects: projects, user: user} = socket.assigns

    projects
    |> Enum.reduce({[], []}, fn project, {mine, others} ->
      case project.user_id == user.id do
        true -> {[project | mine], others}
        false -> {mine, [project | others]}
      end
    end)
    |> then(fn {mine, others} ->
      socket
      |> assign(:mine, mine)
      |> assign(:others, others)
    end)
  end

  # defp sort_projects_by(projects, sort_key \\ :inserted_at) do
  #   projects
  #   |> Enum.map(&Map.from_struct/1)
  #   |> Enum.sort_by(&(&1[sort_key]))
  # end


  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :edit, %{"list_id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, Projects.get_project!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{user_id: socket.assigns.user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.user
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    {:noreply, assign(socket, :projects, list_projects(user))}
  end


  defp list_projects(user) do
    Projects.get_projects_by_user(user)
  end

end
