defmodule NotifierWeb.Auth.SecretFetcher do
  # require Logger
  # use Guardian.Token.Jwt.SecretFetcher
  # alias Guardian.Token.Jwt.SecretFetcher.SecretFetcherDefaultImpl
  # alias JOSE.JWK

  # def fetch_signing_secret(mod, opts) do
  #   SecretFetcherDefaultImpl.fetch_signing_secret(mod, opts)
  # end

  # def fetch_verifying_secret(mod, mod, opts) do
  #   System.get_env("JWT_PUBLIC_KEY")
  #   |> Kernel.||("")
  #   |> String.replace("\\n", "\n")
  #   |> JWK.from_pem()
  # end
end
