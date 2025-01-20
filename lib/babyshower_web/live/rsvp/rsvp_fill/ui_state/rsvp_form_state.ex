defmodule BabyshowerWeb.RsvpFormState do

  import BabyshowerWeb.ProcessMemberNumber, only: [process_member_count: 2]
  import BabyshowerWeb.ProcessAccept, only: [process_acceptance: 3]
  import BabyshowerWeb.ProcessGenderVote, only: [gender_answered: 2, handle_confirm_button_multi_vote: 2]

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

  def accepted_response_answered(state, accepted_response, n_members_accepted) do
    process_acceptance(state, accepted_response, n_members_accepted)
  end

  def n_members_answered(state, n_members) do
    process_member_count(state, n_members)
  end

  def answer_gender(state, response_data, gender_guess) do
    state = case state.family_vote? do
      true -> gender_answered(state, gender_guess)
      false -> handle_confirm_button_multi_vote(state, response_data)
    end
    state
  end

  def answered_name(state, response_data) do
    handle_confirm_button_multi_vote(state, response_data)
  end

end
