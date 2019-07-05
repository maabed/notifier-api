defmodule NotifierWeb.UnseenChannel do
  @moduledoc false
  use Phoenix.Channel

  require Logger

  def join("unseen:all", _message, socket), do: {:ok, socket}

  def join("unseen:" <> current_user, _params, socket) do
    user_id = Guardian.Phoenix.Socket.current_resource(socket)
    Logger.info "unseen current_user id: #{inspect current_user}"
    if user_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
