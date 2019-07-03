defmodule NotifierWeb.Plug.AuthApiPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :Notifier,
    module: NotifierWeb.Guardian,
    error_handler: NotifierWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug NotifierWeb.Plug.PutCurrentUser
  # plug NotifierWeb.Plug.ConnInterceptor # for debugging
end
