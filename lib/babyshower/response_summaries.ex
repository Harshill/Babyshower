
defmodule Babyshower.ResponseStats do
  alias Babyshower.Repo
  alias Babyshower.Invitation.Guest
  alias Babyshower.Response.GuestResponse

  import Ecto.Query

  def count_guests_rsvped(side \\ nil) do
    guests = get_responded_guests(side)

    guests
    |> Enum.reduce(0, fn guest, acc -> if not is_nil(guest.response), do: acc + 1, else: acc end)
  end

  def get_responded_guests(side \\ nil) do
    query = from g in Guest,
            left_join: r in GuestResponse,
            on: g.id == r.guest_id,
            preload: [:response]
    query = case side do
      nil -> query
      _ -> where(query, [g], g.he_side == ^side)
    end

    query
    |> Repo.all()
    |> Enum.filter(fn guest -> not is_nil(guest.response) end)
  end

  def count_families_attending(side \\ nil) do
    guests = get_responded_guests(side)

    guests
    |> Enum.reduce(0, fn guest, acc -> if guest.response.invite_accepted == true, do: acc + 1, else: acc end)
  end

  def count_guests_attending(side \\ nil) do
    guests = get_responded_guests(side)

    guests
    |> Enum.reduce(0, fn guest, acc -> if guest.response.invite_accepted == true, do: acc + guest.response.n_members_accepted, else: acc end)
  end

  def count_guests_invited(side \\ nil) do
    case side do
      nil -> Guest |> Repo.all() |> Enum.count()
      _ -> Guest |> where([g], g.he_side == ^side) |> Repo.all() |> Enum.count()
    end
  end

  def get_gender_guess_counts(guest_responses) do

    guest_responses
    |> Enum.flat_map(fn guest -> guest.response.gender_guesses end)
    |> Enum.reduce(%{"boy" => 0, "girl" => 0}, fn individual_response, counts_map ->
      Map.update(counts_map, individual_response.gender_guess, 1, &(&1 + 1))
    end)
  end

  @spec count_gender_guesses() :: any()
  def count_gender_guesses(side \\ nil) do
    responded_guests = get_responded_guests(side)

    responded_guests
    |> get_gender_guess_counts()
  end

  def count_guests_who_have_not_responded() do
    Guest
    |> where([g], is_nil(g.response))
    |> Repo.all()
    |> Enum.count()
  end

  def get_guest_guesses(%Guest{response: response}) do
    gender_guessses = case response do
      nil -> nil
      _ -> response.gender_guesses
    end
    gender_guessses
  end

  def get_family_guess(guest) do
    guest_guesses = get_guest_guesses(guest)
    # Get a guess if the first_name is "family"
    case guest_guesses do
      nil -> nil
      _ -> Enum.find(guest_guesses, fn guess -> guess.first_name == "family" end)
    end
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
