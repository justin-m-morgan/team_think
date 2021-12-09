defmodule TeamThink.Factory.ProjectFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Projects.Project

      def project_params_factory() do
        %{
          name: Faker.Company.catch_phrase(),
          description: Faker.Lorem.sentence(),
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
