defmodule BabyshowerWeb.RsvpResponsesController do
  use BabyshowerWeb, :controller
  alias Babyshower.ResponseStats

  def show(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # get phote number from params
    n_guests_invited = ResponseStats.count_guests_invited()
    n_guests_rsvped = ResponseStats.count_guests_rsvped()
    n_guests_attending = ResponseStats.count_guests_attending()
    # n_guests_responded_yes = Guestlist.count_guests_who_responded_yes()
    # n_guests_responded_no = Guestlist.count_guests_who_responded_no()
    # n_guests_not_responded = Guestlist.count_guests_who_have_not_responded()

    conn
    |> render(:show, n_guests_invited: n_guests_invited, n_guests_rsvped: n_guests_rsvped, n_guests_attending: n_guests_attending)
  end
end
