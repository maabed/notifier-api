import Config

# config :logger, level: :info

config :sapien_notifier,
  SECRET_KEY_BASE: System.fetch_env!("SECRET_KEY_BASE")

# Configures the endpoint
config :sapien_notifier, SapienNotifierWeb.Endpoint,
  http: [port: System.fetch_env!("PORT")],
  url: [host: System.fetch_env!("HOST")],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  code_reloader: false

# # Configure your database
config :sapien_notifier, SapienNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE") || "30"),
  migration_source: "notifier_migrations",
  priv: "priv/repo",
  ssl: false,
  log: :info,
  timeout: 240_000,
  ownership_timeout: 240_000

# Configures Guardian
config :sapien_notifier, SapienNotifierWeb.Guardian,
  secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")
