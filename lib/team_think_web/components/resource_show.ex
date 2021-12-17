defmodule TeamThinkWeb.Components.ResourceShow do
  @moduledoc """
  Template for any resource "Show" view
  """

  use TeamThinkWeb, :component

  def show(assigns) do
    ~H"""
    <.live_component module={Ui.Breadcrumbs} id="breadcrumbs" resource={@resource} />

    <div class="card grid lg:grid-cols-3 items-center bg-gray-50 rounded-lg py-12 px-4 shadow-lg">
      <div data-test={@resource_name <> "-details"} class="flex flex-col items-center">
        <h2 class="font-bold text-3xl lg:text-5xl text-center">
          <%= render_slot(@heading) %>
        </h2>

        <p class="max-w-xl pt-2 pb-8">
          <%= render_slot(@description) %>
        </p>
        <%= live_patch to: @edit_path, aria_label: "Edit" do %>
          <Svg.edit class="h-6" />
        <% end %>
      </div>

      <div class="lg:col-span-2 grid lg:grid-cols-3 gap-12">
        <%= for %{illustration_name: illustration_name, to: to, label: label} <- @navigation_items do %>
          <.navigation_item
            illustration_name={illustration_name}
            label={label}
            to={to}/>
        <% end %>
      </div>
    </div>
    """
  end


  defp navigation_item(assigns) do
    ~H"""
    <%= live_redirect to: @to do %>
      <div class="flex flex-col items-center space-y-4">
        <Svg.Illustrations.illustration illustration_name={@illustration_name} class="h-32" />
        <span class="font-bold text-2xl"><%= @label %></span>
      </div>
    <% end %>
    """
  end
end
