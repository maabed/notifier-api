defmodule NotifierWeb.NotificationChannel do
  @moduledoc false
  use Phoenix.Channel

  require Logger

  def join("notification:all", _message, socket) do
    # current_user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, socket}
  end

  def join("notification:" <> user_id, _params, socket) do
    current_user = Guardian.Phoenix.Socket.current_resource(socket)
    Logger.info "NotificationChannel user_id: #{inspect user_id}"
    if current_user do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
