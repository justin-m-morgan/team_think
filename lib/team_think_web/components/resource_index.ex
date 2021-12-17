defmodule TeamThinkWeb.Components.ResourceIndex do
  use TeamThinkWeb, :component

  def template(assigns) do
    ~H"""

    <.live_component module={Ui.Breadcrumbs} id="breadcrumbs" resource={@resource} />

    <div class="card px-8 pb-12">
    <div class="relative py-8">
        <h1 class="mx-auto font-bold text-4xl text-center py-4">
          <%= @title %>
        </h1>
        <%= live_patch to: @new_path, class: "button flex items-center absolute right-0 top-10" do%>
          <Svg.add class="h-8 mr-3" />
          <%= @new_label %>
        <% end %>
    </div>

    <div data-test={"#{@resource_name}s-container"} class="grid lg:grid-cols-3 gap-8 ">
      <%= if length(@resource_list) > 0 do %>

      <%= for resource_item <- @resource_list do %>
        <div
          data-test={"#{@resource_name}-details"}
          id={"#{@resource_name}-#{resource_item.id}"}
          class="flex flex-col border px-4 py-8 text-center bg-white rounded-md"
        >
          <h2 class=" font-bold text-lg py-3">
            <%= render_slot(@resource_heading, resource_item) %>
          </h2>
          <p>
            <%= render_slot(@resource_summary, resource_item) %>
          </p>
          <div class="mt-auto flex justify-center space-x-3 pt-8">
            <%= live_redirect to: render_slot(@show_link, resource_item) do %>
            <.action_button>
              <Svg.eye class="h-4" />
              <span>Show</span>
            </.action_button>
            <% end %>
            <%= live_patch to: render_slot(@edit_link, resource_item) do %>
              <.action_button>
                <Svg.edit class="h-4" />
                <span>Edit</span>
              </.action_button>
            <% end %>
            <%= link to: "#", phx_click: "delete", phx_value_id: resource_item.id, data: [confirm: "Are you sure?"] do %>
              <.action_button>
                <Svg.trash class="h-4" />
                <span>Delete</span>
              </.action_button>
            <% end %>
          </div>
        </div>
      <% end %>

      <% else %>
        <div data-test={"no-#{@resource_name}s-placeholder"}></div>
        <p class="text-center text-2xl font-thin">You do not have any <%= @resource_name %>s yet.</p>
      <% end %>
    </div>

    </div>

    """
  end

  defp action_button(assigns) do
    ~H"""
    <span class="flex items-center space-x-2 bg-gray-800 hover:bg-accent-500 text-white py-1 px-4 rounded-full">
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

end
