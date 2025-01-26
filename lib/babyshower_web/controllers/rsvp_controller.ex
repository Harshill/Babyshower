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

    event_info = %{
      date: EventInfo.event_date(),
      time: EventInfo.event_time(),
      location: EventInfo.event_location(),
      city: EventInfo.event_city(),
      state: EventInfo.event_state(),
      zip: EventInfo.event_zip(),
      venue_title: EventInfo.venue_title()
    }

    render(conn, :show,
           guest: guest, family_guess:
           family_guess, guesses: guesses,
           app_layout: false, edit: edit,
           event_info: event_info)
  end
end
