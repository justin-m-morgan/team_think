defmodule TeamThink.ProjectsTest do
  @moduledoc false
  use TeamThink.DataCase

  alias TeamThink.Projects

  describe "projects" do
    alias TeamThink.Projects.Project

    alias TeamThink.Factory

    @invalid_attrs %{description: nil, name: nil}

    test "list_projects/0 returns all projects" do
      generated_number_of_projects = 10
      generated_projects = Factory.insert_list(generated_number_of_projects, :project)
      persisted_projects = Projects.list_projects()

      assert length(persisted_projects) == generated_number_of_projects
      assert all_a_ids_in_b?(generated_projects, persisted_projects)
    end



    test "get_projects_by_user/1 returns all projects of a given user" do
      _others_projects = Factory.insert_list(4, :project)
      user = Factory.insert(:valid_user)
      users_generated_projects = Factory.insert_list(2, :project, user: user)
      users_fetched_projects = Projects.get_projects_by_user(user)

      assert all_a_ids_in_b?(users_generated_projects, users_fetched_projects)
    end

    test "get_project!/1 returns the project with given id" do
      project = Factory.insert(:project)
      fetched_project = Projects.get_project!(project.id)

      assert fetched_project.name == project.name
      assert fetched_project.description == project.description
    end

    test "create_project/1 with valid data creates a project" do
      user = Factory.insert(:valid_user)
      valid_attrs = Factory.build(:project_params, %{user_id: user.id})

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.description == valid_attrs.description
      assert project.name == valid_attrs.name
    end

    test "create_project/1 with invalid data returns error changeset" do
      user = Factory.insert(:valid_user)
      attrs = Map.put(@invalid_attrs, :user_id, user.id)

      assert {:error, %Ecto.Changeset{}} = Projects.create_project(attrs)
    end

    test "update_project/2 with valid data updates the project" do
      original_project = Factory.insert(:project)
      update_attrs = Factory.build(:project_params)
      {:ok, %Project{} = updated_project} =
        Projects.update_project(original_project, update_attrs)

      refute original_project.description == update_attrs.description
      refute original_project.name == update_attrs.name
      assert updated_project.description == update_attrs.description
      assert updated_project.name == update_attrs.name
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = Factory.insert(:project)
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)

      refetched_project = Projects.get_project!(project.id)
      assert project.name == refetched_project.name
      assert project.description == refetched_project.description
    end

    test "delete_project/1 deletes the project" do
      project = Factory.insert(:project)
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = Factory.insert(:project)
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  defp all_a_ids_in_b?(set_a, set_b) do
    Enum.all?(set_a, fn item_a ->
      Enum.find(set_b, fn item_b -> item_a.id == item_b.id end)
    end)
  end

end
