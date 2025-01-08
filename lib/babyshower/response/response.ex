defmodule Babyshower.Response.GuestResponse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "responses" do
    field :invite_accepted, :boolean
    field :n_members_accepted, :integer

    embeds_many :gender_guesses, GenderGuess, on_replace: :delete do
      field :first_name, :string
      field :gender_guess, :string
    end

    belongs_to :guest, Babyshower.Invitation.Guest

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:invite_accepted, :n_members_accepted])
    |> cast_embed(:gender_guesses, with: &gender_guess_changeset/2, sort_param: :gender_guesses_sort)
    |> validate_required([:invite_accepted, :n_members_accepted])
    |> validate_member_attending()
  end

  def gender_guess_changeset(gender_guess, attrs \\ %{}) do
    gender_guess
    |> cast(attrs, [:first_name, :gender_guess])
    |> validate_required([:first_name, :gender_guess])
    # Validate no spaces in the first name
    |> validate_format(:first_name, ~r/\A[^ ]+\z/, message: "cannot contain spaces")
  end

  def validate_member_attending(changeset) do
    n_members_accepted = get_field(changeset, :n_members_accepted)
    accepted = get_field(changeset, :invite_accepted)

    if accepted && n_members_accepted == 0 do
      add_error(changeset, :n_members_accepted, "must be greater than 0")
    else
      changeset
    end

  end
end
