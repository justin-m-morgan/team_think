defmodule TeamThink.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :project_id, :id
    field :task_list_id, :id
    field :task_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [])
    |> validate_required([])
  end
end
