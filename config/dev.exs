use Mix.Config

# # Configures the endpoint For development, we disable any cache and enable
# debugging and code reloading.
config :notifier, NotifierWeb.Endpoint,
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
config :notifier, Notifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "notifier_dev",
  hostname: System.get_env("PG_HOST") || "localhost",
  pool_size: 40,
  log: System.get_env("SQL_LOG") == "1"
