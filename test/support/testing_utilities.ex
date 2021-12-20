defmodule TeamThink.TestingUtilities do

  alias TeamThink.Factory

  @doc """
  Delete keys for comparison purposes
  """
  def delete_keys(struct, keys) do
    Enum.reduce(keys, struct, fn key, struct -> Map.delete(struct, key) end)
  end

  @doc """
  Create a properly structured project with a user
  assigned to the generated team
  """
  def create_project(%{user: user}) do
    %{
      project: Factory.insert(:project,
        user: user,
        team: Factory.build(:team, team_mates: [user])
      )
    }
  end
  def create_many_projects(%{user: user}) do
    %{
      projects:
        Factory.insert_list(3, :project,
          user: user,
          team: Factory.build(:team, team_mates: [user])
        )
    }
  end

end
