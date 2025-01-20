# TODO if someone votes for gender,
defmodule BabyshowerWeb.ProcessMemberNumber do
  @allowed_n_members ~w(1 2 3 4 5 6 7 8 9 10)

  @type validation_result ::
    {:ok} |
    {:blank_error, String.t()} |
    {:invalid_error, String.t()}

  @type state :: %{
    show_n_members_error?: boolean(),
    error_message: String.t() | nil,
    show_gender_q?: boolean(),
    show_confirm_button?: boolean(),
    gender_answered?: boolean()
  }

  @doc """
  Validates the number of members and returns appropriate result.

  ## Examples:

      iex> MemberValidator.validate_member_count("")
      {:blank_error, "Please enter a number"}

      iex> MemberValidator.validate_member_count("3")
      {:ok}

      iex> MemberValidator.validate_member_count("0")
      {:invalid_error, "Please enter a number greater than 0"}
  """

  def process_member_count(state, n_members) do
    state
    |> validate_and_update_state(n_members)
    |> maybe_show_confirm_button()
  end

  @spec validate_member_count(String.t()) :: validation_result()
  def validate_member_count(""), do: {:blank_error, "Please enter a number"}

  def validate_member_count(n_members) when n_members in @allowed_n_members do
    case String.to_integer(n_members) do
      n when n > 0 -> {:ok}
      _ -> {:invalid_error, "Please enter a number greater than 0"}
    end
  end

  def validate_member_count(_n_members),
    do: {:invalid_error, "Please enter a number between 1 and 10"}

  # Private Functions

  @spec validate_and_update_state(state(), String.t()) :: state()
  defp validate_and_update_state(state, n_members) do
    case validate_member_count(n_members) do
      {:ok} -> %{state |
        show_gender_q?: true,
        show_n_members_error?: false,
        error_message: nil
      }
      {error_type, message} when error_type in [:blank_error, :invalid_error] ->
        %{state |
          show_n_members_error?: true,
          error_message: message,
          show_gender_q?: false,
          show_confirm_button?: false
        }
    end
  end

  @spec maybe_show_confirm_button(state()) :: state()
  defp maybe_show_confirm_button(state = %{gender_answered?: true}),
    do: %{state | show_confirm_button?: true}
  defp maybe_show_confirm_button(state), do: state

end
