use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :earlierthoughts, EarlierThoughts.Repo,
  username: "dsyang",
  password: "dsyang",
  database: "earlierthoughts_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :earlierthoughts, EarlierThoughtsWeb.Endpoint,
  http: [port: 4002],
  server: false

# enablue this to test the startercode
config :earlierthoughts, EarlierThoughtsWeb.StarterCode.PageLive, enable_startercode_search: true

# Print only warnings and errors during test
config :logger, level: :warn

config :goth,
  disabled: true

config :earlierthoughts, EarlierThoughts.Lists.ListProcess, push_delay_seconds: 1
