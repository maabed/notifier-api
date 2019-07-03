defmodule NotifierWeb.PlugRouter do
  alias Notifier.Repo

  @moduledoc false
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    results = Ecto.Adapters.SQL.query!(Repo, "SELECT 1", [])
    if results.rows == [[1]] do
      send_resp(conn, 200, "ok")
    else
      :error
    end
  end
end
