use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
# Configures the endpoint

# SSL settings
# config :sapien_notifier, SapienNotifierWeb.Endpoint,
#   load_from_system_env: true,
#   http: [port: {:system, "PORT"}],
#   url: [host: System.get_env("HOST"), port: 443, scheme: "https"],
#   force_ssl: [rewrite_on: [:x_forwarded_proto]],
#   secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
#   check_origin: false

config :sapien_notifier, SapienNotifierWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("HOST")],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :sapien_notifier, SapienNotifier.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "18"),
  ssl: true

# Configures Guardian
config :sapien_notifier, SapienNotifierWeb.Guardian,
  issuer: "sapien",
  allowed_algos: ["ES256"],
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :sapien_notifier, SapienNotifierWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :sapien_notifier, SapienNotifierWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :sapien_notifier, SapienNotifierWeb.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.
