defmodule SapienNotificationWeb.Router do
  use SapienNotificationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SapienNotificationWeb do
    pipe_through :api
  end
end
