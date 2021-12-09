defmodule TeamThink.Projects.Project.Query do
  @moduledoc """
  Specialized queries related to the Project schema
  """

  import Ecto.Query
  alias TeamThink.Projects.Project

  def base(), do: Project

  def for_user(query, user) do
    query
    |> where([p], p.user_id == ^user.id)
  end

end
