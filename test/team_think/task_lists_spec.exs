defmodule TeamThink.TaskListsSpec do
  use TeamThink.DataCase, async: true

  alias TeamThink.Factory
  alias TeamThink.TaskLists
  alias TeamThink.TaskLists.TaskList

  describe "getting task lists" do
    setup do
      parent_project = Factory.insert(:project)
      project_task_lists = Factory.insert_list(3, :task_list, project: parent_project)
      other_task_lists = Factory.insert_list(5, :task_list)

      %{
        parent_project: parent_project,
        project_task_lists: project_task_lists,
        other_task_lists: other_task_lists
      }
    end

    test "should only return task_lists for a specific project", context do
      parent_project = context[:parent_project]
      fetched_task_lists = TaskLists.get_task_lists_by_project_id(parent_project.id)

      assert Enum.all?(fetched_task_lists, fn tl -> tl.project_id == parent_project.id end)
    end

    test "should return a requested task_list by its id", context do
      random_task_list = context[:project_task_lists] |> Enum.random() |> Map.delete(:project)
      fetched_task_list = TaskLists.get_task_list!(random_task_list.id) |> Map.delete(:project)

      assert fetched_task_list == random_task_list
    end
  end

  describe "creating task lists" do
    test "should create a task_list when valid attributes provided" do
      valid_attrs = Factory.build(:task_list_params)

      assert {:ok, %TaskList{} = task_list} = TaskLists.create_task_list(valid_attrs)
      assert task_list.description == valid_attrs.description
      assert task_list.name == valid_attrs.name
    end

    test "should return an error changeset when invalid attributes provided for creation" do
      invalid_attrs = Factory.build(:invalid_task_list_params)
      assert {:error, %Ecto.Changeset{}} = TaskLists.create_task_list(invalid_attrs)
    end
  end


  describe "updating task lists" do
    setup do
      %{
        update_attrs: Factory.build(:task_list_params),
        task_list: Factory.insert(:task_list)
      }
    end

    test "should update tasks when valid updates provided", context do
      %{update_attrs: update_attrs, task_list: original_task_list} = context

      {:ok, updated_task_list} = TaskLists.update_task_list(original_task_list, update_attrs)

      assert updated_task_list.description == update_attrs.description
      assert updated_task_list.name == update_attrs.name

    end

    test "should allow partial updates", context do
      %{update_attrs: update_attrs, task_list: original_task_list} = context
      partial_update = update_attrs |> Map.drop([:description])

      {:ok, updated_task_list} = TaskLists.update_task_list(original_task_list, partial_update)

      assert updated_task_list.description == original_task_list.description
      assert updated_task_list.name == update_attrs.name
    end

    test "should not update task list when invalid data provided", context do
      %{task_list: original_task_list} = context
      invalid_attrs = Factory.build(:invalid_task_list_params)
      {result, return} = TaskLists.update_task_list(original_task_list, invalid_attrs)
      comparable_original_list = original_task_list |> Map.delete(:project)
      comparable_fetched_list = TaskLists.get_task_list!(original_task_list.id) |> Map.delete(:project)

      assert {:error, %Ecto.Changeset{}} = {result, return}
      assert comparable_original_list == comparable_fetched_list
    end
  end

  describe "deleting task lists" do
    setup do
      %{
        task_list: Factory.insert(:task_list)
      }
    end

    test "should delete a given task_list", %{task_list: task_list} do
      assert {:ok, %TaskList{}} = TaskLists.delete_task_list(task_list)
      assert_raise Ecto.NoResultsError, fn -> TaskLists.get_task_list!(task_list.id) end
    end
  end
end
