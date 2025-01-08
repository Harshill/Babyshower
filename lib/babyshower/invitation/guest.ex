defmodule Babyshower.Invitation.Guest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Babyshower.Response.GuestResponse

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "guests" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :he_side, :string

    embeds_one :invitation, Invitation, on_replace: :update do
      field :invite_sent, :boolean
      field :estimated_guests, :integer
    end

    has_one :response, GuestResponse

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:first_name, :last_name, :phone_number, :he_side])
    |> cast_embed(:invitation, with: &invitation_changeset/2)
    |> cast_assoc(:response, with: &GuestResponse.changeset/2)
    |> validate_required([:first_name, :last_name, :phone_number, :he_side])
  end

  def invitation_changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:invite_sent, :estimated_guests])
    |> validate_required([:invite_sent, :estimated_guests])
    |> validate_number(:estimated_guests, greater_than: 0)
  end
end
