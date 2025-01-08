
defmodule Babyshower.ResponseStats do
  alias Babyshower.Repo
  alias Babyshower.Invitation.Guest

  import Ecto.Query

  def count_guests_rsvped() do
    Guest
    |> where([g], not is_nil(g.response))
    |> Repo.all()
    |> Enum.count()
  end

  def count_guests_attending() do
    Guest
    |> where([g], not is_nil(g.response))
    |> select([g], g.response["n_members_accepted"])
    |> Repo.all()
    |> Enum.sum()
  end

  def count_guests_invited() do
    Guest
    |> Repo.all()
    |> Enum.count()
  end

  def count_guests_who_have_not_responded() do
    Guest
    |> where([g], is_nil(g.response))
    |> Repo.all()
    |> Enum.count()
  end

  def get_guest_guesses(%Guest{response: response}) do
    response.gender_guesses
  end

  def get_family_guess(guest) do
    guest_guesses = get_guest_guesses(guest)
    # Get a guess if the first_name is "family"
    Enum.find(guest_guesses, fn guess -> guess.first_name == "family" end)
  end

  # def count_guests_who_responded_yes() do
  #   Guest
  #   |> where([g], g.response["invite_accepted"] == true)
  #   |> Repo.all()
  #   |> Enum.count()
  # end

  # def count_guests_who_responded_no() do
  #   Guest
  #   |> where([g], g.response["invite_accepted"] == false)
  #   |> Repo.all()
  #   |> Enum.count()
  # end
end
