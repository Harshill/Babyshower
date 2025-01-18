defmodule BabyshowerWeb.RsvpSearch do
  use BabyshowerWeb, :live_view

  import BabyshowerWeb.UIComponents

  alias Babyshower.Guestlist
  alias Babyshower.Search
  alias Babyshower.Invitation.Phonenumber
  alias Babyshower.EventInfo

  def mount(_params, _session, socket) do

    event_info = %{
      date: EventInfo.event_date(),
      time: EventInfo.event_time(),
      location: EventInfo.event_location()
    }

    socket
    |> assign(event_info: event_info)
    |> ok()

  end

  def handle_params(_params, _session, socket) do
    phone_number_changeset = Search.phone_number_changeset(%{})

    socket
    |> assign(form: Search.phone_number_form(phone_number_changeset))
    |> assign(app_layout: true)
    |> noreply()
  end

  def render(assigns) do
    ~H"""
      <div class="cartoon-card mt-2 p-3">
          <.render_header />
          <.render_search form={@form} />
      </div>
    """
  end

  def render_header(assigns) do
    ~H"""
      <div class="text-center">
        <h1 class="rsvp-header">
          Find Your RSVP
        </h1>
        <p class="cartoon-text text-l text-gray-800"> Enter your <span class="name-harshil italic text-lg"> phone number </span> to access your invitation</p>
      </div>
    """
  end

  attr :form, :any

  def render_search(assigns) do
    ~H"""
      <div class="modern-card p-2 max-w-xs mx-auto">
        <.simple_form for={@form} phx-submit="search-rsvp" phx-change="validate-phone-number">
          <div class="flex items-center gap-1">
              <.phone_number_icon />
              <.phone_number_input phone_number_form_field={@form[:phone_number]}/>
          </div>

          <:actions>
            <.button type="submit" phx-disable-with="Searching..."
              class="w-full rounded-xl bg-gradient-to-b from-[#1E90FF] to-[#1E90FF] text-white py-3 text-base font-extrabold hover:from-[#FF69B4] hover:to-[#FF69B4] transition-all duration-300 border-2 border-white shadow-md [text-shadow:none]"
            >
              Search RSVP
            </.button>
          </:actions>
        </.simple_form>
      </div>
    """
  end

  def handle_event("validate-phone-number", %{"RsvpSearch" => rsvp_search_params}, socket) do
    phone_number_changeset = Search.phone_number_changeset(rsvp_search_params)

    socket
    |> assign(phone_number: phone_number_changeset)
    |> assign(form: Search.phone_number_form(phone_number_changeset))
    |> noreply()
  end

  def handle_event("search-rsvp", %{"RsvpSearch" => %{"phone_number" => phone_number}}, socket) do
    case Guestlist.get_guest_by_phone_number(phone_number) do
      nil -> handle_guest_not_found(socket, phone_number)
      guest -> navigate_to_guest(socket, guest)
    end
  end

  def handle_guest_not_found(phone_number, socket) do
    changeset = Search.phone_number_not_found_changeset(phone_number)

    socket
    |> assign(form: Search.phone_number_form(changeset))
    |> noreply()

  end

  def navigate_to_guest(socket, guest) do
    fill_or_show = case guest.response do
      nil -> "fill"
      _response -> "show"
    end

    socket
      |> push_navigate(to: ~p"/rsvp/#{guest.phone_number}/#{fill_or_show}")
      |> noreply()
  end

end
