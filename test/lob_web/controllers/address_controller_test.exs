defmodule LobWeb.AddressControllerTest do
  use LobWeb.ConnCase

  import Lob.AddressesFixtures

  alias Lob.Addresses.Address

  @create_attrs %{
    city: "some city",
    line1: "some line1",
    line2: "some line2",
    state: "some state",
    zip: "some zip"
  }
  @update_attrs %{
    city: "some updated city",
    line1: "some updated line1",
    line2: "some updated line2",
    state: "some updated state",
    zip: "some updated zip"
  }
  @invalid_attrs %{city: nil, line1: nil, line2: nil, state: nil, zip: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create address" do
    test "renders address when data is valid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "city" => "some city",
               "line1" => "some line1",
               "line2" => "some line2",
               "state" => "some state",
               "zip" => "some zip"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update address" do
    setup [:create_address]

    test "renders address when data is valid", %{conn: conn, address: %Address{id: id} = address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "city" => "some updated city",
               "line1" => "some updated line1",
               "line2" => "some updated line2",
               "state" => "some updated state",
               "zip" => "some updated zip"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, address: address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete address" do
    setup [:create_address]

    test "deletes chosen address", %{conn: conn, address: address} do
      conn = delete(conn, Routes.address_path(conn, :delete, address))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.address_path(conn, :show, address))
      end
    end
  end

  defp create_address(_) do
    address = address_fixture()
    %{address: address}
  end
end
