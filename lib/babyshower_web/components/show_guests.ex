defmodule BabyshowerWeb.GuestComponent do
  use Phoenix.Component

  attr :num_pages, :integer
  attr :page, :integer
  attr :side_selected, :string

  @spec render_pages(map()) :: Phoenix.LiveView.Rendered.t()
  def render_pages(assigns) do
    base_path = case assigns.side_selected do
      "Harshil" -> "/guests?side=Harshil"
      "Eshangi" -> "/guests?side=Eshangi"
      _ -> "/guests?"
    end

    assigns = assigns |> Map.put(:base_path, base_path)

    ~H"""
      <div :if={@num_pages > 1} class="py-4">
        <nav class="flex justify-around">
          <ul class="flex items-center -space-x-px h-10 text-base">
            <li>
              <.link
                patch={
                  if @page == 1 do
                    ""
                  else
                    @base_path <> "&page=#{@page - 1}"
                  end
                }
                class="flex items-center justify-center px-4 h-10 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700"
              >
                <span class="sr-only">Previous</span> &lsaquo;
              </.link>
            </li>
            <.page_number :for={i <- 1..@num_pages} number={i} current?={i == @page} base_path={@base_path}/>
            <li>
              <.link
                patch={
                  if @page + 1 > @num_pages do
                    ""
                  else
                    @base_path <> "&page=#{@page + 1}"
                  end
                }
                class="flex items-center justify-center px-4 h-10 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700"
              >
                <span class="sr-only">Next</span> &rsaquo;
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    """
  end

  attr :number, :any, required: true
  attr :current?, :boolean, default: false
  attr :base_path, :string, required: true

  defp page_number(assigns) do
    ~H"""
    <li>
      <.link
        patch={@base_path <> "&page=#{@number}"}
        class={[
          "flex items-center justify-center px-4 h-10 leading-tight",
          if @current? do
            "text-blue-600 border border-blue-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700"
          else
            "text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700"
          end
        ]}
      >
        <%= @number %>
      </.link>
    </li>
    """
  end
end
