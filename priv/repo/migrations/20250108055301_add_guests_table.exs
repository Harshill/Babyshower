defmodule Babyshower.Repo.Migrations.AddGuestsTable do
  use Ecto.Migration

  def change do
    create table(:guests, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone_number, :string, null: false
      add :he_side, :string, null: false
      add :invitation, :map

      timestamps(type: :utc_datetime)
    end
  end
end
