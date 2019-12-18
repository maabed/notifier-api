import Config

# Configures the endpoint
config :sapien_notifier, SapienNotifierWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  url: [host: System.get_env("HOST")],
  server: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  code_reloader: false

# Configures Guardian
config :sapien_notifier, SapienNotifierWeb.Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Do not print debug messages in production
config :logger, level: :debug
