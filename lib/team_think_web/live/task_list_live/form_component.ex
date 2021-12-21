defmodule TeamThinkWeb.TaskListLive.FormComponent do
  use TeamThinkWeb, :live_component

  alias TeamThink.TaskLists
  alias TeamThink.Conversations

  @impl true
  def update(%{task_list: task_list} = assigns, socket) do
    changeset = TaskLists.change_task_list(task_list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"task_list" => task_list_params}, socket) do
    changeset =
      socket.assigns.task_list
      |> TaskLists.change_task_list(task_list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task_list" => task_list_params}, socket) do
    save_task_list(socket, socket.assigns.action, task_list_params)
  end

  defp save_task_list(socket, :edit, task_list_params) do
    case TaskLists.update_task_list(socket.assigns.task_list, task_list_params) do
      {:ok, _task_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task list updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_task_list(socket, :new, task_list_params) do
    with {:ok, task_list} <- TaskLists.create_task_list(task_list_params),
         {:ok, _conversation} <- Conversations.create_conversation(task_list) do
      {:noreply,
       socket
       |> put_flash(:info, "Task list created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
