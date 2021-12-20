defmodule TeamThink.TeamsTest do
  use TeamThink.DataCase, async: true

  alias TeamThink.Teams

  import TeamThink.TestingUtilities, only: [delete_keys: 2]

  describe "teams" do
    alias TeamThink.Teams.Team

    import TeamThink.Factory


    test "should be able to fetch a given team by its id" do
      created_team = insert(:team) |> delete_keys([:project, :team_mates])
      fetched_team = Teams.get_team!(created_team.id) |> delete_keys([:project, :team_mates])
      assert  created_team == fetched_team
    end

    test "should be able to fetch a given team by its project_id" do
      project = insert(:project)
      created_team = project.team |> delete_keys([:project, :team_mates])
      fetched_team = Teams.get_team_by_project_id!(project.id) |> delete_keys([:project, :team_mates])

      assert  created_team == fetched_team
    end

    test "should be able to create a team by providing valid data" do
      project = insert(:project)
      valid_attrs = %{project_id: project.id}

      assert {:ok, %Team{} = _team} = Teams.create_team(valid_attrs)
    end

    test "should not be able to create a team when invalid data is provided" do
      invalid_attrs = %{project_id: Faker.random_between(4, 100)}

      assert {:error, %Ecto.Changeset{}} = Teams.create_team(invalid_attrs)
    end

    test "should be able to add a team_mate to a team" do
      test_team_mate = insert(:valid_user)
      test_team = insert(:team) |> TeamThink.Repo.preload(:team_mates)

      assert {:ok, team} = Teams.add_team_member(test_team, test_team_mate)
      assert test_team_mate in team.team_mates
    end

    test "should be able to fetch all of a team's members" do
      team_mates = insert_list(4, :valid_user)
      team = insert(:team, team_mates: team_mates)
      fetched_teams_teammates = Teams.get_teammates(team)

      assert Enum.all?(team_mates, &(&1 in fetched_teams_teammates) )
    end
  end

end
