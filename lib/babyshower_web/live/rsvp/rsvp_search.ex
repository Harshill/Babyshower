defmodule BabyshowerWeb.RsvpSearch do
  use BabyshowerWeb, :live_view

  alias Babyshower.Guestlist
  alias Babyshower.Invitation.Phonenumber
  alias Babyshower.EventInfo

  def mount(_params, _session, socket) do

    event_date = EventInfo.event_date()
    event_time = EventInfo.event_time()
    event_location = EventInfo.event_location()

    socket
    |> assign(event_date: event_date)
    |> assign(event_time: event_time)
    |> assign(event_location: event_location)
    |> ok()

  end

  def handle_params(_params, _session, socket) do
    phone_number_changeset = Guestlist.phone_number_changeset(%Phonenumber{})

    socket
    |> assign(form: phone_number_form(phone_number_changeset))
    |> assign(guest: nil)
    |> assign(app_layout: true)
    |> assign(anyone_accepted: nil)
    |> noreply()
  end

  def render(assigns) do
    ~H"""
    <div class="cartoon-card mt-2 p-3">
      <div class="cartoon-info-card p-3">
        <!-- Header Section -->
        <div class="text-center">
          <h1 class="rsvp-header ">
            Find Your RSVP
          </h1>
          <p class="cartoon-text text-l text-gray-800">Enter your <span class="name-harshil italic text-lg"> phone number </span> to access your invitation</p>
        </div>

        <!-- Search Card -->
        <div class="modern-card p-2 max-w-xs mx-auto">
          <.simple_form
            for={@form}
            phx-submit="search-rsvp"
            phx-change="update"
            action={~p"/guests"}
            class="space-y-2"
          >
            <div class="flex items-center gap-1">
              <div class="flex-shrink-0">
                <svg class="h-6 w-6 text-pink-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                </svg>
              </div>
              <div class="flex-grow">
                <.input
                  field={@form[:phone_number]}
                  type="tel"
                  placeholder="321-555-1234"
                  phx-hook="FormatPhoneNumberOnInput"
                  class="cartoon-detail w-full text-sm py-1 px-2"
                  phx-debounce="500"
                />
              </div>
            </div>

            <:actions>
              <.button
                type="submit"
                phx-disable-with="Searching..."
                class="w-full rounded-xl bg-gradient-to-b from-[#1E90FF] to-[#1E90FF] text-white py-3 text-base font-extrabold hover:from-[#FF69B4] hover:to-[#FF69B4] transition-all duration-300 border-2 border-white shadow-md [text-shadow:none]"
              >
                Search RSVP
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("update", %{"RsvpSearch" => rsvp_search_params}, socket) do
    phone_number_changeset = Guestlist.phone_number_changeset(%Phonenumber{}, rsvp_search_params)

    %Phonenumber{}
    |> Guestlist.phone_number_changeset(rsvp_search_params)
    |> Map.put(:action, :validate)

    socket
    |> assign(phone_number: phone_number_changeset)
    |> assign(form: phone_number_form(phone_number_changeset))
    |> noreply()
  end

  def handle_event("search-rsvp", %{"RsvpSearch" => %{"phone_number" => phone_number}}, socket) do
    case Guestlist.get_guest_by_phone_number(phone_number) do
      nil ->
        changeset = %Phonenumber{}
        |> Guestlist.phone_number_changeset(%{phone_number: phone_number})
        |> Map.put(:action, :validate)
        |> Map.put(:errors, [phone_number: {"Phone number not found, please check the number and try again, or contact host", [validation: :required]}])

        socket
        |> assign(form: phone_number_form(changeset))
        |> noreply()

      guest -> navigate_to_guest(socket, guest)
    end
  end

  @spec phone_number_form(any()) :: map()
  def phone_number_form(phone_number_changeset) do
    to_form(phone_number_changeset, as: "RsvpSearch", id: "rsvp-search", errors: ["Error"])
  end

  def navigate_to_guest(socket, guest) do
    fill_or_show = case guest.response do
      nil -> "fill"
      _ -> "show"
    end

    socket
      |> assign(:guest, guest)
      |> push_navigate(to: ~p"/rsvp/#{guest.phone_number}/#{fill_or_show}")
      |> noreply()
  end

 end
