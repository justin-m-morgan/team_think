defmodule TeamThink.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TeamThink.Repo

  alias TeamThink.Accounts.User
  alias TeamThink.Teams.Team

  @doc """
  Gets a single team.

  Available Options:
  :preloads - A list of associated resources to preload

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, opts \\ []) do
    preloads = opts[:preload] || []

    Team
    |> preload(^preloads)
    |> Repo.get!(id)
  end

  @doc """
  Gets a team by a given project_id.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team_by_project_id!(123)
      %Team{}

      iex> get_team_by_project_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_by_project_id!(project_id, opts \\ []) do
    preloads = opts[:preload] || :team_mates

    Team
    |> where([t], t.project_id == ^project_id)
    |> preload(^preloads)
    |> Repo.one!()
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Adds a team_mate (a User) to a team.

  ## Examples

      iex> add_team_member(%Team{}, %User{})
      {:ok, %Team{}}

      iex> create_team(%Team{}, %{})
      {:error, %Ecto.Changeset{}}

  """
  def add_team_member(team, team_mate) do
    team
    |> Team.add_teammate_changeset(team_mate)
    |> Repo.update()
  end

  @doc """
  Removes a team_mate (a User) from a team.

  ## Examples

      iex> remove_team_member(%Team{}, %User{})
      {:ok, %Team{}}

      iex> create_team(%Team{}, %{})
      {:error, %Ecto.Changeset{}}
  """
  def remove_team_member(team, team_mate) do
    team
    |> Team.remove_teammate_changeset(team_mate)
    |> Repo.update()
  end

  @doc """
  Get a list of team_mates on a given team

  ## Examples

      iex> get_teammates(team)
      [%Team{}, ...]

  """

  def get_teammates(team) do
    team
    |> Repo.preload(:team_mates)
    |> Map.get(:team_mates)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for adding team members.

  ## Examples

      iex> change_team_members(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team_members(%Team{} = team, team_mate \\ nil) do
    Team.add_teammate_changeset(team, team_mate)
  end
end
