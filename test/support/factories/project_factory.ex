defmodule TeamThink.Factory.ProjectFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Projects.Project

      def project_params_factory() do
        user = insert(:valid_user)

        %{
          name: Faker.Company.catch_phrase(),
          description: Faker.Lorem.sentence(),
          user_id: user.id
        }
      end

      def invalid_project_params_factory() do
        %{
          name: "",
          description: nil,
          user_id: Faker.random_between(1, 100)
        }
      end

      def project_factory() do
        %Project{
          name: Faker.Company.catch_phrase(),
          description: Faker.Lorem.sentence(),
          user: build(:valid_user)
        }
      end
    end
  end
end
