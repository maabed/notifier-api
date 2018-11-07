defmodule SapienNotifierWeb.Router do
  use SapienNotifierWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SapienNotifierWeb do
    pipe_through :api
  end
end
