defmodule TeamThink.Tasks.Task.Query do
  @moduledoc """
  Specialized queries related to the Task schema
  """

  import Ecto.Query
  alias TeamThink.Tasks.Task

  def base(), do: Task

  def for_task_list(query, task_list_id) do
    query
    |> where([t], t.task_list_id == ^task_list_id)
  end
end
