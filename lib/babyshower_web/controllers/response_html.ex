defmodule BabyshowerWeb.RsvpResponsesHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use BabyshowerWeb, :html

  embed_templates "response_html/*"
end
