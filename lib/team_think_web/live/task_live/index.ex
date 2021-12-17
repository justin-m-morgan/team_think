defmodule TeamThinkWeb.TaskLive.Index do
  use TeamThinkWeb, :live_view

  alias TeamThink.Tasks
  alias TeamThink.Tasks.Task
  alias TeamThink.TaskLists
  alias TeamThinkWeb.Components.ResourceIndex

  @impl true
  def mount(params, _session, socket) do
    %{
      "project_id" => project_id,
      "list_id" => task_list_id
    } = params

    {
      :ok,
      socket
        |> assign(:project_id, project_id |> String.to_integer())
        |> assign(:task_list_id, task_list_id |> String.to_integer())
        |> assign(:task_list, TaskLists.get_task_list!(task_list_id))
        |> assign(:tasks, list_tasks(task_list_id))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"task_id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{task_list_id: socket.assigns[:task_list_id]})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks(socket.assigns.task_list_id))}
  end

  defp list_tasks(task_list_id) when is_binary(task_list_id) do
    task_list_id |> String.to_integer() |> list_tasks()
  end
  defp list_tasks(task_list_id) do
    Tasks.get_tasks_by_task_list_id(task_list_id)
  end

end
