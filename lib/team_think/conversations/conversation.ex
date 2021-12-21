defmodule TeamThink.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.Repo
  alias TeamThink.Projects.Project
  alias TeamThink.TaskLists.TaskList
  alias TeamThink.Tasks.Task
  alias TeamThink.Teams.Team
  alias TeamThink.Messages.Message

  schema "conversations" do
    belongs_to :project, Project
    belongs_to :task_list, TaskList
    belongs_to :task, Task
    belongs_to :team, Team

    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(conversation, %Project{} = project) do
    conversation
    |> Repo.preload(:project)
    |> change()
    |> put_assoc(:project, project)
  end

  def changeset(conversation, %TaskList{} = task_list) do
    conversation
    |> Repo.preload(:project)
    |> change()
    |> put_assoc(:task_list, task_list)
  end

  def changeset(conversation, %Task{} = task) do
    conversation
    |> Repo.preload(:project)
    |> change()
    |> put_assoc(:task, task)
  end

  def changeset(conversation, _) do
    error_message = "Must provide a resource to associate the conversation with"

    conversation
    |> change()
    |> add_error(:team, error_message)
    |> add_error(:task_list, error_message)
    |> add_error(:task, error_message)
    |> add_error(:project, error_message)

  end
end
