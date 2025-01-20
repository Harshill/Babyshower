defmodule BabyshowerWeb.RsvpFill do
  use BabyshowerWeb, :live_view

  import BabyshowerWeb.RSVPFill.Components

  alias Babyshower.Guestlist
  alias Babyshower.ResponseResults
  alias BabyshowerWeb.RsvpFormState
  alias Babyshower.Invitation.ResponseData
  alias BabyshowerWeb.HandleGenderForm

  # TODO - Right now they can enter Zero as number of guests attending
# TODO - they can also enter a negative number, and special characters like dashes in the number of guests attending

  def mount(%{"phone_number" => phone_number}, _session, socket) do
    guest = Guestlist.get_guest_by_phone_number(phone_number)
    response_data = build_response_data(guest)
    form_state = build_form_state(guest, response_data)

    socket
    |> assign(guest: guest)
    |> assign(app_layout: false)
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: form_state)
    |> ok()
  end

  defp build_response_data(%{response: nil} = guest) do
    %ResponseData{
      invite_accepted: nil,
      n_members_accepted: nil,
      gender_guesses: %{
        0 => %{"first_name" => "family", "gender_guess" => nil},
        1 => %{"first_name" => guest.first_name, "gender_guess" => nil}
      }
    }
  end

  defp build_response_data(%{response: response, first_name: first_name} = _guest) do
    n_members_accepted = if response.invite_accepted, do: response.n_members_accepted, else: nil
    gender_guesses = ResponseData.convert_gender_guesses_to_map(response.gender_guesses, first_name)

    %ResponseData{
      invite_accepted: response.invite_accepted,
      n_members_accepted: n_members_accepted,
      gender_guesses: gender_guesses
    }
  end

  defp build_form_state(%{response: nil}, _response_data) do
    %RsvpFormState{}
  end

  defp build_form_state(%{response: response}, response_data) do
    {show_gender_q, show_confirm_button} = get_display_states(response_data.n_members_accepted)

    %RsvpFormState{
      phone_number_searched: true,
      show_attending_q?: true,
      show_n_members_q?: should_show_n_members_q?(response),
      show_n_members_error?: false,
      show_gender_q?: show_gender_q,
      show_confirm_button?: show_confirm_button,
      error_message: "",
      family_vote?: ResponseData.is_voted_family(response.gender_guesses),
      n_member_votes: length(response.gender_guesses),
      gender_answered?: true
    }
  end

  defp should_show_n_members_q?(%{invite_accepted: true}), do: true
  defp should_show_n_members_q?(_response), do: false

  # defp get_display_states(nil), do: {false, false}
  defp get_display_states(_), do: {true, true}

  def render(assigns) do
    ~H"""
    <div>
      <div class="p-4"> <!-- Changed to p-4 for consistent outer padding -->
        <div class="cartoon-card rounded-2xl"> <!-- Added rounded-2xl -->
          <div class="p-4"> <!-- Added inner padding container -->
            <.back_link path={~p"/"}> Re-enter Phone Number </.back_link>
            <h1 class="rsvp-header text-center mb-4 mt-4">Welcome</h1>
            <div class="cartoon-text text-4xl text-center">
              {@guest.first_name <> " " <> @guest.last_name} and Family!
            </div>

            <div class="mt-8 space-y-6">
              <div class="cartoon-info-card p-6 bg-[#FFE6F4]">
                <.render_accept_form accepted_response={@response_data.invite_accepted}/>
                <.render_n_members_form :if={@rsvp_form_state.show_n_members_q?} n_members_accepted={@response_data.n_members_accepted} n_members_error={@rsvp_form_state.show_n_members_error?} error_message={@rsvp_form_state.error_message}/>
                <.render_gender_vote_form show_gender_q?={@rsvp_form_state.show_gender_q?} family_vote={@rsvp_form_state.family_vote?} response_data={@response_data} number_of_votes={@rsvp_form_state.n_member_votes}/>
              </div>
              <.render_confirm_button :if={@rsvp_form_state.show_confirm_button?} />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("responded_rsvp", %{"guest-response" => value}, socket) do

    response_data = ResponseData.handle_answer(socket.assigns.response_data, value)
    rsvp_form_state = RsvpFormState.accepted_response_answered(socket.assigns.rsvp_form_state, response_data.invite_accepted, response_data.n_members_accepted)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("responded-n-members", %{"n_members" => n_members}, socket) do
    rsvp_form_state = RsvpFormState.n_members_answered(socket.assigns.rsvp_form_state, n_members)

    socket
    |> assign(response_data: %{socket.assigns.response_data | n_members_accepted: n_members})
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("responded_gender", %{"guest-response" => gender_guess, "iter" => iter}, socket) do
    iter = String.to_integer(iter)

    response_data = socket.assigns.response_data
                    |> ResponseData.update_gender_guess(iter, gender_guess)

    rsvp_form_state = socket.assigns.rsvp_form_state
    rsvp_form_state = BabyshowerWeb.RsvpFormState.answer_gender(rsvp_form_state, response_data, gender_guess)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("responded_name", params, socket) do
    with target <- List.first(params["_target"]),
         iter <- target |> String.split("-") |> List.last() |> String.to_integer(),
         first_name <- params[target] do

      response_data =
        socket.assigns.response_data
        |> ResponseData.update_family_member_name(iter, first_name)

      rsvp_form_state =
        socket.assigns.rsvp_form_state
        |> RsvpFormState.answered_name(response_data)

      update_response_and_form_state(socket, response_data, rsvp_form_state)
    end
  end

  def handle_event("remove_vote", %{"iter" => iter}, socket) do
    response_data =
      socket.assigns.response_data
      |> ResponseData.remove_specific_vote(iter)

    rsvp_form_state =
      socket.assigns.rsvp_form_state
      |> HandleGenderForm.handle_remove_vote()
      |> RsvpFormState.answered_name(response_data)

    update_response_and_form_state(socket, response_data, rsvp_form_state)
  end

  def handle_event("add_vote", _params, socket) do
    rsvp_form_state = HandleGenderForm.handle_add_vote(socket.assigns.rsvp_form_state)

    update_socket(socket, %{
      rsvp_form_state: rsvp_form_state
    })
  end

  def handle_event("toggle-individual-vote", _params, socket) do
    rsvp_form_state = HandleGenderForm.handle_family_vote(socket.assigns.rsvp_form_state)

    update_socket(socket, %{
      rsvp_form_state: rsvp_form_state
    })
  end

  def handle_event("save-rsvp", _params, socket) do
    %{
      response_data: response_data,
      rsvp_form_state: rsvp_form_state,
      guest: guest
    } = socket.assigns

    guest_response = build_guest_response(response_data, rsvp_form_state)

    guest
    |> save_or_update_response(guest_response)
    |> handle_save_result(socket, guest)
  end

  defp build_guest_response(response_data, rsvp_form_state) do
    processed_guesses = ResponseResults.process_gender_guesses(
      response_data.gender_guesses,
      rsvp_form_state
    )

    n_members = ResponseResults.calculate_members_accepted(response_data)

    %{
      invite_accepted: response_data.invite_accepted,
      n_members_accepted: n_members,
      gender_guesses: processed_guesses
    }
  end

  defp save_or_update_response(guest, guest_response) do
    case guest.response do
      nil -> ResponseResults.save_response(guest, guest_response)
      _ -> ResponseResults.update_response(guest, guest_response)
    end
  end

  defp handle_save_result(result, socket, guest) do
    case result do
      {:ok, _response} ->
        socket
        |> put_flash(:info, "You have RSVPd successfully!")
        |> push_navigate(to: "/rsvp/#{guest.phone_number}/show")
        |> noreply()

      {:error, _changeset} ->
        socket
        |> put_flash(:error, "There was an error saving your RSVP. Please try again.")
        |> noreply()
    end
  end

  defp update_socket(socket, assigns) do
    socket
    |> assign(assigns)
    |> noreply()
  end

  defp update_response_and_form_state(socket, response_data, rsvp_form_state) do
    update_socket(socket, %{
      response_data: response_data,
      rsvp_form_state: rsvp_form_state
    })
  end

end
