defmodule BabyshowerWeb.Icons do
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

  def attending_check_mark(assigns) do
    ~H"""
      <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" viewBox="0 0 100 100">
        <!-- Circle background -->
        <circle cx="50" cy="50" r="46" fill="#4CAF50" />

        <!-- White checkmark -->
        <path
          d="M30 50 L45 65 L70 35"
          stroke="white"
          stroke-width="8"
          stroke-linecap="round"
          stroke-linejoin="round"
          fill="none"
        />
      </svg>
    """
  end

  def declined_cross(assigns) do
    ~H"""
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    """
  end

  def boy_icon(assigns) do
    ~H"""
    """
  end
end
