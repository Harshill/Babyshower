defmodule BabyshowerWeb.UserLoginLive do
  use BabyshowerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-pink-50 to-blue-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div class="bg-white p-8 rounded-xl shadow-lg max-w-md w-full space-y-8">
        <.header class="text-center">
          <span class="text-3xl font-bold bg-gradient-to-r from-pink-500 to-blue-500 bg-clip-text text-transparent">
            Welcome Back
          </span>
          <:subtitle class="mt-2">
            <span class="text-gray-600">Don't have an account? </span>
            <span class="font-semibold text-blue-500">
              Contact Admin
            </span>
          </:subtitle>
        </.header>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore" class="space-y-6">
          <.input field={@form[:email]} type="email" label="Email" required
            class="focus:ring-blue-500 focus:border-blue-500" />
          <.input field={@form[:password]} type="password" label="Password" required
            class="focus:ring-blue-500 focus:border-blue-500" />

          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in"
                class="h-4 w-4 text-blue-500 focus:ring-blue-500 border-gray-300 rounded" />
            </div>
            <div class="text-xs">
              Forgot your password?
              <span class="font-semibold text-blue-500">
                Contact Admin
              </span>
            </div>
          </div>

          <:actions>
            <button type="submit" phx-disable-with="Logging in..."
              class="w-full px-6 py-3 bg-gradient-to-r from-pink-500/50 to-blue-500/50 text-white font-semibold rounded-lg
                shadow-md hover:from-pink-600 hover:to-blue-600 focus:outline-none focus:ring-2
                focus:ring-blue-400 focus:ring-opacity-75 transform hover:scale-[1.02]
                transition-all duration-200 ease-in-out">
              Log in <span aria-hidden="true" class="ml-2">→</span>
            </button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
