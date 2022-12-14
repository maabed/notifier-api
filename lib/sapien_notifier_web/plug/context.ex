defmodule SapienNotifierWeb.Context do
  @behaviour Plug
  import Plug.Conn
  require Logger
  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Logger.warn "context ON call: #{inspect context}"
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do

    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      %{current_user: token}
    else
      nil ->
        {:error, "Unauthorized"}
      _ ->
        %{}
    end
  end
  # @TODO: for later once add jwt to mutations and query
  # defp authorize(token) do
  #   case SapienNotifierWeb.Guardian.decode_and_verify(token) do
  #     {:ok, claims} -> SapienNotifierWeb.Guardian.resource_from_claims(claims)
  #     {:error, reason} -> {:error, reason}
  #     nil -> {:error, "Unauthorized"}
  #   end
  # end
end
