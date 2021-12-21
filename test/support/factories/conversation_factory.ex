defmodule TeamThink.Factory.ConversationFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Conversations.Conversation

      def conversation_factory() do
        %Conversation{
          project: build(:project)
        }
      end
    end
  end
end
