defmodule TeamThink.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:teams, [:project_id])
  end
end
