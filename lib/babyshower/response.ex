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

  def process_gender_guesses(gender_guesses, %{family_vote?: true}) do
    gender_guesses
    |> drop_non_family_votes()
  end

  def process_gender_guesses(gender_guesses, %{family_vote?: false} = state) do
    gender_guesses
    |> drop_excess_votes(state.n_member_votes)
  end

  # Private Functions

  defp drop_non_family_votes(gender_guesses) do
    keys_to_drop = gender_guesses
    |> Map.keys()
    |> Enum.drop_while(&(&1 == 0))

    Map.drop(gender_guesses, keys_to_drop)
  end

  defp drop_excess_votes(gender_guesses, n_member_votes) do
    keys_to_drop = gender_guesses
    |> Map.keys()
    |> Enum.filter(&(excess_vote?(&1, n_member_votes)))

    Map.drop(gender_guesses, keys_to_drop)
  end

  defp excess_vote?(key, n_member_votes) do
    key == 0 || key > n_member_votes
  end

  def calculate_members_accepted(%{invite_accepted: true} = data) do
    data.n_members_accepted
  end
  def calculate_members_accepted(_), do: 0

end
