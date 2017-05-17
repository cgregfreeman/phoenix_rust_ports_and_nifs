# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_rust_ports_and_nifs,
  ecto_repos: [PhoenixRustPortsAndNifs.Repo]

# Configures the endpoint
config :phoenix_rust_ports_and_nifs, PhoenixRustPortsAndNifs.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/3q027CuseD3GFlHGETU8FkGgTdA5a3Zl2XXIdpqcjhWlsEZPj4Dpl/NuO2GJSd/",
  render_errors: [view: PhoenixRustPortsAndNifs.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixRustPortsAndNifs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
