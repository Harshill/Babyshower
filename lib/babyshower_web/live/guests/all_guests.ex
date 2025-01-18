defmodule BabyshowerWeb.AllGuests do
  use BabyshowerWeb, :live_view

  import BabyshowerWeb.GuestComponent
  alias BabyshowerWeb.UserAuth

  alias Babyshower.Guestlist
  alias Babyshower.Invitation.Guest
  alias Babyshower.Invitation.Searchtype

  def mount(_params, _session, socket) do
    socket
    |> ok()
  end

  def handle_params(params, _session, socket) do

    side_selected = case Map.get(params, "side") do
      nil -> nil
      side -> side
    end

    page = params |> Map.get("page", "1") |> String.to_integer()

    guests = case Map.get(params, "side") do
      nil -> Guestlist.list_guests(page)
      side -> Guestlist.list_guest_by_he_side(page, side)
    end

    search_type_form = Searchtype.changeset(%Searchtype{}, %{})
    guest_changeset = Guestlist.guest_changeset(%Guest{}, %{})

    socket
    |> assign(guests: guests)
    |> assign(search_type: "name")
    |> assign(search_query: "")
    |> assign(:filtered_guests, nil)
    |> assign(:search_type_form, to_form(search_type_form))
    |> assign(:guest_form, to_form(guest_changeset))
    |> assign(:side_selected, side_selected)
    |> assign(num_pages: Guestlist.count_guest_pages(side_selected))
    |> assign(page: page)
    |> noreply()
  end

  attr :input_id, :string
  attr :radio_name, :string
  attr :status, :boolean
  attr :phx_click, :string
  slot :inner_block, required: true

  # def binary_input_component(assigns) do
  #   selection_classes = %{
  #     selected: "bg-[#1E90FF] text-white font-bold shadow-md transform scale-105",
  #     unselected: "bg-white border-2 border-gray-200 text-gray-700 hover:border-[#87CEEB]",
  #   }

  #   assigns = assigns |> assign(selection_classes: selection_classes)

  #   ~H"""
  #     <input
  #       id={@input_id}
  #       name={@radio_name}
  #       phx-click={@phx_click}
  #       phx-value-side={@radio_name}
  #       type="radio"
  #       class="hidden"
  #     />
  #     <label class={[
  #       cond do
  #         @status -> @selection_classes.selected
  #         true -> @selection_classes.unselected
  #       end,
  #       "cartoon-detail rounded-lg px-6 py-3 font-medium cursor-pointer transition-all duration-200"
  #     ]}
  #     for={@input_id}>{render_slot(@inner_block)}</label>
  #   """
  # end

  input_id={"gender-boy-#{@iter}"}
          radio_name="boy"
          status={@gender_guess === "boy"}
          iter={@iter}
          phx_click={"responded_gender"}

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-pink-50 to-blue-50 py-8 opacity-90">
      <div class="container mx-auto px-4 sm:px-6 lg:px-8">


      <.link href={~p"/users/log_out"} method="delete"
      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700">
        Log out
      </.link>

        <h1 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-pink-500 to-blue-500 bg-clip-text text-transparent">
          Guest List
        </h1>

        <.binary_input_component
          input_id="Harshil"
          radio_name="Harshil" status={@side_selected === "Harshil"} phx_click="change-side">
          Harshil
        </.binary_input_component>
        <.binary_input_component input_id="Eshangi" radio_name="Eshangi" status={@side_selected === "Eshangi"} phx_click="change-side">
          Eshangi
        </.binary_input_component>

        <div :if={@side_selected != nil and @current_user.role == "admin"} class="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
          <.simple_form for={@guest_form} phx-submit="create-guest">
            <div class="grid lg:grid-cols-5 gap-4 p-4">

              <.input field={@guest_form[:last_name]} type="text" value="patel"/>
              <.input field={@guest_form[:first_name]} type="text" placeholder="First Name"/>
              <.input field={@guest_form[:phone_number]} phx-hook="FormatPhoneNumberOnInput" type="text" placeholder="Phone Number"/>
              <.inputs_for :let={invitation_f} field={@guest_form[:invitation]}>
                <.input field={invitation_f[:estimated_guests]} type="number" phx-debounce placeholder="Estimated Guests" />
              </.inputs_for>
              <button class="px-6 py-2.5 bg-gradient-to-r from-pink-500/50 to-blue-500/50 text-white font-semibold rounded-lg
         shadow-md hover:from-pink-600 hover:to-blue-600 focus:outline-none focus:ring-2
         focus:ring-blue-400 focus:ring-opacity-75 transform hover:scale-[1.02]
         transition-all duration-200 ease-in-out" type="submit">Add</button>
            </div>
          </.simple_form>
        </div>

        <div class="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
          <.render_search_forms search_type_form={@search_type_form} search_type={@search_type}/>
        </div>

        <div class="grid grid-cols-1 gap-4">
          <div :if={@filtered_guests != nil}>
            <.render_guests_table id="filtered_Guests" guest_records={@filtered_guests} selected_side={@side_selected}/>
          </div>
          <.render_guests_table id="all_guests" guest_records={@guests} selected_side={@side_selected}/>
        </div>
      </div>
      <.render_pages num_pages={@num_pages} page={@page} side_selected={@side_selected}/>
    </div>
    """
  end

  attr :search_type_form, :any
  attr :search_type, :string

  def render_search_forms(assigns) do
    ~H"""
      <div class="p-4">
        <div class="flex flex-col sm:flex-row gap-4 items-center">
          <.simple_form for={@search_type_form} phx-change="change-search-type">
            <.input field={@search_type_form[:search_type]} type="select"
            options={["Search by Name": "name", "Search by Phone": "phone"]}/>
          </.simple_form>

          <div class="relative flex-1">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <%= if @search_type == "phone" do %>
              <input
                id="phone-search"
                phx-hook="FormatPhoneNumberOnInput"
                type="text"
                phx-keyup="search"
                phx-debounce="300"
                placeholder="Enter phone number..."
                class="pl-10 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              />
            <% else %>
              <input
                id="name-search"
                type="text"
                phx-keyup="search"
                phx-debounce="300"
                placeholder="Enter name..."
                class="pl-10 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
              />
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  def format_guest_response(nil), do: "No Response"
  def format_guest_response(%{invite_accepted: invite_accepted}) do
    case invite_accepted do
      true -> "Attending"
      false -> "Declined"
      nil -> "No Response"
    end
  end

  def format_he_side(side) do
    # Get the first letter from side
    side
    |> String.first()
    |> String.upcase()
  end

  attr :id, :string
  attr :guest_records, :list
  attr :selected_side, :string


  def render_guests_table(assigns) do
    ~H"""
      <div class="overflow-x-auto mb-10">
        <.table
          id={@id}
          rows={@guest_records}
          row_click={&JS.navigate(~p"/rsvp/#{&1.phone_number}/show?&edit=true")}
        >
            <:col :let={guest} label="Name">{guest.first_name <> " " <> guest.last_name}</:col>
            <:col :let={guest} label="Phone Number">{guest.phone_number}</:col>
            <:col :if={@selected_side == nil} :let={guest} label="Family Side">{format_he_side(guest.he_side)}</:col>
            <:col :let={guest} label="Response">{format_guest_response(guest.response)}</:col>
            <:col :let={guest} label="N Attending">{if guest.response != nil, do: guest.response.n_members_accepted, else: ""}</:col>
          </.table>
      </div>
    """
  end

  def handle_event("change-search-type", %{"searchtype" => %{"search_type" => search_type}}, socket) do
    socket
    |> assign(search_type: search_type)
    |> noreply()
  end

  def handle_event("search", %{"value" => query}, socket) do
    case query != "" do
      true -> filtered_guests = filter_guests(socket.assigns.side_selected, socket.assigns.search_type, query)
              socket
              |> assign(filtered_guests: filtered_guests)
              |> noreply()
      false -> socket
              |> assign(filtered_guests: nil)
              |> noreply()
    end
  end

  defp filter_guests(side_selected, "name", query) when byte_size(query) > 0 do
    Guestlist.search_guests_by_name(side_selected, query)
  end

  defp filter_guests(side_selected, "phone", query) when byte_size(query) > 0 do
    Guestlist.search_guests_by_phone(side_selected, query)
  end

  defp filter_guests(guests, _, _), do: guests

  def handle_event("create-guest", %{"guest" => guest_params}, socket) do
    # Take the first name and last name and capitalize the first letter
    guest_params = Map.update!(guest_params, "first_name", &String.capitalize/1)
    guest_params = Map.update!(guest_params, "last_name", &String.capitalize/1)

    guest_params = Map.put(
      guest_params,
      "invitation", %{"invite_sent" => false,
                      "estimated_guests" => guest_params["invitation"]["estimated_guests"]
                    })

    guest_params = Map.put(guest_params, "he_side", socket.assigns.side_selected)

    case Guestlist.new_guest(guest_params, socket.assigns.current_user) do
      {:ok, _guest} ->
        guests = Guestlist.list_guests()
        socket
          |> assign(guests: guests)
          |> put_flash(:info, "Guest created successfully.")
          |> push_navigate(to: "/guests?side=#{socket.assigns.side_selected}")
          |> noreply()
      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(guest_form: to_form(changeset))
        |> noreply()
    end
  end

  def handle_event("change-side", %{"side" => side}, socket) do
    socket
    |> push_navigate(to: "/guests?side=#{side}")
    |> noreply()
  end
end
