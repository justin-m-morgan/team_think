defmodule TeamThink.ConversationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeamThink.Conversations` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{

      })
      |> TeamThink.Conversations.create_conversation()

    conversation
  end
end
