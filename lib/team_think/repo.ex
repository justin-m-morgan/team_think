defmodule TeamThink.Repo do
  use Ecto.Repo,
    otp_app: :team_think,
    adapter: Ecto.Adapters.Postgres
end
