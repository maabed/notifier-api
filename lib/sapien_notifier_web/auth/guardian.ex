defmodule SapienNotifierWeb.Guardian do
  use Guardian, otp_app: :SapienNotifier
  require Logger

  def current_user(conn) do
    SapienNotifierWeb.Guardian.Plug.current_resource(conn["user"]["_id"])
  end

  def fetch_secret do
    System.get_env("JWT_PUBLIC_KEY")
    |> Kernel.||("")
    |> String.replace("\\n", "\n")
    |> JOSE.JWK.from_pem()
  end

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Logger.info "Claims on resource_from_claims: #{inspect claims}"
    {:ok, claims["user"]["_id"]}
  end

end
