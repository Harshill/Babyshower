defmodule BabyshowerWeb.ResponseStatsComponents do
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


  attr :count_title, :string
  attr :count_to_show, :integer
  slot :inner_block, required: true

  def show_count(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-shadow">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-gray-500 text-sm font-medium"> <%= @count_title %> </h3>
        {render_slot(@inner_block)}
      </div>
      <p class="text-4xl font-bold text-gray-900"><%= @count_to_show %></p>
    </div>
    """
  end

end
