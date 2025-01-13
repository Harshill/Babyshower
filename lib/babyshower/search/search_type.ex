defmodule Babyshower.Invitation.Searchtype do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :search_type, :string
  end

  @doc false
  def changeset(searchtype, attrs) do
    searchtype
    |> cast(attrs, [:search_type])
    |> validate_required([:search_type])
  end

end
