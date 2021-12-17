defmodule TeamThinkWeb.DashboardLive do
  @moduledoc """
  Main User dashboard
  """

  use TeamThinkWeb, :live_view

  import TeamThink.Accounts, only: [get_user_by_session_token: 1]

  alias TeamThink.Projects
  alias TeamThink.Projects.Project

  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign_current_user(session)
      |> fetch_projects()
    }
  end

  defp assign_current_user(socket, session) do
    assign(socket,
      user: get_user_by_session_token(session["user_token"]),
      session_id: session["live_socket_id"]
    )
  end

  defp fetch_projects(socket) do
    user = socket.assigns.user

    socket
    |> assign(:projects,
      user
      |> Projects.get_projects_by_user()
      |> group_projects(user.id)
    )
  end

  defp group_projects(projects, user_id) do
    projects
    |> Enum.reduce({[], []}, fn project, {mine, others} ->
      case project.user_id == user_id do
        true -> {[project | mine], others}
        false -> {mine, [project | others]}
      end
    end)
    |> then(fn {mine, others} -> %{mine: sort_projects_by(mine), others: sort_projects_by(others)} end)
  end

  defp sort_projects_by(projects, sort_key \\ :inserted_at) do
    projects
    |> Enum.map(&Map.from_struct/1)
    |> Enum.sort_by(&(&1[sort_key]))
  end

  def render(assigns) do
    ~H"""
    <section class="grid 2xl:grid-cols-2 gap-8 py-12">
      <.projects_listing socket={@socket} heading="Your Projects" projects={@projects.mine}>
        <:icon>
          <Svg.Illustrations.illustration illustration_name="working_late" class="h-64" />
        </:icon>
      </.projects_listing>

      <.projects_listing socket={@socket} heading="Team's Projects" projects={@projects.others}>
        <:icon>
          <Svg.Illustrations.illustration illustration_name="working_late" class="h-64" />
        </:icon>

      </.projects_listing>

    </section>
    """
  end

  defp projects_listing(assigns) do
    ~H"""
    <Ui.icon_card>
      <:icon>
        <%= render_slot(@icon) %>
      </:icon>
      <:heading><%= @heading %></:heading>
      <ul class="space-y-4">
        <%= for project <- @projects do %>
          <li class="border px-2 py-2 rounded-lg border-transparent hover:border-gray-300 ">
            <%= live_redirect to: Routes.project_show_path(@socket, :show, project.id) do %>
              <.project project={project} />
            <% end %>
          </li>
        <% end %>
      </ul>

      <%= render_slot(@inner_block) %>
    </Ui.icon_card>
    """
  end

  defp project(assigns) do
    ~H"""
    <div>
      <h3 class="font-bold font-xl"><%= @project.name %></h3>
      <p><%= @project.description %></p>
    </div>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:project, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Start a New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit an Existing Project")
    |> assign(:project, %Project{})
  end

  def handle_event("delete", %{"project_id" => id}, socket) do
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    {:noreply, fetch_projects(socket)}
  end

end
