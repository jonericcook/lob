defmodule Lob.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :city, :string
    field :line1, :string
    field :line2, :string
    field :state, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:line1, :line2, :city, :state, :zip])
    |> validate_required([:line1, :line2, :city, :state, :zip])
  end
end
