defmodule TeamThink.Factory do
  @moduledoc """
  Factory functions for application data
  """
  use ExMachina.Ecto, repo: TeamThink.Repo

  use TeamThink.Factory.UserFactory
  use TeamThink.Factory.ProjectFactory
  use TeamThink.Factory.TaskFactory
  use TeamThink.Factory.TaskListFactory
end
