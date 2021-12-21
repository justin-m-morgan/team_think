defmodule TeamThink.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.Projects.Project
  alias TeamThink.Accounts.User

  schema "teams" do
    belongs_to :project, Project

    many_to_many :team_mates, User, join_through: "team_mates", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:project_id])
    |> validate_required([:project_id])
    |> foreign_key_constraint(:project_id)
  end

  def add_teammate_changeset(team, %User{} = team_mate) do
    preloaded_team = TeamThink.Repo.preload(team, :team_mates)

    preloaded_team
    |> change()
    |> put_assoc(:team_mates, [team_mate | preloaded_team.team_mates])
  end

  def add_teammate_changeset(team, _team_mate) do
    team
    |> change()
    |> add_error(:email, "Email not found")
  end

  def remove_teammate_changeset(team, %User{} = to_remove) do
    preloaded_team = TeamThink.Repo.preload(team, :team_mates)

    filtered_team_list =
      Enum.filter(
        preloaded_team.team_mates,
        fn team_mate -> team_mate.id != to_remove.id end
      )

    team
    |> change()
    |> put_assoc(:team_mates, filtered_team_list)
  end
end
