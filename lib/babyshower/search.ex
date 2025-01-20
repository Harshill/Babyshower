defmodule Babyshower.Search do
  alias Babyshower.Invitation.Phonenumber
  alias Phoenix.Component

  # Changeset for phone number
  @spec phone_number_changeset(map) :: any()
  def phone_number_changeset(attrs \\ %{}) do
    %Phonenumber{}
    |> Phonenumber.changeset(attrs)
  end

  def phone_number_not_found_changeset(phone_number) do
    error_message = "#{phone_number} not found, please check the number and try again, or contact host"

    %{phone_number: phone_number}
      |> phone_number_changeset()
      |> Map.put(:errors, [phone_number: {error_message, [validation: :required]}])
      |> Map.put(:action, :validate)
  end

  def short_phone_number_changeset(phone_number) do

    %{phone_number: phone_number}
      |> phone_number_changeset()
      |> Map.put(:action, :validate)
  end

  @spec phone_number_form(any()) :: map()
  def phone_number_form(phone_number_changeset) do
    Component.to_form(phone_number_changeset, as: "RsvpSearch", id: "rsvp-search", errors: ["Error"])
  end

end
