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

  def get_address(id), do: Redix.command(:redix, ["GET", id])

  def create_address(address \\ %{}) do
    changeset = Address.changeset(%{}, Map.put(address, :id, Ecto.UUID.generate()))

    case changeset.valid? do
      true ->
        result = Ecto.Changeset.apply_changes(changeset)
        redis_set(result)

      false ->
        {:error, changeset}
    end
  end

  def update_address(address, attrs) do
    address
    |> Address.changeset(attrs)
  end

  def delete_address(id) do
    with {:ok, _} <- Redix.command(:redix, ["DEL", id]) do
      :ok
    end
  end

  defp mget([]), do: {:ok, []}
  defp mget(keys), do: Redix.command(:redix, ["MGET" | keys])

  defp redis_set(value) do
    case Redix.command(:redix, ["SET", value.id, Jason.encode!(value)]) do
      {:ok, "OK"} ->
        {:ok, value}

      error ->
        error
    end
  end
end
