defmodule TeamThinkWeb.Components.Ui.Table do
  @moduledoc """
  Standardized Table Component

  ## Example

  ```
  <Ui.Table rows={@resource_list}>
    <:col let={resource_name} label="Field 1">
      <%= resource_name.field1 %>
    </:col>
    <:col let={resource_name} label="Field 2">
      <%= resource_name.field2 %>
    </:col>
  </Ui.Table>
  ```
  """

  use TeamThinkWeb, :component

  def table(assigns) do
    ~H"""
    <div class="flex flex-col">
    <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
      <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
        <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <%= for col <- @col do %>
                  <.header_cell alignment={col[:alignment]}><%= col.label %></.header_cell>
                <% end %>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <%= for row <- @rows do %>
                <tr>
                  <%= for col <- @col do %>
                    <.body_cell>
                      <%= render_slot(col, row) %>
                    </.body_cell>
                  <% end %>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    </div>

    """
  end

  defp header_cell(assigns) do
    assigns = assign_new(assigns, :alignment, fn -> :left end)

    ~H"""
    <th
      scope="col"
      class={"px-6 py-3 #{alignment(@alignment)} text-xs font-medium text-gray-500 uppercase tracking-wider"}
    >
      <%= render_block(@inner_block) %>
    </th>
    """
  end

  defp body_cell(assigns) do
    ~H"""
    <td class="px-6 py-4 whitespace-nowrap">
      <%= render_block(@inner_block) %>
    </td>
    """
  end

  defp alignment(:left), do: "text-left"
  defp alignment(:right), do: "text-right"
  defp alignment(:center), do: "text-center"
  defp alignment(_), do: "text-left"
end
