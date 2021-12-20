defmodule TeamThink.Factory.TeamFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Teams.Team

      def team_factory() do
        %Team{
          team_mates: build_list(3, :valid_user)
        }
      end
    end
  end
end
