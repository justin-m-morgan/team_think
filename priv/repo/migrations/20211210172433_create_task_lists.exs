defmodule TeamThink.Repo.Migrations.CreateTaskLists do
  use Ecto.Migration

  def change do
    create table(:task_lists) do
      add :name, :string
      add :description, :string
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:task_lists, [:project_id])
  end
end
