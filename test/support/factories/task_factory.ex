defmodule TeamThink.Factory.TaskFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Tasks.Task

      def task_create_params_factory() do
        %{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(5..10),

        }
      end

      def task_update_params_factory() do
        %{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(5..10)
        }
      end

      def task_params_factory() do
        task_list = insert(:task_list)
        %{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(5..10),
          status: Enum.random([:outstanding, :in_progress, :complete]),
          task_list_id: task_list.id
        }
      end

      def invalid_task_params_factory() do
        task_list = insert(:task_list)
        %{
          name: "",
          description: nil,
        }
      end

      def task_factory() do
        %Task{
          name: Faker.Lorem.sentence(2..5),
          description: Faker.Lorem.sentence(5..10),
          task_list: build(:task_list)
        }
      end

    end
  end
end
