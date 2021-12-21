defmodule TeamThinkWeb.TaskLive.Show do
  use TeamThinkWeb, :live_view

  alias TeamThink.Tasks
  alias TeamThinkWeb.Components.ResourceShow

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    %{"project_id" => project_id, "list_id" => list_id, "task_id" => task_id} = params

    {:noreply,
     socket
      |> assign(:project_id, project_id)
      |> assign(:list_id, list_id)
      |> assign(:task_list_id, list_id)
      |> assign(:task_id, task_id)
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:task, Tasks.get_task!(task_id))
      |> assign(:navigation_items, navigation_items(socket, project_id, list_id, task_id))
    }
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"

  defp navigation_items(socket, project_id, list_id, task_id) do
    [
      %{
        illustration_name: "respond",
        to: Routes.conversation_show_path(socket, :show, project_id, list_id, task_id),
        label: "Conversation"
      }
    ]
  end
end
