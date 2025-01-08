defmodule BabyshowerWeb.GenderVote do
  use BabyshowerWeb, :live_view

  alias Babyshower.Invitation.GenderVote
  def mount(_params, _session, socket) do
    params = %{}

    gender_vote_changeset = GenderVote.changeset(%GenderVote{}, params)

    socket
    |> assign(:form, to_form(gender_vote_changeset))
    |> ok()
  end

  def render(assigns) do
    selection_classes = %{
      boy_selected: "bg-[#1E90FF] text-white font-bold shadow-md transform scale-105",
      girl_selected: "bg-[#FF69B4] text-white font-bold shadow-md transform scale-105",
    }

    assigns = Map.put(assigns, :selection_classes, selection_classes)

    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-pink-50 to-blue-50 py-8">
      <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-pink-500 to-blue-500 bg-clip-text text-transparent">
          Gender Prediction
        </h1>

        <div class="bg-white/80 backdrop-blur-sm rounded-xl shadow-lg overflow-hidden border border-pink-100/50 p-6">
          <.simple_form for={@form} id="form" phx-change="change" phx-submit="submit" class="space-y-6">
            <div class="text-center mb-6">
              <.input field={@form[:gender_vote]} label="Your Prediction" class="hidden"/>
            </div>

            <div id="guest_votes" class="space-y-4">
              <.inputs_for :let={guest_vote_f} field={@form[:guest_votes]}>
                <div class="flex items-center mt-4 mb-2 space-x-2">>
                  <input type="hidden" name="gender_vote[guest_votes_sort][]" value={guest_vote_f.index} />
                  <.input class="grow" field={guest_vote_f[:first_name]} label="First Name"/>

                  <button name={"gender_vote[guest_votes][#{guest_vote_f.index}][gender_vote]"}
                  type="button" value="Boy", phx-click={JS.dispatch("change")}>
                    <div class={[
                      "flex items-center justify-center gap-2",
                      guest_vote_f[:gender_vote].value == "Boy" && @selection_classes.boy_selected,
                      "cartoon-detail rounded-lg px-6 py-3 font-medium cursor-pointer transition-all duration-200"
                      ]}>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <circle cx="12" cy="8" r="5" stroke-width="2"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
                      </svg>
                      Boy
                    </div>
                  </button>
                  <button name={"gender_vote[guest_votes][#{guest_vote_f.index}][gender_vote]"}
                   type="button" value="Girl", phx-click={JS.dispatch("change")}>
                    <div class={[
                      "flex items-center justify-center gap-2",
                      guest_vote_f[:gender_vote].value == "Girl" && @selection_classes.girl_selected,
                      "cartoon-detail rounded-lg px-6 py-3 font-medium cursor-pointer transition-all duration-200"
                      ]}>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <circle cx="12" cy="8" r="5" stroke-width="2"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M7 4l3-3h4l3 3"/>
                      </svg>
                      Girl
                    </div>
                  </button>
                </div>
              </.inputs_for>
            </div>

            <div class="flex justify-center mt-8">
              <button name="gender_vote[guest_votes_sort][]"
                phx-click={JS.dispatch("change")}
                type="button"
                value="new"
                class="px-6 py-3 bg-gradient-to-r from-pink-400 to-blue-400 text-white font-semibold rounded-lg
                       shadow-md hover:from-pink-500 hover:to-blue-500 focus:outline-none focus:ring-2
                       focus:ring-pink-400 focus:ring-opacity-75 transform hover:scale-[1.02]
                       transition-all duration-200 ease-in-out">
                Add More Votes
              </button>
            </div>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("change",  params, socket) do
    gender_vote_params = params["gender_vote"]
    changeset = GenderVote.changeset(%GenderVote{}, gender_vote_params)

    socket
    |> assign(:form, to_form(changeset))
    |> noreply()
  end
end
