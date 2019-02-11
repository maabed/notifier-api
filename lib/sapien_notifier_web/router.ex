defmodule SapienNotifierWeb.Router do
  use SapienNotifierWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug SapienNotifierWeb.Context
  end

  scope "/api" do
    pipe_through :api
    forward "/health", SapienNotifierWeb.PlugRouter
    forward "/graphql", Absinthe.Plug,
      schema: SapienNotifierWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: SapienNotifierWeb.Schema,
        socket: SapienNotifierWeb.UserSocket,
        interface: :playground
    end
  end
end
