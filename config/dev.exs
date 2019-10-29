use Mix.Config

# # Configures the endpoint For development, we disable any cache and enable
# debugging and code reloading.
config :sapien_notifier, SapienNotifierWeb.Endpoint,
  http: [port: 9000],
  debug_errors: true,
  code_reloader: true,
  check_origin: ["//127.0.0.1", "//localhost", "//*.sapien.network", "//sapien-notifier.herokuapp.com"],
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :absinthe,
  log: System.get_env("GRAPHQL_LOG") == "1"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :sapien_notifier, SapienNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sapien_notifier_dev",
  hostname: System.get_env("PG_HOST") || "localhost",
  pool_size: 40,
  log_level: :info,
  show_sensitive_data_on_connection_error: true

# sapien database
config :sapien_notifier, SapienNotifier.SapienRepo,
  username: "sapien",
  password: "sapien",
  database: "sapien",
  hostname: "localhost",
  pool_size: 5,
  timeout: 90_000,
  log_level: :info,
  show_sensitive_data_on_connection_error: true
