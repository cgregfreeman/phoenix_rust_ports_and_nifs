use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_rust_ports_and_nifs, PhoenixRustPortsAndNifs.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_rust_ports_and_nifs, PhoenixRustPortsAndNifs.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_rust_ports_and_nifs_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
