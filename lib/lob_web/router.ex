defmodule LobWeb.Router do
  use LobWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LobWeb do
    pipe_through :api
    resources "/addresses", AddressController
  end
end
