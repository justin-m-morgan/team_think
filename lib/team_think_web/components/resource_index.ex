defmodule TeamThinkWeb.Components.ResourceIndex do
  @moduledoc """
  A template for displaying a list of resources

  ## Props

  **breadcrumb_resource** - Resource used to generate the breadcrumbs

  **title** - Central heading

  **new_path** (optional) - Route to :new action

  **new_label** (optional) - Button text for :new trigger

  **resource_list** - resources to display

  **edit_link** (optional) - Route to :edit action

  **delete** (optional) - Display delete resource button

  ## Slots

  **resource_heading** - Heading in resource_item card

  **resource_summary** - Summary text in resource_item card
  """

  use TeamThinkWeb, :component

  def template(assigns) do
    assigns =
      assigns
        |> assign_new(:svg, fn -> false end)
        |> assign_new(:breadcrumbs_resource, fn -> false end)
        |> assign_new(:new_path, fn -> false end)
        |> assign_new(:edit_link, fn -> false end)
        |> assign_new(:delete, fn -> false end)
    ~H"""

    <%= if @breadcrumbs_resource do %>
      <.live_component
        module={Ui.Breadcrumbs}
        id="breadcrumbs"
        resource={@breadcrumbs_resource}
      />
    <% end %>



    <div class="card px-8 py-12 grid md:grid-cols-3">
      <div class="py-8 flex flex-col items-center">
        <%= if @svg do %>
          <div class="flex justify-center h-64">
            <%= render_slot(@svg) %>
          </div>
        <% end %>
        <h1 class="mx-auto font-bold text-4xl text-center py-4">
          <%= @title %>
        </h1>
        <%= if @new_path do %>
          <%= live_patch to: @new_path, class: "button flex items-center" do%>
            <Svg.add class="h-8 mr-3" />
            <%= @new_label %>
          <% end %>
        <% end %>
      </div>

      <div data-test={"#{@resource_name}s-container"} class="md:col-span-2 grid lg:grid-cols-2 gap-8 content-start">
        <%= if length(@resource_list) > 0 do %>

        <%= for resource_item <- @resource_list do %>
          <.resource_item_card
            resource_name={@resource_name}
            resource_item={resource_item}
            resource_heading={@resource_heading}
            resource_summary={@resource_summary}
          >
              <.action_items
              resource_item={resource_item}
              show_link={@show_link}
              edit_link={@edit_link}
              delete={@delete}
            />
          </.resource_item_card>
        <% end %>

        <% else %>
          <.empty_placeholder resource_name={@resource_name} />
        <% end %>
      </div>

    </div>

    """
  end

  def resource_item_card(assigns) do
    ~H"""
    <div
      data-test={"#{@resource_name}-details"}
      id={"#{@resource_name}-#{@resource_item.id}"}
      class="flex flex-col border px-4 py-8 text-center bg-white rounded-md"
    >
      <h2 class=" font-bold text-lg py-3">
        <%= render_slot(@resource_heading, @resource_item) %>
      </h2>
      <p>
        <%= render_slot(@resource_summary, @resource_item) %>
      </p>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def action_items(assigns) do
    assigns =
      assigns
        |> assign_new(:edit_link, fn -> false end)
        |> assign_new(:delete, fn -> true end)

    ~H"""
    <div class="mt-auto flex justify-center space-x-3 pt-8">
      <%= live_redirect to: @show_link.(@resource_item) do %>
      <.action_button>
        <Svg.eye class="h-4" />
        <span>Show</span>
      </.action_button>
      <% end %>
      <%= if @edit_link do %>
        <%= live_patch to: @edit_link.(@resource_item) do %>
          <.action_button>
            <Svg.edit class="h-4" />
            <span>Edit</span>
          </.action_button>
        <% end %>
      <% end %>

      <%= if @delete do %>
        <%= link to: "#", phx_click: "delete", phx_value_id: @resource_item.id, data: [confirm: "Are you sure?"] do %>
          <.action_button>
            <Svg.trash class="h-4" />
            <span>Delete</span>
          </.action_button>
        <% end %>
      <% end %>
    </div>
    """
  end

  def action_button(assigns) do
    ~H"""
    <span class="flex items-center space-x-2 bg-gray-800 hover:bg-accent-500 text-white py-1 px-4 rounded-full">
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp empty_placeholder(assigns) do
    ~H"""
    <div data-test={"no-#{@resource_name}s-placeholder"} class="col-span-3 flex flex-col">
      <p class="text-center text-2xl font-thin border py-12 mt-24">
        You do not have any <%= @resource_name %>s yet.
      </p>
    </div>
    """
  end

end
