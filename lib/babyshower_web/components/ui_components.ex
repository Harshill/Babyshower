defmodule BabyshowerWeb.UIComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use BabyshowerWeb, :html
  import BabyshowerWeb.CoreComponents

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

  def phone_number_icon(assigns) do
    ~H"""
      <svg class="flex-shrink-0 h-6 w-6 text-pink-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
      </svg>
    """
  end

  attr :phone_number_form_field, :any

  def phone_number_input(assigns) do
    ~H"""
      <.input
        field={@phone_number_form_field}
        type="tel"
        placeholder="321-555-1234"
        phx-hook="FormatPhoneNumberOnInput"
        class="flex-grow cartoon-detail w-full text-sm py-1 px-2"
        phx-debounce="500"
      />
    """
  end

  attr :path, :string
  slot :inner_block, required: true

  def back_link(assigns) do
    ~H"""
      <.link navigate={@path}
        class="inline-flex items-center px-3 py-1.5 text-xs rounded-lg bg-white border-2 border-[#FF69B4]/50 text-[#FF69B4] hover:bg-pink-50 transition-all duration-200 cartoon-text"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        {render_slot(@inner_block)}
      </.link>
    """
  end

  attr :path, :string
  slot :inner_block, required: true

  def edit_link(assigns) do
    ~H"""
    <.link
        navigate={@path}
        class="inline-flex items-center px-3 py-1.5 text-xs rounded-lg bg-white border-2 border-[#1E90FF]/50 text-[#FF69B4] hover:bg-pink-50 transition-all duration-200 cartoon-text"
    >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 20h9" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16.5 3.5a2.121 2.121 0 113 3L7 19.5 3 21l1.5-4L16.5 3.5z" />
        </svg>
        {render_slot(@inner_block)}
    </.link>
    """
  end
end
