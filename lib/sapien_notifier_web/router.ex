defmodule NotifierWeb.Router do
  use NotifierWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug NotifierWeb.Context
  end

  scope "/api" do
    pipe_through :api
    forward "/health", NotifierWeb.PlugRouter
    forward "/graphql", Absinthe.Plug,
      schema: NotifierWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: NotifierWeb.Schema,
        socket: NotifierWeb.UserSocket,
        interface: :playground
    end
  end
end
