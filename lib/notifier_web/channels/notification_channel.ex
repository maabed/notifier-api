defmodule NotifierWeb.NotificationChannel do
  @moduledoc false
  use Phoenix.Channel

  require Logger

  def join("notification:all", _message, socket) do
    # current_user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, socket}
  end

  def join("notification:" <> current_user, _params, socket) do
    user_id = Guardian.Phoenix.Socket.current_resource(socket)
    Logger.info "NotificationChannel user_id: #{inspect current_user}"
    if user_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
