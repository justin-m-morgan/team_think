defmodule TeamThink.Factory.TeamFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Teams.Team

      def team_factory() do
        %Team{
          project: build(:project)
        }
      end
    end
  end
end
