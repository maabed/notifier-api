# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sapien_notifier,
  ecto_repos: [SapienNotifier.Repo]

# Configures the endpoint
config :sapien_notifier, SapienNotifierWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qmJil2X0yjWLCQ4n2uJwj+tpsOgioCtNWTSUlUYoS0DI72yp+JTLgClV+LI0QBSo",
  render_errors: [view: SapienNotifierWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SapienNotifier.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :sapien_notifier, SapienNotifierWeb.Guardian,
  issuer: "sapien",
  allowed_algos: ["ES256"],
  secret_key: "hvUNfqlSpsPsg1S8XElJMmXmYhCkelxox26OteggVzfEGk5LXdiv7QR9RPTyFSES"

  # Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure migrations to use UUIDs
config :sapien_notifier, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
