defmodule TeamThinkWeb.MessageLive.FormComponent do
  use TeamThinkWeb, :live_component

  alias TeamThink.Messages
  alias TeamThink.Conversations

  def mount(%{"task_id" => task_id}, _session, socket) do
    conversation = Conversations.get_conversation_by_task_id!(task_id)

    {:ok, assign(socket, :conversation, conversation)}
  end

  def mount(%{"list_id" => list_id}, _session, socket) do
    conversation = Conversations.get_conversation_by_list_id!(list_id)

    {:ok, assign(socket, :conversation, conversation)}
  end

  def mount(%{"project_id" => project_id}, _session, socket) do
    conversation = Conversations.get_conversation_by_project_id!(project_id)

    {:ok, assign(socket, :conversation, conversation)}
  end

  @impl true
  def update(assigns, socket) do
    message = %Messages.Message{}
    changeset = Messages.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:message, message)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    save_message(socket, :new, message_params)

    TeamThinkWeb.Endpoint.broadcast(socket.assigns.topic, "new_message", %{})

    {:noreply, socket}
  end

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> assign(:changeset, Messages.change_message(%Messages.Message{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
