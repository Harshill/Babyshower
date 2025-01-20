# defmodule BabyshowerWeb.RsvpConfirm do
#   use BabyshowerWeb, :live_view

#   alias Babyshower.Guestlist
#   alias Babyshower.Response.GuestResponse

#   # TODO - Right now they can enter Zero as number of guests attending
# # TODO - they can also enter a negative number, and special characters like dashes in the number of guests attending

#   def mount(%{"phone_number" => phone_number}, _session, socket) do
#     guest = Guestlist.get_guest_by_phone_number(phone_number)

#     response = %GuestResponse{}
#     response_changeset = GuestResponse.changeset(response, %{gender_guesses: [%{first_name: "family"}]})

#     socket
#     |> assign(guest: guest)
#     |> assign(response: response)
#     |> assign(form: to_form(response_changeset))
#     |> assign(app_layout: false)
#     |> assign(vote_by_family: false)
#     |> ok()

#   end

#   def render(assigns) do
#     selection_classes = %{
#       boy_selected: "bg-[#1E90FF] text-white font-bold shadow-md transform scale-105",
#       girl_selected: "bg-[#FF69B4] text-white font-bold shadow-md transform scale-105",
#     }

#     assigns = Map.put(assigns, :selection_classes, selection_classes)

#     ~H"""
#     <div>
#       <div class="p-4"> <!-- Changed to p-4 for consistent outer padding -->
#         <div class="cartoon-card rounded-2xl"> <!-- Added rounded-2xl -->
#           <div class="p-4 "> <!-- Added inner padding container -->
#             <.link
#               navigate={~p"/"}
#               class="inline-flex items-center px-3 py-1.5 text-xs rounded-lg bg-white border-2 border-[#FF69B4] text-[#FF69B4] hover:bg-pink-50 transition-all duration-200 cartoon-text"
#             >
#               <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
#               </svg>
#               Re-enter Phone Number
#             </.link>
#             <h1 class="rsvp-header text-center mb-4">Welcome</h1>
#             <div class="cartoon-text text-4xl text-center">
#               {@guest.first_name <> " " <> @guest.last_name} and Family!
#             </div>

#             <div class="cartoon-info-card p-6 mt-8">
#               <.simple_form for={@form} phx-change="change" phx-submit="save-rsvp">

#               <.render_attendance_form form={@form}/>
#               <div class="border-b border-gray-300 my-6"></div>

#               <div id="n-members-input" class="hidden text-center cartoon-info-card">
#               <h2 class="cartoon-text text-xl mb-4">How many members will be attending?</h2>
#                 <input
#                 id={@form[:n_members_accepted].id}
#                 name={@form[:n_members_accepted].name}
#                 value={@form[:n_members_accepted].value}
#                 type="number"
#                 class="mt-1 block w-24 mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"

#                 />
#                 <div class="border-b border-gray-300 my-6"></div>
#               </div>

#               <div id="guest_votes" class="hidden cartoon-info-card grid justify-center space-y-4">
#                 <h3 class="cartoon-text text-xl">Guess the gender of the baby!</h3>
#                 <div :if={@vote_by_family == false}>
#                   <.render_gender_votes form={@form} first_name_hidden={true}/>
#                 </div>

#                 <%!-- <div if={@vote_by_family == true}>
#                   <.inputs_for :let={gender_guess_f} field={@form[:gender_guesses]}>
#                     <div class="flex items-center mt-4 mb-2 space-x-2">
#                       <input type="hidden" name="guest_response[gender_guesses_sort][]" value={gender_guess_f.index} />
#                       <.input :if={gender_guess_f[:first_name] != "family"} class="grow" field={gender_guess_f[:first_name]} label="First Name"/>
#                       <.input class="hidden" field={gender_guess_f[:gender_guess]} type="hidden"/>
#                       <button id={"boy-button-#{gender_guess_f.index}"}
#                         class={["cartoon-detail rounded-lg ml-2 mr-2 flex items-center justify-center gap-2", gender_guess_f.data.gender_guess == "Boy" && "boy_selected",]}
#                         name={"guest_response[gender_guesses][#{gender_guess_f.index}][gender_guess]"}
#                         type="button" value="Boy",
#                         value={gender_guess_f.data.gender_guess}
#                         phx-click={toggle_boy_button(gender_guess_f.index)}>
#                           <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#                               <circle cx="12" cy="8" r="5" stroke-width="2"/>
#                               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
#                           </svg>
#                           Boy
#                       </button>
#                       <button id={"girl-button-#{gender_guess_f.index}"}
#                         class={["cartoon-detail rounded-lg ml-2 mr-2 flex items-center justify-center gap-2", gender_guess_f.data.gender_guess == "Girl" && "girl_selected",]}
#                         name={"guest_response[gender_guesses][#{gender_guess_f.index}][gender_guess]"}
#                         type="button" value="Girl",
#                         phx-click={toggle_girl_button(gender_guess_f.index)}>
#                           <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#                             <circle cx="12" cy="8" r="5" stroke-width="2"/>
#                             <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
#                           </svg>
#                           Girl
#                       </button>
#                     </div>
#                 </.inputs_for>
#                   <div class="cartoon-info-card flex justify-center mt-8">
#                     <button name="guest_response[gender_guesses_sort][]"
#                       phx-click={JS.dispatch("change")}
#                       type="button"
#                       value="new"
#                       class="px-6 py-3 bg-gradient-to-r from-pink-400 to-blue-400 text-white font-semibold rounded-lg
#                             shadow-md hover:from-pink-500 hover:to-blue-500 focus:outline-none focus:ring-2
#                             focus:ring-pink-400 focus:ring-opacity-75 transform hover:scale-[1.02]
#                             transition-all duration-200 ease-in-out">
#                       Add More Votes
#                     </button>
#                 </div>
#               </div> --%>


#                 </div>
#               </.simple_form>
#             </div>
#           </div>
#         </div>
#       </div>
#     </div>
#     """
#   end

#   attr :form, :any
#   def render_attendance_form(assigns) do
#     ~H"""
#     <div class="grid bg-[#FFF0F5] justify-center px-6 py-3 gap-2 font-medium cursor-pointer transition-all duration-200">
#         <h2 class="cartoon-text text-xl mt-2 mb-4">Will you be attending?</h2>
#         <input id={@form[:invite_accepted].id} type="" name={@form[:invite_accepted].name} value={@form[:invite_accepted].value} />
#         <div class="flex mt-2">
#           <button id="yes-button"
#           class="cartoon-detail rounded-lg ml-2 mr-2"
#           name={"guest_response[invite_accepted]"}
#           type="button" value="true",
#           phx-click={toggle_yes_button()}>
#             Yes
#           </button>

#           <button id="no-button"
#           class="cartoon-detail rounded-lg px-6 py-3 font-medium cursor-pointer transition-all duration-200"
#           name={"guest_response[invite_accepted]"}
#           type="button" value="false",
#           phx-click={toggle_no_button()}>
#             No
#           </button>
#         </div>
#     </div>
#     """
#   end

#   attr :form, :any

#   def render_n_members_form(assigns) do
#     ~H"""
#       <h2 class="cartoon-text text-xl mb-4">How many members will be attending?</h2>
#       <input
#       id={@form[:n_members_accepted].id}
#       name={@form[:n_members_accepted].name}
#       value={@form[:n_members_accepted].value}
#       type="number"
#       class="mt-1 block w-24 mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
#       phx-change={JS.remove_class("hidden", to: "#guest_votes") |> JS.dispatch("change")}
#       />
#     """
#   end

#   attr :form, :any
#   attr :first_name_hidden, :boolean
#   def render_gender_votes(assigns) do
#     ~H"""
#     <.inputs_for :let={gender_guess_f} field={@form[:gender_guesses]}>
#       <div class="flex items-center mt-4 mb-2 space-x-2">
#         <input type="hidden" name="guest_response[gender_guesses_sort][]" value={gender_guess_f.index} />
#         <.input :if={@first_name_hidden != true}} class="grow" field={gender_guess_f[:first_name]} label="First Name"/>
#         <.input value="family" class="grow" field={gender_guess_f[:first_name]} type="hidden"/>

#         <.input class="hidden" field={gender_guess_f[:gender_guess]} value={gender_guess_f.data.gender_guess} type="hidden"/>
#         <button id={"boy-button-#{gender_guess_f.index}"}
#           class={["cartoon-detail rounded-lg ml-2 mr-2 flex items-center justify-center gap-2", gender_guess_f.data.gender_guess == "Boy" && "boy_selected",]}
#           name={"guest_response[gender_guesses][#{gender_guess_f.index}][gender_guess]"}
#           type="button" value="Boy",
#           phx-click={toggle_boy_button(gender_guess_f.index)}>
#             <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#                 <circle cx="12" cy="8" r="5" stroke-width="2"/>
#                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
#             </svg>
#             Boy
#         </button>
#         <button id={"girl-button-#{gender_guess_f.index}"}
#           class={["cartoon-detail rounded-lg ml-2 mr-2 flex items-center justify-center gap-2", gender_guess_f.data.gender_guess == "Girl" && "girl_selected",]}
#           name={"guest_response[gender_guesses][#{gender_guess_f.index}][gender_guess]"}
#           type="button" value="Girl",
#           phx-click={toggle_girl_button(gender_guess_f.index)}>
#             <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#               <circle cx="12" cy="8" r="5" stroke-width="2"/>
#               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
#             </svg>
#             Girl
#       </button>
#      </div>
#     </.inputs_for>
#     """
#   end

#   def toggle_yes_button(js \\ %JS{}) do
#     js
#     |> JS.remove_class("boy_selected", to: "#no-button")
#     |> JS.toggle_class("boy_selected")
#     |> JS.toggle_attribute({"disabled", "false", "true"})
#     |> JS.remove_attribute("disabled", to: "#no-button")
#     |> JS.remove_class("hidden", to: "#n-members-input")
#     |> JS.dispatch("change")
#   end

#   def toggle_no_button(js \\ %JS{}) do
#     js
#     |> JS.remove_class("boy_selected", to: "#yes-button")
#     |> JS.toggle_class("boy_selected")
#     |> JS.toggle_attribute({"disabled", "false", "true"})
#     |> JS.remove_attribute("disabled", to: "#yes-button")
#     |> JS.dispatch("change")

#   end


#   def toggle_boy_button(js \\ %JS{}, gender_index) do
#     js
#     |> JS.remove_class("girl_selected", to: "#girl-button-#{gender_index}")
#     |> JS.toggle_class("boy_selected")
#     |> JS.toggle_attribute({"disabled", "false", "true"})
#     |> JS.remove_attribute("disabled", to: "#girl-button-#{gender_index}")
#     |> JS.dispatch("change")
#   end

#   def toggle_girl_button(js \\ %JS{}, gender_index) do
#     js
#     |>
#     JS.remove_class("boy_selected", to: "#boy-button-#{gender_index}")
#     |> JS.toggle_class("girl_selected")
#     |> JS.toggle_attribute({"disabled", "false", "true"})
#     |> JS.remove_attribute("disabled", to: "#boy-button-#{gender_index}")
#     |> JS.dispatch("change")
#   end


#   def handle_event("change", params, socket) do
#     IO.inspect(params)
#     gender_guess_params = params["guest_response"]
#     changeset = GuestResponse.changeset(socket.assigns.response, gender_guess_params)
#     IO.inspect(changeset)
#     socket
#     |> assign(:form, to_form(changeset))
#     |> noreply()
#   end

#   attr :anyone_accepted, :boolean
#   attr :n_members_accepted, :integer
#   attr :gender_vote, :string

#   def render_confirm_button(assigns) do
#     # Show if guests are attending, number of members attending is set, and gender is voted for OR guests are not attending

#     show_condition = case assigns.anyone_accepted do
#                       true -> assigns.n_members_accepted != nil and assigns.gender_vote != nil
#                       false -> assigns.gender_vote != nil
#                       nil -> false
#                     end

#     assigns = assigns |> assign(show_condition: show_condition)

#     ~H"""
#     <div :if={@show_condition} class="mt-6 flex justify-center">
#       <button
#         phx-click="save-rsvp"
#         class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-md text-white bg-[#1E90FF] hover:bg-[#FF69B4] active:bg-[#FF69B4] transition-all duration-300" >
#         Confirm RSVP
#         <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
#           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
#         </svg>
#       </button>
#     </div>
#     """
#   end
# end
