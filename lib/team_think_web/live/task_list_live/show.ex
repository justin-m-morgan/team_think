defmodule TeamThinkWeb.TaskListLive.Show do
  use TeamThinkWeb, :live_view

  alias TeamThink.TaskLists
  alias TeamThinkWeb.Components.ResourceShow

  @impl true
  def mount(%{"project_id" => project_id}, _session, socket) do
    {
      :ok,
      socket
        |> assign(:project_id, project_id)
    }
  end

  @impl true
  def handle_params(%{"project_id" => project_id, "list_id" => list_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:task_list, TaskLists.get_task_list!(list_id))
     |> assign(:navigation_items, navigation_items(socket, project_id, list_id))}
  end

  defp page_title(:show), do: "Show Task List"
  defp page_title(:edit), do: "Edit Task List"

  defp navigation_items(socket, project_id, list_id) do
    [

      %{
        illustration_name: "next_tasks",
        to: Routes.task_index_path(socket, :index, project_id, list_id),
        label: "Tasks"
      },
      %{
        illustration_name: "respond",
        to: Routes.project_show_path(socket, :show, project_id),
        label: "Conversation"
      }
    ]
  end
end
