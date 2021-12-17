defmodule TeamThinkWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `TeamThinkWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal TeamThinkWeb.ProjectLive.FormComponent,
        id: @project.id || :new,
        action: @live_action,
        project: @project,
        return_to: Routes.project_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(TeamThinkWeb.ModalComponent, modal_opts)
  end


  @doc """
  Allows for a list of CSS-classes to be provided in tuple form or binary.

  Tuples are of the form {css-class, boolean}.

  ## Examples

      iex> class_list(["big", {"small", false}, {"maybe", Integer.mod(10, 2) == 0}])
      "big maybe"

  """
  def class_list(items) do
    items
    |> Enum.map(&process_classes/1)
    |> Enum.reject(&(&1 == false))
    |> Enum.join(" ")
  end

  defp process_classes(item) when is_binary(item), do: item
  defp process_classes({_class, false}), do: false
  defp process_classes({class, _}), do: class
  defp process_classes(_), do: false
end
