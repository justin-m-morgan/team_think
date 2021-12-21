defmodule TeamThinkWeb.ConversationLive.Show do
  use TeamThinkWeb, :live_view


  alias TeamThinkWeb.Components.ResourceShow
  alias TeamThinkWeb.MessageLive
  alias TeamThink.Conversations
  alias TeamThink.Messages
  alias TeamThink.Projects



  @impl true
  def mount(%{"project_id" => project_id}, _session, socket) do
    topic = "project:#{project_id}"

    TeamThinkWeb.Endpoint.subscribe(topic)

    {:ok, assign(socket, :topic, topic)}
  end

  @impl true
  def handle_info(%{event: "new_message"}, socket) do
    {
      :noreply,
      socket
        |> assign_conversation(socket.assigns.project.id)
    }
  end


  @impl true
  def handle_params(%{"project_id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Project Conversation")
     |> assign_conversation(project_id)
    }
  end


  defp assign_conversation(socket, project_id) do
    project = Projects.get_project!(project_id,
      preload: [conversation: [messages: [:user]]]
      )

    messages =
      project.conversation.messages
      |> Enum.sort(&sort_messages/2)
      |> Enum.take(5)
      |> Enum.reverse()

    socket
      |> assign(:project, project)
      |> assign(:conversation, project.conversation)
      |> assign(:messages, messages)
  end

  defp sort_messages(message1, message2) do
    case NaiveDateTime.compare(message1.inserted_at, message2.inserted_at) do
      :gt -> true
      _ -> false
    end

  end

  defp talk_bubble(assigns) do
    ~H"""
    <div class={me_classes(@message.user.email, @user.email) <> " py-3 px-3 rounded-lg"} >
    <div class="flex justify-between">
      <span class="font-bold"><%= display_name(@message.user.email, @user.email) %>: </span>
      <span><%= Timex.format!(@message.inserted_at, "{ANSIC}") %></span>
    </div>
      <%= @message.content %>
    </div>
    """
  end

  defp me_classes(sender, current_user) when sender == current_user, do: "ml-8 bg-green-700 text-gray-50"
  defp me_classes(_sender, _current_user), do: "mr-8 bg-green-200 text-gray-700"

  defp display_name(sender, current_user) when sender == current_user, do: "Me"
  defp display_name(sender, _current_user), do: sender

end
