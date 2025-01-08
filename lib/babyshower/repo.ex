defmodule Babyshower.Repo do
  use Ecto.Repo,
    otp_app: :babyshower,
    adapter: Ecto.Adapters.SQLite3
end
