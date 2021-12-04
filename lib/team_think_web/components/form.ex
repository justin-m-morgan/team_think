defmodule TeamThinkWeb.Components.Form do
  use TeamThinkWeb, :component

  def form_card(assigns) do
    ~H"""
    <div class="flex flex-col items-center py-2 pt-12">
      <div class="max-w-4xl py-12 px-8 shadow-xl rounded-xl bg-white">
        <h1 class="text-3xl font-bold pb-4"><%= @title %></h1>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def form_container(assigns) do
    ~H"""
    <div class="flex flex-col space-y-1">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def form_field(assigns) do
    assigns = assign_new(assigns, :label, fn -> nil end)

    ~H"""
    <div class="flex flex-col">
      <%= label @f, @field, label: @label %>
      <%= render_slot(@inner_block, "py-3 px-4 border rounded-md shadow-sm min-w-[50ch]") %>
      <div class="h-8">
        <%= error_tag @f, @field %>
      </div>
    </div>
    """
  end

  def form_checkbox(assigns) do
    assigns = assign_new(assigns, :label, fn -> nil end)

    ~H"""
    <div class="flex flex-col">
      <div class="flex items-center space-x-3">
        <%= checkbox @f, @field, class: "mr-3" %>
        <%= label @f, @field, @label %>
      </div>
      <div class="h-8">
        <%= error_tag @f, @field %>
      </div>
    </div>
    """
  end

  def form_error_alert(assigns) do
    assigns =
      assign_new(assigns, :message, fn ->
        "Oops, something went wrong! Please check the errors below."
      end)

    ~H"""
    <div class="alert alert-danger">
      <p><%= @message %></p>
    </div>
    """
  end

  def submit_button(assigns) do
    ~H"""
    <div>
      <%= submit @label, class: "button" %>
    </div>
    """
  end

  def bottom_links(assigns) do
    ~H"""
    <div class="py-4 flex items-center space-x-4">
      <%= render_slot(@inner_block, "button") %>
    </div>
    """
  end
end
