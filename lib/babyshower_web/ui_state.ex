defmodule BabyshowerWeb.RsvpFormState do
  defstruct phone_number_searched: true,
            show_attending_q?: true,
            show_n_members_q?: false,
            show_n_members_error?: false,
            show_gender_q?: false,
            show_confirm_button?: false,
            error_message: "",
            family_vote?: true,
            n_members_incremented?: false,
            n_members_amount: 1


  def accepted_response_answered(state, accepted_response) do
    case accepted_response do
      true ->  %{state | show_n_members_q?: true}
      false -> %{state | show_n_members_q?: false, show_gender_q?: true}
    end
  end

  def n_members_answered(state, n_members) do
    case check_n_members(n_members) do
      {:blank_error, error_message} -> %{state | show_n_members_error?: true, error_message: error_message, show_gender_q?: false}
      {:invalid_error, error_message} -> %{state | show_n_members_error?: true, error_message: error_message,  show_gender_q?: false}
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
    %{state | show_confirm_button?: true}
  end
end
