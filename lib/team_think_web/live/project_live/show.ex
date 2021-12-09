defmodule TeamThinkWeb.ProjectLive.Show do
  @moduledoc """
  The single project view
  """

  use TeamThinkWeb, :live_view

  alias TeamThink.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Projects.get_project!(id))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end