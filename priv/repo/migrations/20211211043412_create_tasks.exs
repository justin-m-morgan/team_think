defmodule TeamThink.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :string
      add :status, :string
      add :task_list_id, references(:task_lists, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:task_list_id])
  end
end
