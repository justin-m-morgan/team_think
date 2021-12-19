defmodule TeamThink.Repo.Migrations.CreateTeamMates do
  use Ecto.Migration

  def change do
    create table(:team_mates) do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

    end

    create index(:team_mates, [:team_id])
    create index(:team_mates, [:user_id])
    create unique_index(:team_mates, [:team_id, :user_id])
  end
end
