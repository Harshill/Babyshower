defmodule BabyshowerWeb.RSVPFill.Components do

  use Phoenix.Component
  import BabyshowerWeb.UIComponents

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
        <div :if={@family_vote == true}>
          <.render_family_vote_form family_vote={@family_vote} gender_guess={@response_data.gender_guesses[0]["gender_guess"]} />
        </div>
        <div :if={@family_vote == false}>
          <.render_individual_vote_form response_data={@response_data} number_of_votes={@response_data.number_of_votes} gender_guesses={@response_data.gender_guesses}/>
        </div>
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
    <form class="flex flex-col sm:flex-row gap-4 justify-center mt-3">
      <.render_boy_girl_vote gender_guess={@gender_guess} iter={0}/>
    </form>
    """
  end

  attr :number_of_votes, :integer
  attr :gender_guesses, :any

  def render_individual_vote_form(assigns) do
    ~H"""
    <form :for={number <- 1..@number_of_votes}  class="flex flex-col sm:flex-row gap-4 justify-center mt-3">
      <input
        type="text"
        id={"first_name-#{number}"}
        name={"first_name-#{number}"}
        placeholder="First Name"
        class="mt-1 block mx-auto rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        phx-change="responded_name"
        phx-value-iter={number}
        value={@gender_guesses[number]["first_name"]}
        />
      <.render_boy_girl_vote gender_guess={@gender_guesses[number]["gender_guess"]} iter={number}/>
    </form>
    <button phx-click="add_vote" class="cartoon-detail rounded-lg px-6 py-3 font-medium" > Add Vote </button>

    """
  end


  attr :gender_guess, :string
  attr :iter, :integer

  def render_boy_girl_vote(assigns) do

    ~H"""
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
    """
  end

end
