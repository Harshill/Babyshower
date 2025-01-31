defmodule Babyshower.Guestlist do
  alias Babyshower.Repo
  alias Babyshower.Invitation.Guest
  alias Babyshower.Accounts.User

  import Ecto.Query

  @guest_page_size 10

  def get_harshil do
    get_guest_by_phone_number("321-333-7644")
  end

  # new guest
  def new_guest(attrs, %User{role: role}) do
    case role do
      "admin" -> create_guest(attrs)
      _ -> {:error, "You are not allowed to create a guest"}
    end
  end

  def create_guest(attrs) do
    %Guest{}
    |> Guest.changeset(attrs)
    |> Repo.insert()
  end

  def delete_guest(%Guest{} = guest, %User{role: role}) do
    case role do
      "admin" -> Repo.delete(guest)
      _ -> {:error, "You are not allowed to delete a guest"}
    end
  end

  def update_guest(%Guest{} = guest, attrs, %User{role: role}) do
    case role do
      "admin" -> update_guest(guest, attrs)
      _ -> {:error, "You are not allowed to edit a guest"}
    end
  end

  def update_guest(%Guest{} = guest, attrs) do
    guest
    |> Guest.changeset(attrs)
    |> Repo.update()
  end

  # change guest
  def guest_changeset(%Guest{} = guest, attrs) do
    Guest.changeset(guest, attrs)
  end

  @spec list_guests() :: any()
  def list_guests do
    Repo.all(Guest) |> Repo.preload(:response)
  end

  def count_guest_pages(side) do
    query = case side do
      nil -> Guest
      _ -> from g in Guest, where: g.he_side == ^side
    end
    ceil(Repo.aggregate(query, :count) / @guest_page_size)
  end

  def list_guests(page) do
    offset = @guest_page_size * (page - 1)

    Repo.all(from g in Guest, limit: @guest_page_size, offset: ^offset, preload: [:response])
  end

  def list_guest_by_id(id) do
    Repo.get(Guest, id)
  end

  def list_guest_by_first_name(first_name) do
    Repo.all(from g in Guest, where: g.first_name == ^first_name, preload: [:response])
  end

  def get_guest_by_phone_number(phone_number) do
    Repo.get_by(Guest, phone_number: phone_number) |> Repo.preload(:response)
  end

  def list_guest_by_he_side(page, he_side) do
    offset = @guest_page_size * (page - 1)
    # Also sort by created_at
    Repo.all(from g in Guest, where: g.he_side == ^he_side, order_by: [desc: g.updated_at], limit: @guest_page_size, offset: ^offset, preload: [:response])
  end

  def get_guests_by_side(side) do
    guests = case side do
      nil -> list_guests()
      _ -> Repo.all(from g in Guest, where: g.he_side == ^side, preload: [:response])
    end

    guests
  end

  def list_harshils_guests(page) do
    list_guest_by_he_side(page, :Harshil)
  end

  def list_eshangis_guests(page) do
    list_guest_by_he_side(page, :Eshangi)
  end

  def list_guests_who_responded() do
    Repo.all(from g in Guest, where: not is_nil(g.response))
  end

  def search_guests_by_name(side, query) do
    query = String.downcase(query)

    guests = get_guests_by_side(side)
    Enum.filter(guests, fn guest ->
      full_name = String.downcase(guest.first_name <> " " <> guest.last_name)
      String.contains?(full_name, query)
    end)
  end

  def search_guests_by_phone(side, query) do
    guests = get_guests_by_side(side)

    Enum.filter(guests, fn guest ->
      String.contains?(guest.phone_number, query)
    end)
  end

  # def list_guests_who_responded_yes() do
  #   Repo.all(from g in Guest, where: g.response.invite_accepted == true)
  # end

  # def list_guests_who_responded_no() do
  #   Repo.all(from g in Guest, where: g.response.invite_accepted == false)
  # end

  # def list_guests_who_responded() do
  #   Repo.all(from g in Guest, where: not is_nil(g.response))
  # end

end
