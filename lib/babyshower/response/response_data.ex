defmodule Babyshower.Invitation.ResponseData do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :invite_accepted, :boolean
    field :n_members_accepted, :integer
    field :number_of_votes, :integer, default: 1

    embeds_many :gender_guesses, GenderGuess, on_replace: :delete do
      field :first_name, :string
      field :gender_guess, :string
    end
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:invite_accepted, :n_members_accepted, :number_of_votes])
    |> cast_embed(:gender_guesses, with: &gender_guess_changeset/2)
    |> validate_required([:phone_number])
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/)
    |> validate_inclusion(:invite_accepted, [true, false])
    |> validate_inclusion(:gender_vote, ["girl", "boy"])
  end

  def gender_guess_changeset(gender_guess, attrs \\ %{}) do
    gender_guess
    |> cast(attrs, [:first_name, :gender_guess])
    |> validate_required([:first_name, :gender_guess])
    |> validate_inclusion(:gender_guess, ["girl", "boy"])
    |> validate_format(:first_name, ~r/\A[^ ]+\z/, message: "cannot only conatain letters")
  end

end
