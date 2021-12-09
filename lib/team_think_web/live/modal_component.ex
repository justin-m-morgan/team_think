defmodule TeamThinkWeb.ModalComponent do
  @moduledoc """
  A reusable modal live-component.

  ## Props

  **id** - identifier for the modal

  **return_to** - Route to redirect to upon closing

  **component** - Rendered contents

  **opts** - Options to pass to the rendered comonent
  """

  use TeamThinkWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>

      <div class="phx-modal-content rounded-lg max-w-3xl flex flex-col relative pt-12 px-6">
        <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close absolute right-0 top-0 mt-8 mr-6" %>
        <%= live_component @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
