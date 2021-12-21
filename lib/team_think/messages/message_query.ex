defmodule TeamThink.Messages.Message.Query do
  @moduledoc """
  Specialized queries related to the Message schema
  """

  import Ecto.Query
  alias TeamThink.Messages.Message

  def base(), do: Message

  def limit_and_sort(limit \\ 5) do
    from m in Message, order_by: m.inserted_at, limit: ^limit
  end

end
