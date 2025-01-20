defmodule BabyshowerWeb.RSVPFill.Components do

  use Phoenix.Component
  import BabyshowerWeb.UIComponents

  @doc """
  Renders the initial RSVP acceptance form with Yes/No options.
  """
  attr :accepted_response, :boolean, required: true

  def render_accept_form(assigns) do
    ~H"""
    <div class="text-center mb-6">
      <h2 class="cartoon-text text-xl mb-4">Will you be attending?</h2>
      <form class="flex flex-row gap-4 justify-center">
        <.binary_input_component
          input_id="accept-yes"
          radio_name="yes"
          status={@accepted_response === true}
          phx_click="responded_rsvp"
        >
          Yes
        </.binary_input_component>

        <.binary_input_component
          input_id="accept-no"
          radio_name="no"
          status={@accepted_response === false}
          phx_click="responded_rsvp"
        >
          No
        </.binary_input_component>
      </form>
    </div>
    <.divider />
    """
  end

  @doc """
  Renders form for specifying number of attending members.
  """
  attr :n_members_accepted, :integer, required: true
  attr :n_members_error, :string, required: true
  attr :error_message, :string, required: true

  def render_n_members_form(assigns) do
    ~H"""
    <div class="text-center">
    <h2 class="cartoon-text text-xl mb-4">How many people will attend?</h2>
      <.number_input_form
        n_members_accepted={@n_members_accepted}
        n_members_error={@n_members_error}
        error_message={@error_message}
      />
    </div>
    <.divider />
    """
  end

  defp number_input_form(assigns) do
    ~H"""
    <form phx-change="responded-n-members" class="space-y-4">
      <input
        type="number"
        id="n_members"
        value={@n_members_accepted}
        name="n_members"
        min="0"
        max="20"
        class="mt-1 block w-24 mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        phx-debounce="500"
        phx-hook="PreventLetters"
      >
      <div :if={@n_members_error} class="cartoon-text-error text-sm">
        {@error_message}
      </div>
    </form>
    """
  end

  attr :show_gender_q?, :boolean
  attr :family_vote, :boolean
  attr :response_data, ResponseData
  attr :number_of_votes, :integer

  def render_gender_vote_form(assigns) do

    guess = case assigns.family_vote do
      true -> assigns.response_data.gender_guesses[0]["gender_guess"]
      false -> nil
    end

    assigns = assigns |> assign(gender_guess: guess)

    ~H"""
    <div :if={@show_gender_q?}>

      <div class="text-center mt-6 flex flex-col">
        <h3 class="cartoon-text text-xl mb-6">Guess the gender of the baby!</h3>
        <.vote_type_toggle family_vote={@family_vote} />
      </div>
      <div :if={@family_vote}>
        <.render_family_vote_form
          family_vote={@family_vote}
          gender_guess={@response_data.gender_guesses[0]["gender_guess"]}
        />
      </div>
      <div :if={!@family_vote}>
        <.render_individual_vote_form
          number_of_votes={@number_of_votes}
          gender_guesses={@response_data.gender_guesses}
        />
      </div>
    </div>
    """
  end

  attr :family_vote, :boolean
  attr :gender_guess, :string

  def render_family_vote_form(assigns) do
    guess = case assigns.family_vote do
      true -> assigns.gender_guess
      false -> nil
    end

    assigns = assigns |> assign(gender_guess: guess)

    ~H"""
    <form class="flex rounded-b-2xl items-center flex-col sm:flex-row gap-4 justify-center border-b border-l border-r bg-white/80 backdrop-blur-sm shadow-lg p-6">
        <p class="text-sm text-gray-600" > You can vote once per family </p>
        <.render_boy_girl_vote gender_guess={@gender_guess} iter={0}/>
    </form>
    """
  end

  attr :number_of_votes, :integer
  attr :gender_guesses, :any

  def render_individual_vote_form(assigns) do
    ~H"""
    <div class="space-y-4">
      <%= for number <- 1..@number_of_votes do %>
        <.individual_vote_entry
          number={number}
          gender_guess={@gender_guesses[number]["gender_guess"]}
          first_name={@gender_guesses[number]["first_name"]}
        />
      <% end %>

      <.add_vote_button :if={@number_of_votes <= 10} />
    </div>
    """
  end


  attr :gender_guess, :string
  attr :iter, :integer

  def render_boy_girl_vote(assigns) do

    ~H"""
    <div class="flex items-center gap-2">
      <.binary_input_component
          input_id={"gender-boy-#{@iter}"}
          radio_name="boy"
          status={@gender_guess === "boy"}
          iter={@iter}
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
          input_id={"gender-girl-#{@iter}"}
          radio_name="girl"
          status={@gender_guess === "girl"}
          phx_click={"responded_gender"}
          iter={@iter}
        >
          <div class="flex items-center justify-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class={["h-5 w-5", @gender_guess === "girl" && "text-white"]} fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <circle cx="12" cy="8" r="5" stroke-width="2"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13v8M9 18h6M12 3c0 0 3 1 3 3s-3 3-3 3s-3-1-3-3s3-3 3-3"/>
            </svg>
            Girl
          </div>
        </.binary_input_component>
    </div>
    """
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

  defp divider(assigns) do
    ~H"""
    <div class="border-b border-gray-300 my-6"></div>
    """
  end

  defp vote_type_toggle(assigns) do
    ~H"""
    <nav class="flex gap-2 justify-between md:justify-start border-gray-200" aria-label="Tabs">
      <.vote_tab
        type="family"
        active={@family_vote}
        event="toggle-individual-vote"
      />
      <.vote_tab
        type="individual"
        active={!@family_vote}
        event="toggle-individual-vote"
      />
    </nav>
    """
  end

  defp vote_tab(assigns) do
    base_classes = "border-t h-10 w-30 rounded-t-2xl px-4 border-r border-l font-medium text-xs transition-all duration-200 -mb-px"
    active_classes = "bg-white text-blue-600 z-10"
    inactive_classes = "bg-gray-100 text-gray-500 hover:text-gray-700"

    assigns = assign(assigns, :classes, [
      base_classes,
      if(assigns.active, do: active_classes, else: inactive_classes)
    ])

    ~H"""
    <button
      phx-click={@event}
      class={@classes}
    >
      <%= String.capitalize(@type) %> Vote
    </button>
    """
  end

  defp individual_vote_entry(assigns) do
    ~H"""
    <form class="relative flex flex-col gap-2 items-center w-full border-b border-l border-r bg-white/80 backdrop-blur-sm shadow-lg p-6">
      <.remove_button :if={@number != 1} number={@number} />
      <.vote_header number={@number} />
      <div class="flex flex-wrap justify-center py-4 rounded-xl items-center w-full gap-4">
        <.name_input
          number={@number}
          first_name={@first_name}
        />
        <.render_boy_girl_vote
          gender_guess={@gender_guess}
          iter={@number}
        />
      </div>
    </form>
    """
  end

  defp vote_header(assigns) do
    ~H"""
    <div class="text-center w-full">
      <p class="text-sm text-gray-600 mb-2">
        <%= if @number == 1, do: "More family members can vote!", else: "Enter first name!" %>
      </p>
      <h3 class="cartoon-text text-xl">Family Member #<%= @number %></h3>
    </div>
    """
  end

  defp name_input(assigns) do
    ~H"""
    <div class="flex items-center">
      <input
        type="text"
        id={"first_name-#{@number}"}
        name={"first_name-#{@number}"}
        placeholder="First Name"
        value={@first_name}
        class="mt-1 flex-grow w-48 block rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        phx-change="responded_name"
        phx-value-iter={@number}
        phx-debounce="500"
        phx-hook="ProperFirstName"
      />
    </div>
    """
  end

  defp add_vote_button(assigns) do
    ~H"""
    <button
      phx-click="add_vote"
      class="mt-4 mx-auto flex items-center justify-center w-14 h-14 rounded-full bg-[#1E90FF] hover:bg-[#FF69B4] shadow-lg transition-all duration-300 hover:scale-110"
      aria-label="Add Vote"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-8 w-8 text-white"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 6v12M6 12h12"
        />
      </svg>
    </button>
    """
  end

  defp remove_button(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="remove_vote"
      phx-value-iter={@number}
      class="absolute -top-3 -right-3 flex items-center justify-center w-8 h-8 rounded-full bg-[#FF69B4] hover:bg-[#1E90FF] shadow-lg transition-all duration-300 hover:scale-110"
    >
      <svg xmlns="http://www.w3.org/2000/svg"
           class="h-5 w-5 text-white"
           fill="none"
           viewBox="0 0 24 24"
           stroke="currentColor">
        <path stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12" />
      </svg>
    </button>
    """
  end

end
