defmodule TeamThink.TaskLists.TaskList do
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.Projects.Project
  alias TeamThink.Tasks.Task

  schema "task_lists" do
    field :description, :string
    field :name, :string
    belongs_to :project, Project
    has_many :tasks, Task

    timestamps()
  end

  @doc false
  def changeset(task_list, attrs) do
    task_list
    |> cast(attrs, [:name, :description, :project_id])
    |> validate_required([:name, :description, :project_id])
  end
end
