defmodule LobWeb.AddressController do
  use LobWeb, :controller

  alias Lob.Addresses

  action_fallback LobWeb.FallbackController

  def index(%Plug.Conn{query_params: %{"search" => search}} = conn, _params) do
    addresses = search |> String.split() |> Addresses.search()

    render(conn, "index.json", addresses: addresses)
  end

  def index(conn, _params) do
    addresses = Addresses.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, address_params) do
    with {:ok, address} <- Addresses.create_address(address_params) do
      conn
      |> put_status(:created)
      |> render("show.json", address: address)
    end
  end

  def update(conn, %{"id" => id} = address_params) do
    with {:ok, address} <- Addresses.get_address(id),
         {:ok, address} <- Addresses.update_address(address, address_params) do
      render(conn, "show.json", address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Addresses.delete_address(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
