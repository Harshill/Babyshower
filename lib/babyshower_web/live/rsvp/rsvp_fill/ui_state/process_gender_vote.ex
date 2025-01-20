defmodule BabyshowerWeb.ProcessGenderVote do

  @spec gender_answered(
          %{:gender_answered? => any(), :show_confirm_button? => any(), optional(any()) => any()},
          any()
        ) :: %{:gender_answered? => true, :show_confirm_button? => true, optional(any()) => any()}
  def gender_answered(state, _gender_chosen) do
    %{state | show_confirm_button?: true, gender_answered?: true}
  end

  # TODO if someone votes for gender,


  def handle_confirm_button_multi_vote(state, response_data) do

    nil_responses = response_data.gender_guesses

    |> Map.values()
    |> Enum.filter(
      fn x -> x["first_name"] != "family" and (x["gender_guess"] == nil or bad_first_name(x["first_name"])) end)

    case length(nil_responses) do
      0 -> %{state | show_confirm_button?: true}
      _ -> %{state | show_confirm_button?: false}
    end
  end

  def bad_first_name(first_name) do
    case first_name do
      "" -> true
      nil -> true
      "family" -> false
      _ -> false
    end
  end
end
