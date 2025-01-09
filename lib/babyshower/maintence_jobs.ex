defmodule Babyshower.Utility.MaintainanceJobs do
  use GenServer


  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work(work_type: :all)
    {:ok, state}
  end


  # -- Schedule work

  # -- Schedule work -- :all

  defp schedule_work([work_type: :all]) do
    schedule_work(work_type: :migrate_db)
  end


  # -- -- :migrate_db

  @doc """
  Reference for why need to migrate manually:
   - https://fly.io/docs/elixir/advanced-guides/sqlite3/
  """
  defp schedule_work([work_type: :migrate_db]) do
    # Runs only once

    Babyshower.Release.migrate()
  end


end
