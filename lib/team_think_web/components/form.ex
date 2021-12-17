defmodule TeamThinkWeb.Components.Form do
  @moduledoc """
  Component functions for normalized forms
  """

  use TeamThinkWeb, :component

  def form_card(assigns) do
    ~H"""
    <div class="mx-auto w-full max-w-3xl py-12 px-8 shadow-xl rounded-xl bg-white">
      <h1 class="text-3xl font-bold pb-4"><%= @title %></h1>

      <%= render_slot(@inner_block) %>
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
      <%= if @label do %>
        <%= label @f, @field, @label %>
      <% else %>
        <%= label @f, @field %>
      <% end %>
      <%= render_slot(@inner_block) %>
      <div class="h-8">
        <%= error_tag @f, @field %>
      </div>
    </div>
    """
  end

  def text_area(assigns) do
    ~H"""
    <div class="flex flex-col">
      <%= label @f, @field, @label %>
      <%= text_input @f, @field, class: "inputs" %>
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
    <div class="flex">
      <%= submit @label, class: "button w-full py-4", phx_disable_with: "Saving..." %>
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
