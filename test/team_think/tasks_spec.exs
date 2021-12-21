defmodule TeamThink.TasksSpec do
  use TeamThink.DataCase, async: true

  alias TeamThink.Factory
  alias TeamThink.Tasks
  alias TeamThink.Tasks.Task

  describe "getting tasks" do
    setup do
      parent_task_list = Factory.insert(:task_list)
      task_list_tasks = Factory.insert_list(3, :task, task_list: parent_task_list)
      other_tasks = Factory.insert_list(5, :task)

      %{
        parent_task_list: parent_task_list,
        task_list_tasks: task_list_tasks,
        other_tasks: other_tasks
      }
    end

    test "should only return tasks for a specific task_list", context do
      parent_task_list = context[:parent_task_list]
      fetched_tasks = Tasks.get_tasks_by_task_list_id(parent_task_list.id)

      assert Enum.all?(fetched_tasks, fn task -> task.task_list_id == parent_task_list.id end)
    end

    test "should return a requested task by its id", context do
      random_task = context[:task_list_tasks] |> Enum.random() |> Map.delete(:task_list)
      fetched_task_list = Tasks.get_task!(random_task.id) |> Map.delete(:task_list)

      assert fetched_task_list == random_task
    end
  end

  describe "creating tasks" do
    test "should create a task when valid attributes provided" do
      valid_attrs = Factory.build(:task_params)

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.description == valid_attrs.description
      assert task.name == valid_attrs.name
    end

    test "should return an error changeset when invalid attributes provided for creation" do
      invalid_attrs = Factory.build(:invalid_task_params)
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(invalid_attrs)
    end
  end

  describe "updating tasks" do
    setup do
      %{
        update_attrs: Factory.build(:task_params),
        task: Factory.insert(:task)
      }
    end

    test "should update tasks when valid updates provided", context do
      %{update_attrs: update_attrs, task: original_task} = context

      {:ok, updated_task} = Tasks.update_task(original_task, update_attrs)

      assert updated_task.description == update_attrs.description
      assert updated_task.name == update_attrs.name
    end

    test "should allow partial updates", context do
      %{update_attrs: update_attrs, task: original_task} = context
      partial_update = update_attrs |> Map.drop([:description])

      {:ok, updated_task} = Tasks.update_task(original_task, partial_update)

      assert updated_task.description == original_task.description
      assert updated_task.name == update_attrs.name
    end

    test "should not update task when invalid data provided", context do
      %{task: original_task} = context
      invalid_attrs = Factory.build(:invalid_task_params)
      {result, return} = Tasks.update_task(original_task, invalid_attrs)
      comparable_original_task = original_task |> Map.delete(:task_list)
      comparable_fetched_task = Tasks.get_task!(original_task.id) |> Map.delete(:task_list)

      assert {:error, %Ecto.Changeset{}} = {result, return}
      assert comparable_original_task == comparable_fetched_task
    end
  end

  describe "deleting task lists" do
    setup do
      %{
        task: Factory.insert(:task)
      }
    end

    test "should delete a given task", %{task: task} do
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end
  end
end
