defmodule TeamThink.Conversations do
  @moduledoc """
  The Conversations context.
  """

  import Ecto.Query, warn: false
  alias TeamThink.Repo

  alias TeamThink.Conversations.Conversation
  alias TeamThink.Messages.Message
  alias TeamThink.Accounts.User

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  def list_conversations do
    Repo.all(Conversation)
  end

  @doc """
  Gets a single conversation.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation!(123)
      %Conversation{}

      iex> get_conversation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation!(id), do: Repo.get!(Conversation, id)

  @doc """
  Gets a single conversation by project_id.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation_by_project_id!(123)
      %Conversation{}

      iex> get_conversation_by_project_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation_by_project_id!(project_id, opts \\ [])

  def get_conversation_by_project_id!(project_id, opts) when is_binary(project_id) do
    project_id
    |> String.to_integer()
    |> get_conversation_by_project_id!(opts)
  end

  def get_conversation_by_project_id!(project_id, opts) do
    preloads = opts[:preload] || []

    Conversation
    |> where([c], c.project_id == ^project_id)
    |> preload(^preloads)
    |> Repo.one!()
  end

  @doc """
  Gets a single conversation by task_list's id.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation_by_list_id!(123)
      %Conversation{}

      iex> get_conversation_by_list_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation_by_list_id!(list_id, opts \\ [])

  def get_conversation_by_list_id!(list_id, opts) when is_binary(list_id) do
    list_id
    |> String.to_integer()
    |> get_conversation_by_list_id!(opts)
  end

  def get_conversation_by_list_id!(list_id, opts) do
    preloads = opts[:preload] || []

    Conversation
    |> where([c], c.task_list_id == ^list_id)
    |> preload(^preloads)
    |> Repo.one!()
  end

  @doc """
  Gets a single conversation by task_id.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation_by_task_id!(123)
      %Conversation{}

      iex> get_conversation_by_task_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation_by_task_id!(task_id, opts \\ [])

  def get_conversation_by_task_id!(task_id, opts) when is_binary(task_id) do
    task_id
    |> String.to_integer()
    |> get_conversation_by_task_id!(opts)
  end

  def get_conversation_by_task_id!(task_id, opts) do
    preloads = opts[:preload] || []

    Conversation
    |> where([c], c.task_id == ^task_id)
    |> preload(^preloads)
    |> Repo.one!()
  end

  @doc """
  Creates a conversation associated with a resource.

  Currently supported resources:

  - Project
  - TaskList
  - Task

  ## Examples

      iex> create_conversation(%Project{})
      {:ok, %Conversation{}}

      iex> create_conversation(%TaskList{})
      {:ok, %Conversation{}}

      iex> create_conversation(%Task{})
      {:ok, %Conversation{}}

      iex> create_conversation(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation(resource) do
    %Conversation{}
    |> Conversation.changeset(resource)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation.

  ## Examples

      iex> update_conversation(conversation, %{field: new_value})
      {:ok, %Conversation{}}

      iex> update_conversation(conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a conversation.

  ## Examples

      iex> delete_conversation(conversation)
      {:ok, %Conversation{}}

      iex> delete_conversation(conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation changes.

  ## Examples

      iex> change_conversation(conversation)
      %Ecto.Changeset{data: %Conversation{}}

  """
  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end
end
