defmodule TeamThink.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :task_list_id, references(:task_lists, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:conversations, [:project_id])
    create index(:conversations, [:task_list_id])
    create index(:conversations, [:task_id])
    create index(:conversations, [:team_id])
  end
end
