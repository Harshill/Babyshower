defmodule Babyshower.Invitation.Phonenumber do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :phone_number, :string
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:phone_number])
    |> validate_required([:phone_number])
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/, message: "Phone number is too short please enter ten digits")
  end

end
