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
  use Phoenix.Component

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
end
