defmodule SapienNotifierWeb.NotificationChannel do
  use Phoenix.Channel

  def join("notification:all", _message, socket) do
    # current_user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, socket}
  end

  def join("notification:" <> _user_id, _params, socket) do
    current_user = Guardian.Phoenix.Socket.current_resource(socket)
    if current_user do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
