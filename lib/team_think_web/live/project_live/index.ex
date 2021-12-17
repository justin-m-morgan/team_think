defmodule TeamThinkWeb.ProjectLive.Index do
  @moduledoc """
  View for displaying projects that a user is associated with
  """

  use TeamThinkWeb, :live_view

  import TeamThink.Accounts, only: [get_user_by_session_token: 1]

  alias TeamThink.Projects
  alias TeamThink.Projects.Project
  alias TeamThinkWeb.Components.ResourceIndex

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign_current_user(session)
      |> assign_projects()
    }
  end

  defp assign_current_user(socket, session) do
    assign(socket,
      user: get_user_by_session_token(session["user_token"]),
      session_id: session["live_socket_id"]
    )
  end

  defp assign_projects(socket) do
    socket
    |> assign(:projects, list_projects(socket.assigns.user))
  end

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
