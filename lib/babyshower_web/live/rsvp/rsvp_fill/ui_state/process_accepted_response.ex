defmodule BabyshowerWeb.ProcessAccept do
  @moduledoc """
  Manages state transitions for user responses in a multi-step form.
  Handles visibility of questions and confirmation buttons based on user inputs.
  """

  @type state :: %{
    show_n_members_q?: boolean(),
    show_gender_q?: boolean(),
    show_confirm_button?: boolean(),
    gender_answered?: boolean()
  }

  @doc """
  Updates the form state based on acceptance response and number of accepted members.
  Controls visibility of different form sections based on user inputs.

  ## Examples:

      iex> state = %{show_n_members_q?: false, show_gender_q?: false,
      ...>           show_confirm_button?: false, gender_answered?: true}
      iex> ResponseStateManager.process_acceptance(state, true, 5)
      %{show_n_members_q?: true, show_gender_q?: false,
        show_confirm_button?: true, gender_answered?: true}

      iex> ResponseStateManager.process_acceptance(state, false, nil)
      %{show_n_members_q?: false, show_gender_q?: true,
        show_confirm_button?: false, gender_answered?: true}
  """
  @spec process_acceptance(state(), boolean(), non_neg_integer() | nil) :: state()
  def process_acceptance(state, accepted_response, n_members_accepted) do
    state
    |> update_question_visibility(accepted_response)
    |> update_confirmation_status(n_members_accepted)
  end

  # Private Functions

  @spec update_question_visibility(state(), boolean()) :: state()
  defp update_question_visibility(state, true) do
    %{state | show_n_members_q?: true}
  end

  defp update_question_visibility(state, false) do
    %{state |
      show_n_members_q?: false,
      show_gender_q?: true
    }
  end

  @spec update_confirmation_status(state(), non_neg_integer() | nil) :: state()
  defp update_confirmation_status(state = %{gender_answered?: true}, nil) do
    %{state |
      show_confirm_button?: false,
      show_gender_q?: false
    }
  end

  defp update_confirmation_status(state = %{gender_answered?: true}, _n_members) do
    %{state | show_confirm_button?: true}
  end

  defp update_confirmation_status(state, _), do: state
end
