defmodule TeamThink.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.Conversations.Conversation
  alias TeamThink.Accounts.User

  schema "messages" do
    field :content, :string

    belongs_to :conversation, Conversation
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :conversation_id, :user_id])
    |> validate_required([:content])
  end
end
