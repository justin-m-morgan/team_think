defmodule TeamThinkWeb.Components.Svg.Illustrations do
  use TeamThinkWeb, :component

  def illustration(assigns) do
    ~H"""
    <div class={@class}>
      <img src={"/images/illustrations/" <> @illustration_name <> ".svg"} class="h-full"/>
    </div>
    """
  end
end
