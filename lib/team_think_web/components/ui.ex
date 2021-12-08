defmodule TeamThinkWeb.Components.Ui do
  @moduledoc """
  A standard set of UI components that will be regularly reused throughout the project
  """

  use TeamThinkWeb, :component

  def button(assigns) do
    ~H"""
    <button class="
            text-2xl text-white font-bold
            rounded-lg bg-accent-500 border-accent-600 shadow-md
            py-6 px-24  mt-24
            hover:bg-accent-600 transition-colors duration-150
        ">
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def card(assigns) do
    assigns =
      assigns
        |> assign_new(:heading, fn -> [] end)
        |> assign_new(:icon, fn -> [] end)
        |> assign_new(:simple_text, fn -> [] end)

    ~H"""
    <div class="bg-gray-50 py-8 px-6 shadow-lg flex flex-col items-center">
      <div class="pb-12">
        <%= render_slot(@icon) %>
      </div>
      <h3 class="font-bold text-3xl text-center pb-4"><%= render_slot(@heading) %></h3>
      <p class="text-xl text-thin text-center leading-relaxed"><%= render_slot(@simple_text) %></p>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
