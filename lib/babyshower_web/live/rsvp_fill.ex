defmodule BabyshowerWeb.RsvpFill do
  use BabyshowerWeb, :live_view

  alias Babyshower.Guestlist
  alias Babyshower.Invitation.Response
  alias Babyshower.Invitation.Guest
  alias Babyshower.ResponseResults

  # TODO - Right now they can enter Zero as number of guests attending
# TODO - they can also enter a negative number, and special characters like dashes in the number of guests attending

  def mount(%{"phone_number" => phone_number}, _session, socket) do
    guest = Guestlist.get_guest_by_phone_number(phone_number)

    form = to_form(Guest.changeset(guest, %{}))

    response = %Response{
      phone_number: guest.phone_number, invite_accepted: nil,
      n_members_accepted: nil, gender_vote: nil
    }

    socket
    |> assign(guest: guest)
    |> assign(form: form)
    |> assign(app_layout: false)
    |> assign(response: response)

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
              class="inline-flex items-center px-3 py-1.5 text-xs rounded-lg bg-white border-2 border-[#FF69B4] text-[#FF69B4] hover:bg-pink-50 transition-all duration-200 cartoon-text"
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
                <.render_accept_form anyone_accepted={@response.invite_accepted}/>
                <.render_n_members_form anyone_accepted={@response.invite_accepted} n_members_accepted={@response.n_members_accepted}/>
                <.render_gender_vote_form anyone_accepted={@response.invite_accepted} n_members_accepted={@response.n_members_accepted} gender_vote={@response.gender_vote}/>
              </div>
              <.render_confirm_button
                anyone_accepted={@response.invite_accepted}
                n_members_accepted={@response.n_members_accepted}
                gender_vote={@response.gender_vote}
              />
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

  attr :anyone_accepted, :boolean

  def render_accept_form(assigns) do
    ~H"""
    <div class="text-center mb-6">
      <h2 class="cartoon-text text-xl mb-4">Will you be attending?</h2>
      <form class="flex flex-row gap-4 justify-center">
        <.binary_input_component
          input_id={"accept-yes"}
          radio_name="yes"
          status={@anyone_accepted === true}
          phx_click={"responded_rsvp"}
        >Yes</.binary_input_component>

        <.binary_input_component
          input_id={"accept-no"}
          radio_name="no"
          status={@anyone_accepted === false}
          phx_click={"responded_rsvp"}
        >No</.binary_input_component>
      </form>
    </div>
    <div class="border-b border-gray-300 my-6"></div>
    """
  end

  attr :anyone_accepted, :boolean
  attr :n_members_accepted, :integer
  def render_n_members_form(assigns) do
    show_condition = case assigns.anyone_accepted do
                      true -> true
                      false -> false
                      nil -> false
                      end

    assigns = assigns |> assign(show_condition: show_condition)

    ~H"""
    <div :if={@show_condition}>
      <div class=" text-center">
        <form phx-change="update-members" class="space-y-4">
          <label for="n_members" class="cartoon-text text-xl mb-4">Number of Members Attending</label>
          <input
            type="tel"
            id="n_members"
            value={@n_members_accepted}
            name="n_members"
            min="0"
            max="20"
            class="mt-1 block w-24 mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            phx-debounce="500"
          >
        </form>
      </div>
      <div class="border-b border-gray-300 my-6"></div>
    </div>
    """
  end

  attr :anyone_accepted, :boolean
  attr :n_members_accepted, :integer
  attr :gender_vote, Response

  def render_gender_vote_form(assigns) do

    show_condition = case assigns.anyone_accepted do
                      true -> assigns.n_members_accepted != nil
                      false -> true
                      nil -> false
                      end
    assigns = assigns |> assign(show_condition: show_condition)

    ~H"""
    <div :if={@show_condition} class="text-center">
      <h3 class="cartoon-text text-xl mb-4">Guess the gender of the baby!</h3>
      <form class="flex flex-col sm:flex-row gap-4 justify-center mt-3">
        <.binary_input_component
          input_id={"gender-boy"}
          radio_name="boy"
          status={@gender_vote === "boy"}
          phx_click={"responded_gender"}
        >
          <div class="flex items-center justify-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @gender_vote === "boy" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <circle cx="12" cy="8" r="5" stroke-width="2"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
            </svg>
            Boy
          </div>
        </.binary_input_component>

        <.binary_input_component
          input_id={"gender-girl"}
          radio_name="girl"
          status={@gender_vote === "girl"}
          phx_click={"responded_gender"}
        >
          <div class="flex items-center justify-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @gender_vote === "girl" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <circle cx="12" cy="8" r="5" stroke-width="2"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M12 3c0 0 3 1 3 3s-3 3-3 3s-3-1-3-3s3-3 3-3"/>
            </svg>
            Girl
          </div>
        </.binary_input_component>
      </form>
    </div>
    """
  end

  attr :anyone_accepted, :boolean
  attr :n_members_accepted, :integer
  attr :gender_vote, :string

  def render_confirm_button(assigns) do
    # Show if guests are attending, number of members attending is set, and gender is voted for OR guests are not attending

    show_condition = case assigns.anyone_accepted do
                      true -> assigns.n_members_accepted != nil and assigns.gender_vote != nil
                      false -> assigns.gender_vote != nil
                      nil -> false
                    end

    assigns = assigns |> assign(show_condition: show_condition)
    ~H"""
    <div :if={@show_condition} class="mt-6 flex justify-center">
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
    IO.inspect(value)
    set_response = case value do
      "yes" -> true
      "no" -> false
    end

    socket
    |> assign(response: %{socket.assigns.response | invite_accepted: set_response, n_members_accepted: nil, gender_vote: nil})
    |> noreply()
  end

  def handle_event("responded_gender", %{"guest-response" => value}, socket) do
    socket
    |> assign(response: %{socket.assigns.response | gender_vote: value})
    |> noreply()
  end

  def handle_event("update-members", %{"n_members" => n_members}, socket) do
    socket
    |> assign(response: %{socket.assigns.response | n_members_accepted: n_members})
    |> noreply()
  end

  def handle_event("save-rsvp", _params, socket) do
    response = socket.assigns.response
    guest = socket.assigns.guest

    n_members_accepted = case response.invite_accepted do
      true -> String.to_integer(response.n_members_accepted)
      false ->  0
    end

    guest_response = %{
      invite_accepted: response.invite_accepted, n_members_accepted: n_members_accepted,
      gender_guesses: [%{first_name: "family", gender_guess: response.gender_vote}]
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
