defmodule Lob.Addresses do
  @moduledoc """
  The Addresses context.
  """

  alias Lob.Addresses.Address

  def list_addresses do
    with {:ok, keys} <- Redix.command(:redix, ["KEYS", "*"]),
         {:ok, result} <- mget(keys) do
      Enum.map(result, fn address -> Jason.decode!(address) end)
    end
  end

  def get_address(id) do
    case Redix.command(:redix, ["GET", id]) do
      {:ok, nil} ->
        {:error, :not_found}

      {:ok, result} ->
        {:ok, Jason.decode!(result)}

      error ->
        error
    end
  end

  def create_address(attrs \\ %{}) do
    %{}
    |> Address.changeset(Map.put(attrs, "id", Ecto.UUID.generate()))
    |> set_address()
  end

  def update_address(address, attrs) do
    address = for {key, val} <- address, into: %{}, do: {String.to_atom(key), val}

    address
    |> Address.changeset(attrs)
    |> set_address()
  end

  def delete_address(id) do
    with {:ok, _address} <- get_address(id),
         {:ok, _} <- Redix.command(:redix, ["DEL", id]) do
      :ok
    end
  end

  def search(search) do
    addresses = list_addresses()
    do_search(addresses, search)
  end

  def do_search(addresses, []) do
    addresses
  end

  def do_search(addresses, [search | rest]) do
    filtered_addresses = Enum.filter(addresses, fn address ->
      address_string = address_to_string(address)
      String.contains?(address_string, search)
    end)
    do_search(filtered_addresses, rest)
  end

  def address_to_string(%{"line1" => line1, "line2" => line2, "city" => city, "state" => state, "zip" => zip}) do
    line1 <> " " <> line2 <> " " <> city <> " " <> state <> " " <> zip
  end

  def address_to_string(%{"line1" => line1, "city" => city, "state" => state, "zip" => zip}) do
    line1 <> " " <> city <> " " <> state <> " " <> zip
  end

  defp mget([]), do: {:ok, []}
  defp mget(keys), do: Redix.command(:redix, ["MGET" | keys])

  defp set_address(changeset) do
    case changeset.valid? do
      true ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> redis_set()

      false ->
        {:error, changeset}
    end
  end

  defp redis_set(value) do
    case Redix.command(:redix, ["SET", value.id, Jason.encode!(value)]) do
      {:ok, "OK"} ->
        {:ok, value}

      error ->
        error
    end
  end
end
