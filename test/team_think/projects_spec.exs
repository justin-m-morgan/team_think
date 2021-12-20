defmodule TeamThink.ProjectSpec do
  use TeamThink.DataCase, async: true

  alias TeamThink.Factory
  alias TeamThink.Projects

  import TeamThink.TestingUtilities, only: [delete_keys: 2]

  describe "getting projects" do
    setup do
      user = Factory.insert(:valid_user)
      users_projects = Factory.insert_list(3, :project, user: user)
      others_projects = Factory.insert_list(5, :project)

      %{
        user: user,
        users_projects: users_projects,
        others_projects: others_projects
      }
    end

    test "should only return projects for a specific user", context do
      user = context[:user]
      fetched_projects = Projects.get_projects_by_user(user)

      assert Enum.all?(fetched_projects, fn project -> project.user_id == user.id end)
    end

    test "should return a requested project by its id", context do
      random_project = context[:users_projects] |> Enum.random() |> delete_keys([:user, :team])
      fetched_project = Projects.get_project!(random_project.id) |> delete_keys([:user, :team])

      assert fetched_project == random_project
    end
  end

  describe "creating projects" do
    test "should create a project when valid attributes provided" do
      valid_attrs = Factory.build(:project_params)

      assert {:ok, %Projects.Project{} = project} = Projects.create_project(valid_attrs)
      assert project.description == valid_attrs.description
      assert project.name == valid_attrs.name
    end

    test "should return an error changeset when invalid attributes provided for creation" do
      invalid_attrs = Factory.build(:invalid_project_params)
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(invalid_attrs)
    end
  end


  describe "updating projects" do
    setup do
      %{
        update_attrs: Factory.build(:project_params),
        project: Factory.insert(:project)
      }
    end

    test "should update project when valid updates provided", context do
      %{update_attrs: update_attrs, project: original_project} = context

      {:ok, updated_project} = Projects.update_project(original_project, update_attrs)

      assert updated_project.description == update_attrs.description
      assert updated_project.name == update_attrs.name

    end

    test "should allow partial updates", context do
      %{update_attrs: update_attrs, project: original_project} = context
      partial_update = update_attrs |> Map.drop([:description])

      {:ok, updated_project} = Projects.update_project(original_project, partial_update)

      assert updated_project.description == original_project.description
      assert updated_project.name == update_attrs.name
    end

    test "should not update task list when invalid data provided", context do
      %{project: original_project} = context
      invalid_attrs = Factory.build(:invalid_project_params)
      {result, return} = Projects.update_project(original_project, invalid_attrs)
      comparable_original_list = delete_keys(original_project, [:user, :team])
      comparable_fetched_list = Projects.get_project!(original_project.id) |> delete_keys([:user, :team])

      assert {:error, %Ecto.Changeset{}} = {result, return}
      assert comparable_original_list == comparable_fetched_list
    end
  end

  describe "deleting projects" do
    setup do
      %{
        project: Factory.insert(:project)
      }
    end

    test "should delete a given project", %{project: project} do
      assert {:ok, %Projects.Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end
  end
end
