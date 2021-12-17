defmodule TeamThink.TaskListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeamThink.TaskLists` context.
  """

  @doc """
  Generate a task_list.
  """
  def task_list_fixture(attrs \\ %{}) do
    {:ok, task_list} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> TeamThink.TaskLists.create_task_list()

    task_list
  end
end
