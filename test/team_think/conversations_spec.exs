defmodule TeamThink.ConversationsTest do
  use TeamThink.DataCase

  alias TeamThink.Conversations
  alias TeamThink.Conversations.Conversation

  import TeamThink.Factory
  import TeamThink.TestingUtilities

  describe "conversations access" do



    test "should be able to list all conversations" do
      generated_number = 4
      insert_list(generated_number, :conversation)

      assert Conversations.list_conversations() |> length == generated_number
    end

    test "should be able to fetch a conversation by its id" do
      conversation = insert(:conversation) |> delete_keys([:project])
      fetched_conversation = Conversations.get_conversation!(conversation.id) |> delete_keys([:project])
      assert fetched_conversation == conversation
    end


  end

  describe "conversation creation" do
    test "should be able to create a conversation from a project" do
      project = insert(:project)
      {:ok, conversation} = Conversations.create_conversation(project)

      assert Repo.get!(Conversation, conversation.id)
    end
    test "should be able to create a conversation from a task_list" do
      task_list = insert(:task_list)
      {:ok, conversation} = Conversations.create_conversation(task_list)

      assert Repo.get!(Conversation, conversation.id)
    end
    test "should be able to create a conversation from a task" do
      task = insert(:task)
      {:ok, conversation} = Conversations.create_conversation(task)

      assert Repo.get!(Conversation, conversation.id)
    end

    test "should return an error changeset when non-struct provided" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_conversation(%{})
    end

  end
end
