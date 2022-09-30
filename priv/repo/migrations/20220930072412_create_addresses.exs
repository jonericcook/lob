defmodule Lob.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :line1, :string
      add :line2, :string
      add :city, :string
      add :state, :string
      add :zip, :string

      timestamps()
    end
  end
end
