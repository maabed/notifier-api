defmodule NotifierWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: NotifierWeb.Schema

  ## Channels
  channel "notification:*", NotifierWeb.NotificationChannel

  def connect(params, socket) do
    context = build_context(params)
    socket = Absinthe.Phoenix.Socket.put_options(socket, context: context)
    {:ok, socket}
  end

  defp build_context(params) do
    with "Bearer " <> token <- Map.get(params, "authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
    else
      nil ->
        {:error, "Unauthorized"}
      _ ->
        %{}
    end
  end

  defp authorize(token) do
    case NotifierWeb.Guardian.decode_and_verify(token, %{}, secret: {NotifierWeb.Guardian, :fetch_secret, []}, allowed_algos: ["ES256"]) do
      {:ok, claims} -> NotifierWeb.Guardian.resource_from_claims(claims)
      {:error, reason} -> {:error, reason}
      nil -> {:error, "Unauthorized"}
    end
  end

  def id(_socket), do: nil
end
