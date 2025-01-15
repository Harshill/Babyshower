defmodule Babyshower.ResponseResults do
  alias Babyshower.Repo
  alias Babyshower.Response.GuestResponse

  def save_response(guest, attrs) do
    %GuestResponse{guest_id: guest.id}
    |> GuestResponse.changeset(attrs)
    |> Repo.insert()
  end

  def update_response(guest, attrs) do
    guest.response
    |> GuestResponse.changeset(attrs)
    |> Repo.update()
  end

end
