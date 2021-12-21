defmodule TeamThinkWeb.ConversationLive.Show do
  use TeamThinkWeb, :live_view

  alias TeamThinkWeb.Components.ResourceShow
  alias TeamThinkWeb.MessageLive
  alias TeamThink.Conversations

  @impl true
  def mount(params, _session, socket) do
    topic =
      case params do
        %{"task_id" => task_id} -> "task:#{task_id}"
        %{"list_id" => list_id} -> "list:#{list_id}"
        %{"project_id" => project_id} -> "project:#{project_id}"
      end

    assign_topic(socket, topic)
  end

  defp assign_topic(socket, topic) do
    TeamThinkWeb.Endpoint.subscribe(topic)

    {:ok, assign(socket, :topic, topic)}
  end

  @impl true
  def handle_info(%{event: "new_message"} = msg, socket) do
    key =
      case msg.topic do
        "task:" <> _ -> :task
        "list:" <> _ -> :list
        "project:" <> _ -> :project
      end

    {
      :noreply,
      assign_conversation(socket, key, socket.assigns.resource.id)
    }
  end

  @impl true
  def handle_params(params, _, socket) do
    {page_title, resource_key, resource_id} =
      case params do
        %{"task_id" => task_id} -> {"Task Conversation", :task, task_id}
        %{"list_id" => list_id} -> {"Task List Conversation", :list, list_id}
        %{"project_id" => project_id} -> {"Project Conversation", :project, project_id}
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title)
     |> assign_conversation(resource_key, resource_id)}
  end

  defp assign_conversation(socket, :task, task_id) do
    conversation =
      Conversations.get_conversation_by_task_id!(
        task_id,
        preload: [:task, messages: [:user]]
      )

    opts = [
      resource: conversation.task,
      resource_name: "task",
      pretty_resource_name: "task"
    ]

    assign_conversation(socket, conversation, opts)
  end

  defp assign_conversation(socket, :list, list_id) do
    conversation =
      Conversations.get_conversation_by_list_id!(
        list_id,
        preload: [:task_list, messages: [:user]]
      )

    opts = [
      resource: conversation.task_list,
      resource_name: "list",
      pretty_resource_name: "list"
    ]

    assign_conversation(socket, conversation, opts)
  end

  defp assign_conversation(socket, :project, project_id) do
    conversation =
      Conversations.get_conversation_by_project_id!(
        project_id,
        preload: [:project, messages: [:user]]
      )

    opts = [
      resource: conversation.project,
      resource_name: "project",
      pretty_resource_name: "project"
    ]

    assign_conversation(socket, conversation, opts)
  end

  defp assign_conversation(socket, %Conversations.Conversation{} = conversation, opts) do
    messages =
      conversation.messages
      |> Enum.sort(&sort_messages/2)
      |> Enum.take(5)
      |> Enum.reverse()

    socket
    |> assign(:resource, opts[:resource])
    |> assign(:resource_name, opts[:resource_name])
    |> assign(:pretty_resource_name, opts[:pretty_resource_name])
    |> assign(:conversation, conversation)
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

  defp me_classes(sender, current_user) when sender == current_user,
    do: "ml-8 bg-green-700 text-gray-50"

  defp me_classes(_sender, _current_user), do: "mr-8 bg-green-200 text-gray-700"

  defp display_name(sender, current_user) when sender == current_user, do: "Me"
  defp display_name(sender, _current_user), do: sender
end
