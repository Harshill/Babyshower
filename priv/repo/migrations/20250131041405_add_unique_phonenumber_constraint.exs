defmodule Babyshower.Repo.Migrations.AddUniquePhonenumberConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:guests, [:phone_number])
  end
end
