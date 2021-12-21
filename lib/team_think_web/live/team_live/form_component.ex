defmodule TeamThinkWeb.TeamLive.FormComponent do
  use TeamThinkWeb, :live_component

  alias TeamThink.Teams
  alias TeamThink.Teams.Team
  alias TeamThink.Accounts

  def update(%{team: team} = assigns, socket) do
    changeset = Teams.change_team_members(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:candidate, nil)
     |> assign(:team, team)
     |> assign(:changeset, changeset)}
  end

  def render(assigns) do
    ~H"""
    <div class="card py-4 px-4">
      <h1 class="text-3xl font-bold py-3">Search for a Team-mate</h1>
      <h2 class="font-bold">Your search must be an exact match for their email (case-insensitve)</h2>
      <Form.form_container>
      <.form
      let={f}
      for={@changeset}
      id="add-teammate-form"
      class="pt-8"
      phx-target={@myself}
      phx-change="validate"
      phx-submit="save"
      >
        <Form.form_field f={f} field={:email}>
          <%= text_input f, :email, class: "inputs", "phx-debounce": "500" %>
        </Form.form_field>


          <Form.submit_button
            label="Add to Your Team"
            class={disabled_submit_classes(@candidate, @changeset.valid?)}
            disabled={!@candidate or not @changeset.valid?}
            />


      </.form>
      </Form.form_container>
    </div>
    """
  end

  defp disabled_submit_classes(candidate, valid) when is_nil(candidate) or not valid,
    do: "opacity-25 hover:bg-gray-50 hover:text-gray-800"

  defp disabled_submit_classes(_candidate, _valid), do: ""

  def handle_event("validate", %{"team" => team_params}, socket) do
    candidate = Accounts.get_user_by_email(team_params["email"])
    current_team_mates = socket.assigns.team.team_mates

    changeset =
      socket.assigns.team
      |> Teams.change_team_members(candidate)
      |> maybe_put_already_memeber_error(current_team_mates, candidate)
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
      |> assign(:candidate, candidate)
      |> assign(:changeset, changeset)
    }
  end

  def handle_event("save", _, socket) do
    save_project(socket, :new, %{})
  end

  defp save_project(socket, :new, _form_params) do
    %{team: team, candidate: candidate} = socket.assigns

    case Teams.add_team_member(team, candidate) do
      {:ok, %Team{} = team} ->
        updated_team = TeamThink.Repo.preload(team, :team_mates)
        send(self(), {:updated_team, updated_team})

        {
          :noreply,
          socket
          |> assign(:team, updated_team)
          |> assign(:changeset, Teams.change_team_members(team))
          |> assign(:candidate, nil)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp maybe_put_already_memeber_error(changeset, team_mates, candidate) do
    case candidate in team_mates do
      true -> Ecto.Changeset.add_error(changeset, :email, "Already in Team")
      false -> changeset
    end
  end
end
