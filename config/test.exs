import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :team_think, TeamThink.Repo,
  username: "postgres",
  password: "postgres",
  database: "team_think_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :team_think, TeamThinkWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FV/fz0CMTFT1uelx3qmnT/7MNNt4BFnpGwLa0544iUGGMsb6Lu2mh4+pw1n2eqpo",
  server: false

# In test we don't send emails.
config :team_think, TeamThink.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Setup Floki alternative HTML parser (Rust NIF)
config :floki, :html_parser, Floki.HTMLParser.Html5ever

# Setup instructions per Wallaby docs

config :wallaby,
  driver: Wallaby.Chrome,
  otp_app: :team_think

config :team_think, TeamThinkWeb.Endpoint, server: true

config :team_think, :sandbox, Ecto.Adapters.SQL.Sandbox
