defmodule Lob.AddressesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lob.Addresses` context.
  """

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        city: "some city",
        line1: "some line1",
        line2: "some line2",
        state: "some state",
        zip: "some zip"
      })
      |> Lob.Addresses.create_address()

    address
  end
end
