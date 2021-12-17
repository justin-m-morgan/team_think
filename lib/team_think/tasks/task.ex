defmodule TeamThink.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.TaskLists.TaskList

  schema "tasks" do
    field :description, :string
    field :name, :string
    field :status, Ecto.Enum, values: [:outstanding, :in_progress, :complete], default: :outstanding
    belongs_to :task_list, TaskList

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :task_list_id])
    |> validate_required([:name, :description, :status, :task_list_id])
  end
end
