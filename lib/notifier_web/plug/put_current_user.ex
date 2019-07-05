defmodule NotifierWeb.Plug.PutCurrentUser do
  @moduledoc false
  import Plug.Conn, only: [assign: 3]

  def init(default), do: default

  def call(conn, _default) do
    user_id = NotifierWeb.Guardian.current_user(conn)
    assign(conn, :user_id, user_id)
  end
end
