defmodule Babyshower.Invitation.Response do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :phone_number, :string
    field :invite_accepted, :boolean
    field :n_members_accepted, :integer
    field :gender_vote, :string
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:phone_number, :invite_accepted, :n_members_accepted, :gender_vote])
    |> validate_required([:phone_number, :invite_accepted, :n_members_accepted])
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/)
    |> validate_inclusion(:invite_accepted, [true, false])
    |> validate_inclusion(:gender_vote, ["girl", "boy"])
  end
end
