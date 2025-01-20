defmodule Babyshower.Invitation.ResponseData do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :invite_accepted, :boolean
    field :n_members_accepted, :integer
    field :number_of_votes, :integer, default: 1

    embeds_many :gender_guesses, GenderGuess, on_replace: :delete do
      field :first_name, :string
      field :gender_guess, :string
    end
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [:invite_accepted, :n_members_accepted, :number_of_votes])
    |> cast_embed(:gender_guesses, with: &gender_guess_changeset/2)
    |> validate_required([:phone_number])
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/)
    |> validate_inclusion(:invite_accepted, [true, false])
    |> validate_inclusion(:gender_vote, ["girl", "boy"])
  end

  def gender_guess_changeset(gender_guess, attrs \\ %{}) do
    gender_guess
    |> cast(attrs, [:first_name, :gender_guess])
    |> validate_required([:first_name, :gender_guess])
    |> validate_inclusion(:gender_guess, ["girl", "boy"])
    |> validate_format(:first_name, ~r/^[a-zA-Z]+$/, message: "can only contain letters")
  end

  def handle_answer(response_data, value) do
    set_response = case value do
      "yes" -> true
      "no" -> false
    end

    %{response_data | invite_accepted: set_response}
  end

  def remove_specific_vote(response_data, iter) do
    gender_guesses = response_data.gender_guesses
    iter = String.to_integer(iter)

   gender_guesses = gender_guesses
                    |> Map.delete(iter)
                    |> Map.values()
                    |> Enum.with_index()
                    |> Enum.map(fn {v, k} -> {k, v} end)
                    |> Map.new()

    %{response_data | gender_guesses: gender_guesses}
  end

  def get_family_member_response(response_data, iter) do
    family_member_response = response_data.gender_guesses[iter]

    case family_member_response do
      nil -> %{"first_name" => nil, "gender_guess" => nil}
      _ -> family_member_response
    end
  end

  def update_family_member_name(response_data, iter, first_name) do
    # Get existing or new family member response
    family_member_response = get_family_member_response(response_data, iter)
                             |> Map.put("first_name", first_name)

    # Update gender_guesses map with updated family member guess
    gender_guesses = Map.put(response_data.gender_guesses, iter, family_member_response)

    # Update response_data with new gender_guesses
    %{response_data | gender_guesses: gender_guesses}
  end

  def update_gender_guess(response_data, iter, gender_guess) do
    family_member_response = get_family_member_response(response_data, iter)
                             |> Map.put("gender_guess", gender_guess)

    gender_guesses = Map.put(response_data.gender_guesses, iter, family_member_response)

    %{response_data | gender_guesses: gender_guesses}
  end

  def is_voted_family([gender_guess | _]) do
    case gender_guess.first_name do
      "family" -> true
      _ -> false
    end
  end

  def convert_gender_guesses_to_map(gender_guesses, first_name) do
    case is_voted_family(gender_guesses) do
      false -> gender_guesses
               |> convert_list_to_index_map(1)
               |> Map.put(0, %{"first_name" => "family", "gender_guess" => nil})
      true -> gender_guesses
              |> convert_list_to_index_map(0)
              |> Map.put(1, %{"first_name" => first_name, "gender_guess" => nil})
    end
  end

  def convert_list_to_index_map(list, index_offset \\ 0) do
    list
    |> Enum.with_index(index_offset)
    |> Enum.map(fn {family_response, index} -> %{index => %{"first_name" => family_response.first_name, "gender_guess" => family_response.gender_guess}} end)
    |> Enum.reduce(fn family_response, acc -> Map.merge(family_response, acc) end)
  end
end
