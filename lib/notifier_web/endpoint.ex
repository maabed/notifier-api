defmodule NotifierWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :notifier
  use Absinthe.Phoenix.Endpoint

  socket "/socket", NotifierWeb.UserSocket,
    websocket: [
      timeout: 45_000,
      check_origin: ["//127.0.0.1", "//localhost", "//*.sapien.network", "//sapien-notifier.herokuapp.com"]
    ]
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :notifier,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    body_reader: {NotifierWeb.BodyReader, :read_body, []},
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_notifier_key",
    signing_salt: "/83W7kX3"

  plug NotifierWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  Check system environment vars at endpoint configuration
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end