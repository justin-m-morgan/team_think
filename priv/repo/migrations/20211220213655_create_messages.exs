defmodule TeamThink.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :conversation_id, references(:conversations, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:messages, [:conversation_id])
    create index(:messages, [:user_id])
  end
end
