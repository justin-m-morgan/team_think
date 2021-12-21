defmodule TeamThinkWeb.ProjectLive.FormComponent do
  use TeamThinkWeb, :live_component

  require Logger

  alias TeamThink.Projects
  alias TeamThink.Teams
  alias TeamThink.Conversations

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Projects.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Projects.update_project(socket.assigns.project, project_params) do
      {:ok, _project} ->
        Logger.debug("Edit action")

        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    current_user = socket.assigns.user
    project_params = Map.put(project_params, "user_id", current_user.id)

    with {:ok, project} <- Projects.create_project(project_params),
         {:ok, team} <- Teams.create_team(%{project_id: project.id}),
         {:ok, _team} <- Teams.add_team_member(team, current_user),
         {:ok, _conversation} <- Conversations.create_conversation(project) do
      {:noreply,
       socket
       |> put_flash(:info, "Project created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
