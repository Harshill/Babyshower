defmodule BabyshowerWeb.EditGuest do
  use BabyshowerWeb, :live_view

  alias Babyshower.Guestlist
  alias Babyshower.Guestlist

  def render(assigns) do
    ~H"""
    <div class="bg-gradient-to-br from-pink-50 to-blue-50 py-8">
      <div :if={@current_user.role == "admin"} class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-pink-500 to-blue-500 bg-clip-text text-transparent">
          Edit Guest Information
        </h1>

        <div class="bg-white/80 backdrop-blur-sm rounded-xl shadow-lg overflow-hidden border border-pink-100/50">
          <.simple_form for={@form} phx-change="validate" phx-submit="save" class="space-y-6 p-6">
            <div class="grid gap-6 md:grid-cols-2">
              <.input field={@form[:first_name]} type="text" label="First Name"
                class="focus:ring-pink-400 focus:border-pink-400"/>
              <.input field={@form[:last_name]} type="text" label="Last Name"
                class="focus:ring-pink-400 focus:border-pink-400"/>
            </div>
            <div class="grid gap-6 md:grid-cols-2">
              <.input field={@form[:phone_number]} type="text" label="Phone Number"
                phx-hook="FormatPhoneNumberOnInput"
                class="focus:ring-pink-400 focus:border-pink-400"/>
              <.input field={@form[:he_side]} type="text" label="Family Side"
                class="focus:ring-pink-400 focus:border-pink-400"/>
            </div>

            <:actions>
              <div class="flex justify-end space-x-3">
                <.link navigate={~p"/guests"}
                  class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200
                         transition-colors duration-200">
                  Cancel
                </.link>
                <button type="submit"
                  class="px-6 py-2 bg-gradient-to-r from-pink-400 to-blue-400 text-white
                         font-semibold rounded-lg shadow-md hover:from-pink-500 hover:to-blue-500
                         focus:outline-none focus:ring-2 focus:ring-pink-400 focus:ring-opacity-75
                         transform hover:scale-[1.02] transition-all duration-200 ease-in-out">
                  Save Changes
                </button>
              </div>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    # Get phone number from params
    phone_number = params["phone_number"]
    guest = Guestlist.get_guest_by_phone_number(phone_number)

    socket
    |> assign(:guest, guest)
    |> assign(:form, to_form(Guestlist.guest_changeset(guest, %{})))
    |> ok()
  end

  def handle_event("save", %{"guest" => guest_params}, socket) do
    case Guestlist.update_guest(socket.assigns.guest, guest_params, socket.assigns.current_user) do
      {:ok, _guest} ->
        {:noreply,
         socket
         |> put_flash(:info, "Guest updated successfully")
         |> redirect(to: ~p"/guests")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("validate", %{"guest" => guest_params}, socket) do
    changeset = Guestlist.guest_changeset(socket.assigns.guest, guest_params)

    socket
    |> assign(:form, to_form(changeset, action: :validate))
    |> noreply()
  end
end
