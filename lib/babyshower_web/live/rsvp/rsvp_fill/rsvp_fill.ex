defmodule BabyshowerWeb.RsvpFill do
  use BabyshowerWeb, :live_view

  import BabyshowerWeb.RSVPFill.Components

  alias Babyshower.Guestlist
  alias Babyshower.ResponseResults
  alias BabyshowerWeb.RsvpFormState
  alias Babyshower.Invitation.ResponseData

  # TODO - Right now they can enter Zero as number of guests attending
# TODO - they can also enter a negative number, and special characters like dashes in the number of guests attending

  def mount(%{"phone_number" => phone_number}, _session, socket) do
    guest = Guestlist.get_guest_by_phone_number(phone_number)

    response_data = %ResponseData{
      invite_accepted: nil,
      n_members_accepted: nil,
      number_of_votes: 1,
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
            <.link
              navigate={~p"/"}
              class="inline-flex items-center px-3 py-1.5 text-xs rounded-lg bg-white border-2 border-[#FF69B4]/50 text-[#FF69B4] hover:bg-pink-50 transition-all duration-200 cartoon-text"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Re-enter Phone Number
            </.link>
            <h1 class="rsvp-header text-center mb-4">Welcome</h1>
            <div class="cartoon-text text-4xl text-center">
              {@guest.first_name <> " " <> @guest.last_name} and Family!
            </div>

            <div class="mt-8 space-y-6">
              <div class="cartoon-info-card p-6 bg-[#FFE6F4]">
                <.render_accept_form accepted_response={@response_data.invite_accepted}/>
                <.render_n_members_form :if={@rsvp_form_state.show_n_members_q?} n_members_accepted={@response_data.n_members_accepted} n_members_error={@rsvp_form_state.show_n_members_error?} error_message={@rsvp_form_state.error_message}/>
                <.render_gender_vote_form show_gender_q?={@rsvp_form_state.show_gender_q?} family_vote={@rsvp_form_state.family_vote?} response_data={@response_data}/>
              </div>
              <.render_confirm_button :if={@rsvp_form_state.show_confirm_button?} />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end


  def handle_event("responded_name", params, socket) do
    # split the target string by "-" and get the last element

    # %{"_target" => [target], "first_name" => first_name} = params

    target = params["_target"]
             |> List.first()

    iter = target
           |> String.split("-")
           |> List.last()
           |> String.to_integer()

    first_name = params[target]

    gender_guess = socket.assigns.response_data.gender_guesses[iter]

    gender_guess = case gender_guess do
      nil -> %{"first_name" => nil, "gender_guess" => nil}
      _ -> gender_guess
    end

    gender_guess = Map.put(gender_guess, "first_name", first_name)

    gender_guesses = socket.assigns.response_data.gender_guesses
    gender_guesses = Map.put(gender_guesses, iter, gender_guess)

    response_data = %{socket.assigns.response_data | gender_guesses: gender_guesses}


    rsvp_form_state = RsvpFormState.handle_confirm_button_multi_vote(socket.assigns.rsvp_form_state, response_data)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("remove_vote", _params, socket) do

    rsvp_form_state = RsvpFormState.handle_remove_vote(socket.assigns.rsvp_form_state)
    # individual_gender_votes = Map.put(socket.assigns.response_data.gender_guesses, number_of_votes, %{"first_name" => nil, "gender_guess" => nil})

    response_data = %{socket.assigns.response_data | number_of_votes: rsvp_form_state.n_member_votes}

    rsvp_form_state = RsvpFormState.handle_confirm_button_multi_vote(rsvp_form_state, response_data)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("add_vote", _params, socket) do

    rsvp_form_state = RsvpFormState.handle_add_vote(socket.assigns.rsvp_form_state)
    # individual_gender_votes = Map.put(socket.assigns.response_data.gender_guesses, number_of_votes, %{"first_name" => nil, "gender_guess" => nil})

    response_data = %{socket.assigns.response_data | number_of_votes: rsvp_form_state.n_member_votes}

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end


  def handle_event("toggle-individual-vote", _params, socket) do
    socket
    |> assign(rsvp_form_state: RsvpFormState.handle_family_vote(socket.assigns.rsvp_form_state))
    |> noreply()
  end

  def render_confirm_button(assigns) do
    # Show if guests are attending, number of members attending is set, and gender is voted for OR guests are not attending
    ~H"""
    <div class="mt-6 flex justify-center">
      <button
        phx-click="save-rsvp"
        class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-md text-white bg-[#1E90FF] hover:bg-[#FF69B4] active:bg-[#FF69B4] transition-all duration-300" >
        Confirm RSVP
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </button>
    </div>
    """
  end


  def handle_event("responded_rsvp", %{"guest-response" => value}, socket) do
    set_response = case value do
      "yes" -> true
      "no" -> false
    end

    response_data =  %{socket.assigns.response_data | invite_accepted: set_response}
    rsvp_form_state = RsvpFormState.accepted_response_answered(socket.assigns.rsvp_form_state, set_response)

    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("responded_gender", %{"guest-response" => value, "iter" => iter}, socket) do
    iter = String.to_integer(iter)
    individual_gender_vote = %{"first_name" => socket.assigns.response_data.gender_guesses[iter]["first_name"], "gender_guess" => value}

    gender_guesses = Map.put(socket.assigns.response_data.gender_guesses, iter, individual_gender_vote)
    response_data = %{socket.assigns.response_data | gender_guesses: gender_guesses}

    rsvp_form_state = socket.assigns.rsvp_form_state

    rsvp_form_state = case rsvp_form_state.family_vote? do
      true -> RsvpFormState.gender_answered(socket.assigns.rsvp_form_state, value)
      false -> RsvpFormState.handle_confirm_button_multi_vote(rsvp_form_state, response_data)
    end

    IO.inspect(rsvp_form_state)
    socket
    |> assign(response_data: response_data)
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("update-members", %{"n_members" => n_members}, socket) do
    rsvp_form_state = RsvpFormState.n_members_answered(socket.assigns.rsvp_form_state, n_members)

    socket
    |> assign(response_data: %{socket.assigns.response_data | n_members_accepted: n_members})
    |> assign(rsvp_form_state: rsvp_form_state)
    |> noreply()
  end

  def handle_event("save-rsvp", _params, socket) do
    response_data = socket.assigns.response_data
    guest = socket.assigns.guest
    family_vote? = socket.assigns.rsvp_form_state.family_vote?

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
               |> Enum.filter(fn x -> x == 0 or x > response_data.number_of_votes end)
        IO.inspect(keys)
        IO.inspect(response_data.number_of_votes)
        gender_guesses |> Map.drop(keys)
    end

    IO.inspect(gender_guesses)

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
