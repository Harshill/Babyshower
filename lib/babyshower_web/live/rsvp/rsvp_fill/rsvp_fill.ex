defmodule BabyshowerWeb.RsvpFill do
  use BabyshowerWeb, :live_view

  import BabyshowerWeb.RSVPFill.Components

  alias Babyshower.Guestlist
  alias Babyshower.ResponseResults
  alias BabyshowerWeb.RsvpFormState
  alias Babyshower.Invitation.ResponseData
  alias BabyshowerWeb.RsvpFillHelpers

  # TODO - Right now they can enter Zero as number of guests attending
# TODO - they can also enter a negative number, and special characters like dashes in the number of guests attending

  def mount(%{"phone_number" => phone_number}, _session, socket) do
    guest = Guestlist.get_guest_by_phone_number(phone_number)

    response_data = %ResponseData{
      invite_accepted: nil,
      n_members_accepted: nil,
      gender_guesses: %{0 => %{"first_name" => "family", "gender_guess" => nil}, 1 => %{"first_name" => guest.first_name, "gender_guess" => nil}}
    }

    rsvp_form_state = %RsvpFormState{}

    socket
    |> assign(guest: guest)
    |> assign(app_layout: false)
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="p-4"> <!-- Changed to p-4 for consistent outer padding -->
        <div class="cartoon-card rounded-2xl"> <!-- Added rounded-2xl -->
          <div class="p-4"> <!-- Added inner padding container -->
            <.back_link> Re-enter Phone Number </.back_link>
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
    rsvp_form_state = RsvpFormState.accepted_response_answered(socket.assigns.rsvp_form_state, response_data.invite_accepted)

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
    rsvp_form_state = case rsvp_form_state.family_vote? do
      true -> RsvpFormState.gender_answered(rsvp_form_state, gender_guess)
      false -> RsvpFormState.handle_confirm_button_multi_vote(rsvp_form_state, response_data)
    end

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("responded_name", params, socket) do
    target = params["_target"] |> List.first()
    iter = target |> String.split("-") |> List.last() |> String.to_integer()
    first_name = params[target]

    response_data = socket.assigns.response_data
                    |> ResponseData.update_family_member_name(iter, first_name)
    rsvp_form_state = socket.assigns.rsvp_form_state
                      |> RsvpFormState.handle_confirm_button_multi_vote(response_data)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("remove_vote", %{"iter" => iter}, socket) do

    response_data = socket.assigns.response_data
                    |> ResponseData.remove_specific_vote(iter)

    rsvp_form_state = socket.assigns.rsvp_form_state
                      |> RsvpFormState.handle_remove_vote()
                      |> RsvpFormState.handle_confirm_button_multi_vote(response_data)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("add_vote", _params, socket) do

    rsvp_form_state = RsvpFormState.handle_add_vote(socket.assigns.rsvp_form_state)
    # individual_gender_votes = Map.put(socket.assigns.response_data.gender_guesses, number_of_votes, %{"first_name" => nil, "gender_guess" => nil})

    socket
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("toggle-individual-vote", _params, socket) do
    socket
    |> assign(rsvp_form_state: RsvpFormState.handle_family_vote(socket.assigns.rsvp_form_state))
    |> noreply()
  end

  def handle_event("save-rsvp", _params, socket) do
    response_data = socket.assigns.response_data
    rsvp_form_state = socket.assigns.rsvp_form_state

    guest = socket.assigns.guest
    family_vote? = rsvp_form_state.family_vote?

    gender_guesses = response_data.gender_guesses

    gender_guesses = case family_vote? do
      true ->
        keys = gender_guesses
               |> Map.keys()
               |> Enum.drop_while(fn x -> x == 0 end)

        gender_guesses |> Map.drop(keys)

      false ->
        keys = gender_guesses
               |> Map.keys()
               |> Enum.filter(fn x -> x == 0 or x > rsvp_form_state.n_member_votes end)

        gender_guesses |> Map.drop(keys)
    end

    n_members_accepted = case response_data.invite_accepted do
      true -> response_data.n_members_accepted
      false ->  0
    end

    guest_response = %{
      invite_accepted: response_data.invite_accepted, n_members_accepted: n_members_accepted,
      gender_guesses: gender_guesses
      }

    result = case guest.response do
      nil -> ResponseResults.save_response(guest, guest_response)
      _ -> ResponseResults.update_response(guest, guest_response)
    end

    case result do
      {:ok, _response} -> socket
        |> put_flash(:info, "You have RSVPd successfully!")
        |> push_navigate(to: "/rsvp/#{guest.phone_number}/show")
        |> noreply()

      {:error, _changeset} ->
        socket
        |> put_flash(:error, "There was an error saving your RSVP. Please try again.")
        |> noreply()
    end
  end
end
