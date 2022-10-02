defmodule Lob.Addresses.Address do
  alias Ecto.Changeset

  @address %{
    id: :string,
    line1: :string,
    line2: :string,
    city: :string,
    state: :string,
    zip: :string
  }
  @fields Map.keys(@address)
  @required @address |> Map.drop([:line2]) |> Map.keys()

  @doc false
  def changeset(address, attrs) do
    {address, @address}
    |> Changeset.cast(attrs, @fields)
    |> Changeset.validate_required(@required)
    |> Changeset.validate_length(:city, min: 1)
    |> Changeset.validate_length(:line1, min: 1)
    |> maybe_validate_line2()
    |> Changeset.validate_format(:state, ~r/^[A-Z]{2}$/)
    |> Changeset.validate_format(:zip, ~r/^[0-9]{5}$/)
  end

  defp maybe_validate_line2(changeset) do
    Changeset.validate_change(changeset, :line2, fn :line2, line2 ->
      if is_binary(line2) and String.length(line2) >= 1 do
        []
      else
        [line2: {"has invalid format", [validation: :format]}]
      end
    end)
  end
end
