import Config

config :sapien_notifier,
  ecto_repos: [SapienNotifier.Repo],
  migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :sapien_notifier, SapienNotifierWeb.Endpoint,
  http: [port: System.get_env("PORT") || 9000],
  url: [host: System.get_env("HOST")],
  secret_key_base: "qmJil2X0yjWLCQ4n2uJwj+tpsOgioCtNWTSUlUYoS0DI72yp+JTLgClV+LI0QBSo",
  render_errors: [view: SapienNotifierWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SapienNotifier.PubSub, adapter: Phoenix.PubSub.PG2],
  watchers: [],
  debug_errors: true,
  check_origin: false
  # check_origin: ["//127.0.0.1", "//localhost", "//*.sapien.network", "//sapien-notifier.herokuapp.com"]

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

config :tzdata, :autoupdate, :disabled

config :absinthe, log: System.get_env("GRAPHQL_LOG") == "1"

# Configure migrations to use UUIDs
config :sapien_notifier, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

config :sapien_notifier, SapienNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "30"),
  show_sensitive_data_on_connection_error: true,
  priv: "priv/repo",
  ssl: false,
  log: :info,
  timeout: 120_000,
  ownership_timeout: 120_000,
  show_sensitive_data_on_connection_error: true

config :sapien_notifier, SapienNotifier.SapienRepo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("SAPIEN_DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("SAPIEN_POOL_SIZE") || "30"),
  show_sensitive_data_on_connection_error: true,
  migration_source: "notifier_migrations",
  priv: "priv/sapien_repo",
  ssl: false,
  log: :info,
  timeout: 120_000,
  ownership_timeout: 120_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
