# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sapien_notification,
  ecto_repos: [SapienNotification.Repo]

# Configures the endpoint
config :sapien_notification, SapienNotificationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HrD+f46yUzXNnBN0NlLbzIv0vyg9vvI6LU8ihUOauQONpB+aHWCYzFrs4JTuuG2j",
  render_errors: [view: SapienNotificationWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SapienNotification.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
