defmodule TeamThink.TaskLists.TaskList.Query do
  @moduledoc """
  Specialized queries related to the TaskList schema
  """

  import Ecto.Query
  alias TeamThink.TaskLists.TaskList

  def base(), do: TaskList

  def for_project(query, project_id) do
    query
    |> where([tl], tl.project_id == ^project_id)
  end

end
