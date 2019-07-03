defmodule NotifierWeb.Plug.ConnInterceptor do
  @moduledoc false
  # import Plug.Conn, only: [assign: 3]
  require Logger

  def init(default), do: default

  def call(conn, _default) do
    Logger.info "conn: #{inspect conn}"
    conn
  end
end
