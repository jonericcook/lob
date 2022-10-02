defmodule Lob.Addresses do
  @moduledoc """
  The Addresses context.
  """

  alias Lob.Addresses.Address

  def list_addresses do
    with {:ok, keys} <- Redix.command(:redix, ["KEYS", "*"]),
         {:ok, result} <- mget(keys) do
          IO.inspect(result)
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
