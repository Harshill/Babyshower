defmodule Babyshower.Invitation.GenderVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gender_vote" do
    field :gender_vote, :string

    embeds_many :guest_votes, GuestVote, on_replace: :delete do
      field :first_name, :string
      field :gender_vote, :string
    end

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:gender_vote])
    |> cast_embed(:guest_votes, with: &guest_vote_changeset/2, sort_param: :guest_votes_sort)
    |> validate_required([:gender_vote])
  end

  def guest_vote_changeset(guest_vote, attrs \\ %{}) do
    guest_vote
    |> cast(attrs, [:first_name, :gender_vote])
    |> validate_required([:first_name, :gender_vote])
  end
end
