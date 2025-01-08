defmodule Babyshower.Repo.Migrations.AddResponsesTable do
  use Ecto.Migration

  def change do
    create table(:responses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :invite_accepted, :boolean
      add :n_members_accepted, :integer
      add :gender_guesses, :map

      add :guest_id, references(:guests, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
