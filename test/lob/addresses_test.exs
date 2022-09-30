defmodule Lob.AddressesTest do
  use Lob.DataCase

  alias Lob.Addresses

  describe "addresses" do
    alias Lob.Addresses.Address

    import Lob.AddressesFixtures

    @invalid_attrs %{city: nil, line1: nil, line2: nil, state: nil, zip: nil}

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Addresses.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Addresses.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{city: "some city", line1: "some line1", line2: "some line2", state: "some state", zip: "some zip"}

      assert {:ok, %Address{} = address} = Addresses.create_address(valid_attrs)
      assert address.city == "some city"
      assert address.line1 == "some line1"
      assert address.line2 == "some line2"
      assert address.state == "some state"
      assert address.zip == "some zip"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      update_attrs = %{city: "some updated city", line1: "some updated line1", line2: "some updated line2", state: "some updated state", zip: "some updated zip"}

      assert {:ok, %Address{} = address} = Addresses.update_address(address, update_attrs)
      assert address.city == "some updated city"
      assert address.line1 == "some updated line1"
      assert address.line2 == "some updated line2"
      assert address.state == "some updated state"
      assert address.zip == "some updated zip"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, @invalid_attrs)
      assert address == Addresses.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Addresses.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Addresses.change_address(address)
    end
  end
end
