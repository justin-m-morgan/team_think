defmodule TeamThink.Factory.TaskListFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.TaskLists.TaskList

      def task_list_params_factory() do
        project = insert(:project)

        %{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(10..20),
          project_id: project.id
        }
      end

      def task_list_factory() do
        %TaskList{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(10..20),
          project: build(:project),
          tasks: build_list(3, :task)
        }
      end

      def invalid_task_list_params_factory() do
        %{
          name: "",
          description: nil,
          project_id: Faker.random_between(1, 100)
        }
      end
    end
  end
end
