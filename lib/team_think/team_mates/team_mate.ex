defmodule TeamThink.TeamMates.TeamMate do
  @moduledoc """
  Not currently in use as Ecto allows for a convention based approach
  to many-to-many relationships so long as the only attributes are
  the foreign keys of the two schemas being joined.

  Should more attribtues be added in the future, then this schema
  will need to take over responsibility. I intend on implementing
  roles, and this will likely be the place to manage that.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "team_mates" do
    field :team_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(team_mate, attrs) do
    team_mate
    |> cast(attrs, [])
  end
end
