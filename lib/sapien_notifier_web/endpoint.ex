defmodule SapienNotifierWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :sapien_notifier
  use Absinthe.Phoenix.Endpoint

  socket "/socket", SapienNotifierWeb.UserSocket,
    websocket: [
      timeout: 45_000,
      check_origin: ["//127.0.0.1", "//localhost", "//*.sapien.network"]
    ]

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
    body_reader: {SapienNotifierWeb.BodyReader, :read_body, []},
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug SapienNotifierWeb.Router

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
