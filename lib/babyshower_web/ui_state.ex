defmodule BabyshowerWeb.RsvpFormState do
  defstruct phone_number_searched: true,
            show_attending_q?: true,
            show_n_members_q?: false,
            show_n_members_error?: false,
            show_gender_q?: false,
            show_confirm_button?: false,
            error_message: "",
            family_vote?: true,
            n_member_votes: 1,
            gender_answered?: false


  def accepted_response_answered(state, accepted_response) do
    case accepted_response do
      true ->  %{state | show_n_members_q?: true}
      false -> %{state | show_n_members_q?: false, show_gender_q?: true}
    end
  end

  # TODO if someone votes for gender,
  def n_members_answered(state, n_members) do
    case check_n_members(n_members) do
      {:blank_error, error_message} -> %{state | show_n_members_error?: true, error_message: error_message, show_gender_q?: false, show_confirm_button?: false}
      {:invalid_error, error_message} -> %{state | show_n_members_error?: true, error_message: error_message,  show_gender_q?: false, show_confirm_button?: false}
      {:ok} -> %{state | show_gender_q?: true, show_n_members_error?: false}
    end
  end

  def check_n_members("") do
    {:blank_error, "Please enter a number greater than 0"}
  end

  def check_n_members(n_members) do
    n_members = String.to_integer(n_members)

    case n_members <= 0 do
      true -> {:invalid_error, "Please enter a number greater than 0"}
      false -> {:ok}
    end
  end

  def gender_answered(state, _gender_chosen) do
    %{state | show_confirm_button?: true, gender_answered?: true}
  end

  def handle_n_members_correct(state) do
    case state.gender_answered do
      false -> %{state | show_gender_q?: true, show_n_members_error?: false, error_message: ""}
      true -> %{state | show_gender_q?: true, show_n_members_error?: false, error_message: "", show_confirm_button?: true}
    end
  end

  @spec handle_family_vote(%{:show_confirm_button? => any(), optional(any()) => any()}) :: %{
          :show_confirm_button? => false,
          optional(any()) => any()
        }
  def handle_family_vote(state) do
    case state.family_vote? do
      true -> %{state | family_vote?: false, show_confirm_button?: false}

      false -> case state.gender_answered? do
        true -> %{state | show_confirm_button?: true, family_vote?: true}
        false -> %{state | show_confirm_button?: false, family_vote?: true}
      end
    end
  end

  def handle_add_vote(state) do
    %{state | n_member_votes: state.n_member_votes + 1, show_confirm_button?: false}
  end

  def handle_remove_vote(state) do
    %{state | n_member_votes: state.n_member_votes - 1}
  end


  def handle_confirm_button_multi_vote(state, response_data) do

    IO.inspect(response_data.gender_guesses)
    nil_responses = response_data.gender_guesses
    |> Map.values()
    |> Enum.drop_while(
      fn x -> x["first_name"] == "family" or (x["gender_guess"] != nil and check_first_name(x["first_name"])) end)

    IO.inspect(nil_responses)
    case length(nil_responses) do
      0 -> %{state | show_confirm_button?: true}
      _ -> %{state | show_confirm_button?: false}
    end
  end

  def check_first_name(first_name) do
    case first_name do
      "" -> false
      nil -> false
      _ -> true
    end
  end

end
