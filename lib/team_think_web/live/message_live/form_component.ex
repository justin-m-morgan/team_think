defmodule TeamThinkWeb.MessageLive.FormComponent do
  use TeamThinkWeb, :live_component

  alias TeamThink.Messages

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
  end

  # defp save_message(socket, :edit, message_params) do
  #   case Messages.update_message(socket.assigns.message, message_params) do
  #     {:ok, _message} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Message updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:ok, _message} ->
        {:noreply,
         socket

        #  |> push_redirect(to: socket.assigns.return_to)}
      }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
