defmodule Babyshower.EventInfo do

  @month_map %{
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  def venue_title() do
    "Royal Albert Palace"
  end
  def event_location() do
    "1050 King George Post Rd"
  end

  def event_city() do
    "Fords"
  end

  def event_state() do
    "NJ"
  end

  def event_zip() do
    "08863"
  end

  def event_datetime() do
    Timex.to_datetime({{2026, 3, 7}, {5, 0, 0}}, "America/New_York")
  end

  @spec event_time() :: <<_::64>>
  def event_time do
    date = event_datetime()

    minute = date.minute |> Integer.to_string |> String.pad_leading(2, "0")
    hour = date.hour |> Integer.to_string

    # Add AM and PM depending on the hour
    if date.hour < 12 do
      "#{hour}:#{minute} PM"
    else
      "#{hour}:#{minute} PM"
    end
  end

  def event_date() do
    date = event_datetime()
    year = date.year
    month = Map.get(@month_map, date.month)
    day = date.day

    "#{month} #{day}, #{year}"
  end
end
