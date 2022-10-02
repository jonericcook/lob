defmodule LobWeb.Router do
  use LobWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/addresses", LobWeb do
    pipe_through :api
    get "/", AddressController, :index
    post "/", AddressController, :create
    put "/:id", AddressController, :update
    delete "/:id", AddressController, :delete
  end
end
