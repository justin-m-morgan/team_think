defmodule TeamThinkWeb.TaskListLive.Index do
  @moduledoc """
  View for displaying a project's TaskLists
  """

  use TeamThinkWeb, :live_view

  alias TeamThink.TaskLists
  alias TeamThink.TaskLists.TaskList
  alias TeamThink.Projects
  alias TeamThinkWeb.Components.ResourceIndex

  @impl true
  def mount(params, _session, socket) do
    project_id = Map.get(params, "project_id")

    {:ok,
      socket
      |> assign(:project, Projects.get_project!(project_id))
      |> assign(:project_id, project_id)
      |> assign(:task_lists, list_task_lists(project_id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :edit, %{"list_id" => id}) do
    socket
    |> assign(:page_title, "Edit Task list")
    |> assign(:task_list, TaskLists.get_task_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task list")
    |> assign(:task_list, %TaskList{project_id: socket.assigns[:project_id]})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Task lists")
    |> assign(:task_list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task_list = TaskLists.get_task_list!(id)
    {:ok, _} = TaskLists.delete_task_list(task_list)

    {:noreply, assign(socket, :task_lists, list_task_lists(socket.assigns.project_id))}
  end

  defp list_task_lists(project_id) when is_binary(project_id) do
    project_id |> String.to_integer() |> list_task_lists()
  end
  defp list_task_lists(project_id) do
    TaskLists.get_task_lists_by_project_id(project_id)
  end

end
