defmodule NotifierWeb.Plug.PutCurrentUser do
  import Plug.Conn, only: [assign: 3]

  def init(default), do: default

  def call(conn, _default) do
    current_user = NotifierWeb.Guardian.current_user(conn)
    assign(conn, :current_user, current_user)
  end
end
