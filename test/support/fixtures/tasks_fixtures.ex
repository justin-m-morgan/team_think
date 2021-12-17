defmodule TeamThink.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeamThink.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: "some status",
        name: "some name"
      })
      |> TeamThink.Tasks.create_task()

    task
  end
end
