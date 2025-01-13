defmodule BabyshowerWeb.RsvpFill do
  use BabyshowerWeb, :live_view

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

  attr :input_id, :string
  attr :radio_name, :string
  attr :status, :boolean
  attr :phx_click, :string
  attr :iter, :integer, default: nil
  slot :inner_block, required: true

  def binary_input_component(assigns) do
    selection_classes = %{
      selected: "bg-[#1E90FF] text-white font-bold shadow-md transform scale-105",
      unselected: "bg-white border-2 border-gray-200 text-gray-700 hover:border-[#87CEEB]",
      boy_selected: "bg-[#1E90FF] text-white font-bold shadow-md transform scale-105",
      girl_selected: "bg-[#FF69B4] text-white font-bold shadow-md transform scale-105",
      boy_unselected: "bg-white border-2 border-[#1E90FF] text-[#1E90FF] hover:bg-blue-50",
      girl_unselected: "bg-white border-2 border-[#FF69B4] text-[#FF69B4] hover:bg-pink-50"
    }

    assigns = assigns |> assign(selection_classes: selection_classes)

    ~H"""
    <input
      id={@input_id}
      name={@radio_name}
      phx-click={@phx_click}
      phx-value-guest-response={@radio_name}
      phx-value-iter={@iter}
      type="radio"
      class="hidden"
    />
    <label class={[
      cond do
        @radio_name == "boy" and @status -> @selection_classes.boy_selected
        @radio_name == "boy" -> @selection_classes.boy_unselected
        @radio_name == "girl" and @status -> @selection_classes.girl_selected
        @radio_name == "girl" -> @selection_classes.girl_unselected
        @status -> @selection_classes.selected
        true -> @selection_classes.unselected
      end,
      "cartoon-detail rounded-lg px-6 py-3 font-medium cursor-pointer transition-all duration-200"
    ]}
    for={@input_id}>{render_slot(@inner_block)}</label>
    """
  end

  attr :accepted_response, :boolean

  def render_accept_form(assigns) do
    ~H"""
    <div class="text-center mb-6">
      <h2 class="cartoon-text text-xl mb-4">Will you be attending?</h2>
      <form class="flex flex-row gap-4 justify-center">
        <.binary_input_component
          input_id={"accept-yes"}
          radio_name="yes"
          status={@accepted_response === true}
          phx_click={"responded_rsvp"}
        >Yes</.binary_input_component>

        <.binary_input_component
          input_id={"accept-no"}
          radio_name="no"
          status={@accepted_response === false}
          phx_click={"responded_rsvp"}
        >No</.binary_input_component>
      </form>
    </div>
    <div class="border-b border-gray-300 my-6"></div>
    """
  end

  attr :n_members_accepted, :integer
  attr :n_members_error, :string
  attr :error_message, :string

  def render_n_members_form(assigns) do
    ~H"""
      <div class=" text-center">
        <form phx-change="update-members" class="space-y-4">
          <label for="n_members" class="cartoon-text text-xl mb-4">Number of Members Attending</label>
          <input
            type="number"
            id="n_members"
            value={@n_members_accepted}
            name="n_members"
            min="0"
            max="20"
            class="mt-1 block w-24 mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            phx-debounce="500"
          >
          <div :if={@n_members_error} class="text-red-500 text-sm"> {@error_message} </div>
        </form>
      </div>
      <div class="border-b border-gray-300 my-6"></div>
    """
  end

  attr :show_gender_q?, :boolean
  attr :family_vote, :boolean
  attr :response_data, ResponseData

  def render_gender_vote_form(assigns) do

    guess = case assigns.family_vote do
      true -> assigns.response_data.gender_guesses[0]["gender_guess"]
      false -> nil
    end

    assigns = assigns |> assign(gender_guess: guess)

    ~H"""
    <div :if={@show_gender_q?}>

      <button class="cartoon-detail rounded-lg px-6 py-3 font-medium" phx-click="toggle-individual-vote" > {if @family_vote, do: "Individual Vote", else: "Family Vote"} </button>
      <div class="text-center">
        <h3 class="cartoon-text text-xl mb-4">Guess the gender of the baby!</h3>
        <form :if={@family_vote} class="flex flex-col sm:flex-row gap-4 justify-center mt-3">
          <.binary_input_component
            input_id={"gender-boy"}
            radio_name="boy"
            status={@gender_guess === "boy"}
            iter={0}
            phx_click={"responded_gender"}
          >
            <div class="flex items-center justify-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @gender_guess === "boy" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <circle cx="12" cy="8" r="5" stroke-width="2"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
              </svg>
              Boy
            </div>
          </.binary_input_component>
          <.binary_input_component
            input_id={"gender-girl"}
            radio_name="girl"
            status={@gender_guess === "girl"}
            phx_click={"responded_gender"}
            iter={0}
          >
            <div class="flex items-center justify-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @gender_guess === "girl" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <circle cx="12" cy="8" r="5" stroke-width="2"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M12 3c0 0 3 1 3 3s-3 3-3 3s-3-1-3-3s3-3 3-3"/>
              </svg>
              Girl
            </div>
          </.binary_input_component>
        </form>

        <div :if={@family_vote == false}>
        <form :for={number <- 1..@response_data.number_of_votes}  class="flex flex-col sm:flex-row gap-4 justify-center mt-3">
          <%= inspect(@response_data.gender_guesses[number]["first_name"]) %>
          <input
            type="text"
            id={"first_name-#{number}"}
            name={"first_name-#{number}"}
            placeholder="First Name"
            class="mt-1 block mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            phx-change="responded_name"
            phx-value-iter={number}
            value={@response_data.gender_guesses[number]["first_name"]}
            />

          <.binary_input_component
            input_id={"gender-boy-#{number}"}
            radio_name="boy"
            status={@response_data.gender_guesses[number]["gender_guess"] == "boy"}
            iter={number}
            phx_click={"responded_gender"}
          >
            <div class="flex items-center justify-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @response_data.gender_guesses[number]["gender_guess"] === "boy" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <circle cx="12" cy="8" r="5" stroke-width="2"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
              </svg>
              Boy
            </div>
          </.binary_input_component>

          <.binary_input_component
            input_id={"gender-girl-#{number}"}
            radio_name="girl"
            status={@response_data.gender_guesses[number]["gender_guess"] == "girl"}
            phx_click={"responded_gender"}
            iter={number}
          >
            <div class="flex items-center justify-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @response_data.gender_guesses[number]["gender_guess"] === "girl" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <circle cx="12" cy="8" r="5" stroke-width="2"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M12 3c0 0 3 1 3 3s-3 3-3 3s-3-1-3-3s3-3 3-3"/>
              </svg>
              Girl
            </div>
          </.binary_input_component>

        </form>
        <button phx-click="add_vote" class="cartoon-detail rounded-lg px-6 py-3 font-medium" > Add Vote </button>
        </div>


      </div>
    </div>
    """
  end

  def handle_event("responded_name", params, socket) do
    # split the target string by "-" and get the last element
    IO.inspect(params["_target"])

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
    socket
    |> assign(response_data: response_data)
    |> noreply()
  end

  def handle_event("add_vote", _params, socket) do

    response_data = %{socket.assigns.response_data | number_of_votes: socket.assigns.response_data.number_of_votes + 1}
    # individual_gender_votes = Map.put(socket.assigns.response_data.gender_guesses, number_of_votes, %{"first_name" => nil, "gender_guess" => nil})

    socket
    |> assign(response_data: response_data)
    |> noreply()
  end

  def handle_event("toggle-individual-vote", _params, socket) do
    socket
    |> assign(rsvp_form_state: %{socket.assigns.rsvp_form_state | family_vote?: !socket.assigns.rsvp_form_state.family_vote?})
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

    rsvp_form_state = RsvpFormState.gender_answered(socket.assigns.rsvp_form_state, value)

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


    gender_guesses = case family_vote? do
      true -> response_data.gender_guesses
      false -> response_data.gender_guesses |> Map.delete(0)
    end

    n_members_accepted = case response_data.invite_accepted do
      true -> response_data.n_members_accepted
      false ->  0
    end

    guest_response = %{
      invite_accepted: response_data.invite_accepted, n_members_accepted: n_members_accepted,
      gender_guesses: gender_guesses
      }

    IO.inspect(guest_response)

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
