defmodule TeamThink.Projects.Project do
  @moduledoc """
  Project schema is the parent resource which users model their projects
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias TeamThink.Accounts.User

  schema "projects" do
    field :description, :string
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
  end
end
