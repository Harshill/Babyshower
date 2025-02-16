defmodule BabyshowerWeb.RsvpResponsesController do
  use BabyshowerWeb, :controller
  alias Babyshower.ResponseStats

  def show(conn, params) do

    side = Map.get(params, "side")

    n_guests_invited = ResponseStats.count_guests_invited(side)
    n_guests_rsvped = ResponseStats.count_guests_rsvped(side)
    n_families_attending = ResponseStats.count_families_attending(side)
    n_guests_attending = ResponseStats.count_guests_attending(side)
    gender_guess_counts = ResponseStats.count_gender_guesses(side)

    conn
    |> render(:show,
              n_guests_invited: n_guests_invited,
              n_guests_rsvped: n_guests_rsvped,
              n_families_attending: n_families_attending,
              n_guests_attending: n_guests_attending,
              gender_guess_counts: gender_guess_counts
              )
  end
end
