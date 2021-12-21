defmodule TeamThinkWeb.Components.Ui.Breadcrumbs do
  use TeamThinkWeb, :live_component

  alias TeamThinkWeb.Components.Svg
  alias TeamThink.Tasks.Task
  alias TeamThink.TaskLists.TaskList
  alias TeamThink.Projects.Project

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:project, nil)
      |> assign(:task_list, nil)
      |> assign(:task, nil)
      |> assign_resources(assigns)
    }
  end

  defp assign_resources(socket, %{resource: %Task{} = task}) do
    task =
      task
      |> TeamThink.Repo.preload(task_list: [:project])
      |> Map.from_struct()

    task_list = Map.get(task, :task_list)
    project = Map.get(task_list, :project)

    socket
    |> assign(:task, task)
    |> assign(:task_list, task_list)
    |> assign(:project, project)
  end

  defp assign_resources(socket, %{resource: %TaskList{} = task_list}) do
    task_list =
      task_list
      |> TeamThink.Repo.preload([:project])

    socket
    |> assign(:task_list, task_list)
    |> assign(:project, Map.get(task_list, :project))
  end

  defp assign_resources(socket, %{resource: %Project{} = project}) do
    assign(socket, :project, project)
  end

  defp assign_resources(socket, _), do: socket

  def render(assigns) do
    ~H"""
    <div class="flex justify-start py-4 font-bold">
      <div class="flex items-center space-x-4 grow-0 bg-gray-50 shadow rounded-lg py-4 px-4">
        <%= live_redirect to: Routes.project_index_path(@socket, :index) do %>
          <Svg.home class="h-8"/>
        <% end %>


        <%= if @project do %>
          <.separator />
          <.link to={Routes.project_show_path(@socket, :show, @project)}>
            <%= @project.name %>
          </.link>
        <% end %>

        <%= if @task_list do %>
        <.separator />
          <.link to={Routes.task_list_index_path(@socket, :index, @project)}>
            Task Lists
          </.link>

          <.separator />
          <.link to={Routes.task_list_show_path(@socket, :show, @project, @task_list)}>
            <%= @task_list.name %>
          </.link>
        <% end %>

        <%= if @task do %>
          <.separator />
          <.link to={Routes.task_index_path(@socket, :index, @project, @task_list)}>
            Tasks
          </.link>
        <% end %>
      </div>
    </div>

    """
  end

  defp link(assigns) do
    ~H"""
    <%= live_redirect to: @to, class: "hover:text-accent-600" do %>
      <%= render_block(@inner_block) %>
    <% end %>
    """
  end

  defp separator(assigns) do
    ~H"""
    <span>&#9654;</span>
    """
  end
end
