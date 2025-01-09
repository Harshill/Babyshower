defmodule BabyshowerWeb.ShowRsvpController do
  use BabyshowerWeb, :controller
  alias Babyshower.Guestlist
  alias Babyshower.EventInfo
  alias Babyshower.ResponseStats

  def show(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # get phote number from params
    phone_number = Map.get(params, "phone_number")
    edit = Map.get(params, "edit")

    guest = Guestlist.get_guest_by_phone_number(phone_number)
    family_guess = ResponseStats.get_family_guess(guest)

    guesses = case family_guess do
      nil -> ResponseStats.get_guest_guesses(guest)
      _ -> nil
    end

    IO.inspect(guest)

    event_date = EventInfo.event_date()
    event_time = EventInfo.event_time()
    event_location = EventInfo.event_location()

    render(conn, :show, guest: guest, family_guess: family_guess, guesses: guesses, app_layout: false, edit: edit, event_date: event_date, event_time: event_time, event_location: event_location)
  end
end
