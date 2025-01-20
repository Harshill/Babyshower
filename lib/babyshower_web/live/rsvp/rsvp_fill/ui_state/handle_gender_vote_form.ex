defmodule BabyshowerWeb.HandleGenderForm do
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
end
