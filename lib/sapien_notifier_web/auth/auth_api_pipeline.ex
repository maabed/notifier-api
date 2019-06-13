defmodule SapienNotifierWeb.Plug.AuthApiPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :SapienNotifier,
    module: SapienNotifierWeb.Guardian,
    error_handler: SapienNotifierWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug SapienNotifierWeb.Plug.PutCurrentUser
  # plug SapienNotifierWeb.Plug.ConnInterceptor # for debugging
end
