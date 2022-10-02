defmodule LobWeb.AddressView do
  use LobWeb, :view
  alias LobWeb.AddressView

  def render("index.json", %{addresses: addresses}) do
    render_many(addresses, AddressView, "address.json")
  end

  def render("show.json", %{address: address}) do
    render_one(address, AddressView, "address.json")
  end

  def render("address.json", %{address: address}) do
    address
  end
end
