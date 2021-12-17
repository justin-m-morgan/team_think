defmodule TeamThink.TaskLists do
  @moduledoc """
  The TaskLists context.
  """

  import Ecto.Query, warn: false
  alias TeamThink.Repo

  alias TeamThink.TaskLists.TaskList

  @doc """
  Returns the list of task_lists for a given project id.

  ## Examples

      iex> get_task_list_by_project(1)
      [%TaskList{}, ...]

  """
  def get_task_lists_by_project_id(project_id) do
    TaskList
    |> TaskList.Query.for_project(project_id)
    |> Repo.all()
  end

  @doc """
  Gets a single task_list.

  Raises `Ecto.NoResultsError` if the Task list does not exist.

  ## Examples

      iex> get_task_list!(123)
      %TaskList{}

      iex> get_task_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_list!(id), do: Repo.get!(TaskList, id)

  @doc """
  Creates a task_list.

  ## Examples

      iex> create_task_list(%{field: value})
      {:ok, %TaskList{}}

      iex> create_task_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_list(attrs \\ %{}) do
    %TaskList{}
    |> TaskList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task_list.

  ## Examples

      iex> update_task_list(task_list, %{field: new_value})
      {:ok, %TaskList{}}

      iex> update_task_list(task_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_list(%TaskList{} = task_list, attrs) do
    task_list
    |> TaskList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_list.

  ## Examples

      iex> delete_task_list(task_list)
      {:ok, %TaskList{}}

      iex> delete_task_list(task_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_list(%TaskList{} = task_list) do
    Repo.delete(task_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_list changes.

  ## Examples

      iex> change_task_list(task_list)
      %Ecto.Changeset{data: %TaskList{}}

  """
  def change_task_list(%TaskList{} = task_list, attrs \\ %{}) do
    TaskList.changeset(task_list, attrs)
  end
end
