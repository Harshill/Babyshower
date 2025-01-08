defmodule Babyshower.ResponseResults do
  alias Babyshower.Repo
  alias Babyshower.Response.GuestResponse

  def save_response(guest, attrs) do
    response = Ecto.build_assoc(guest, :response, attrs)
    Repo.insert(response)
  end

  def update_response(guest, attrs) do
    guest.response |> GuestResponse.changeset(attrs) |> Repo.update()
  end
end
