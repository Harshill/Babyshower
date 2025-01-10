# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Babyshower.Repo.insert!(%Babyshower.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Babyshower.Repo
alias Babyshower.Invitation.Guest

Repo.delete_all(Guest)

guests = [
  %{
    first_name: "Harshil",
    last_name: "Patel",
    phone_number: "321-333-7644",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Eshangi",
    last_name: "Patel",
    phone_number: "256-565-5895",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Khemil",
    last_name: "Patel",
    phone_number: "717-841-2633",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aarav",
    last_name: "Shah",
    phone_number: "555-123-4567",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Vihaan",
    last_name: "Mehta",
    phone_number: "555-234-5678",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Anaya",
    last_name: "Desai",
    phone_number: "555-345-6789",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Ishaan",
    last_name: "Reddy",
    phone_number: "555-456-7890",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Diya",
    last_name: "Joshi",
    phone_number: "555-567-8901",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aarohi",
    last_name: "Khan",
    phone_number: "555-678-9012",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rohan",
    last_name: "Singh",
    phone_number: "555-789-0123",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Saanvi",
    last_name: "Patel",
    phone_number: "555-890-1234",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kabir",
    last_name: "Gupta",
    phone_number: "555-901-2345",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Mira",
    last_name: "Sharma",
    phone_number: "555-012-3456",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aryan",
    last_name: "Verma",
    phone_number: "555-123-4568",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Leela",
    last_name: "Nair",
    phone_number: "555-234-5679",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kian",
    last_name: "Roy",
    phone_number: "555-345-6780",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Sia",
    last_name: "Das",
    phone_number: "555-456-7891",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Dev",
    last_name: "Chopra",
    phone_number: "555-567-8902",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Tara",
    last_name: "Bose",
    phone_number: "555-678-9013",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Raj",
    last_name: "Kapoor",
    phone_number: "555-789-0124",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Nina",
    last_name: "Saxena",
    phone_number: "555-890-1235",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Ayaan",
    last_name: "Mittal",
    phone_number: "555-901-2346",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Sara",
    last_name: "Kumar",
    phone_number: "555-012-3457",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Neil",
    last_name: "Patil",
    phone_number: "555-123-4569",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Maya",
    last_name: "Iyer",
    phone_number: "555-234-5670",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Vivaan",
    last_name: "Shah",
    phone_number: "555-345-6781",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Anika",
    last_name: "Rao",
    phone_number: "555-456-7892",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Riya",
    last_name: "Singh",
    phone_number: "555-567-8903",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Arjun",
    last_name: "Bhatt",
    phone_number: "555-678-9014",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Nikhil",
    last_name: "Ganguly",
    phone_number: "555-789-0125",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Diya",
    last_name: "Chatterjee",
    phone_number: "555-890-1236",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aarav",
    last_name: "Patil",
    phone_number: "555-901-2347",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Sahana",
    last_name: "Sinha",
    phone_number: "555-012-3458",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rohan",
    last_name: "Mishra",
    phone_number: "555-123-4560",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Isha",
    last_name: "Roy",
    phone_number: "555-234-5671",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Devansh",
    last_name: "Kulkarni",
    phone_number: "555-345-6782",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Tania",
    last_name: "Shetty",
    phone_number: "555-456-7893",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kunal",
    last_name: "Jain",
    phone_number: "555-567-8904",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Meera",
    last_name: "Naik",
    phone_number: "555-678-9015",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aditya",
    last_name: "Ghosh",
    phone_number: "555-789-0126",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Anjali",
    last_name: "Patel",
    phone_number: "555-890-1237",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rahul",
    last_name: "Chandra",
    phone_number: "555-901-2348",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Pooja",
    last_name: "Das",
    phone_number: "555-012-3459",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Siddharth",
    last_name: "Mukherjee",
    phone_number: "555-123-4561",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Neha",
    last_name: "Vyas",
    phone_number: "555-234-5672",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Arya",
    last_name: "Banerjee",
    phone_number: "555-345-6783",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Vikram",
    last_name: "Singh",
    phone_number: "555-456-7894",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Sonia",
    last_name: "Kulkarni",
    phone_number: "555-567-8905",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kriti",
    last_name: "Mehta",
    phone_number: "555-678-9016",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rishi",
    last_name: "Patel",
    phone_number: "555-789-0127",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aisha",
    last_name: "Roy",
    phone_number: "555-890-1238",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Neil",
    last_name: "Shah",
    phone_number: "555-901-2349",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Priya",
    last_name: "Singh",
    phone_number: "555-012-3460",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kabira",
    last_name: "Desai",
    phone_number: "555-123-4562",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rhea",
    last_name: "Nair",
    phone_number: "555-234-5673",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Vivaan",
    last_name: "Ganguly",
    phone_number: "555-345-6784",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Mira",
    last_name: "Chopra",
    phone_number: "555-456-7895",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Aditya",
    last_name: "Bose",
    phone_number: "555-567-8906",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Sana",
    last_name: "Kapoor",
    phone_number: "555-678-9017",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Rohit",
    last_name: "Saxena",
    phone_number: "555-789-0128",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Ira",
    last_name: "Mittal",
    phone_number: "555-890-1239",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Dev",
    last_name: "Sinha",
    phone_number: "555-901-2350",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Kia",
    last_name: "Mishra",
    phone_number: "555-012-3461",
    he_side: "Eshangi",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
  %{
    first_name: "Anirudh",
    last_name: "Bhatt",
    phone_number: "555-123-4563",
    he_side: "Harshil",
    invitation: %{invite_sent: false, estimated_guests: 2},
  },
]

Enum.each(guests, fn guest ->
  %Guest{}
  |> Guest.changeset(guest)
  |> Repo.insert!
end)


alias Babyshower.Accounts

# Make a simple user
user = %{
  email: "blah@example.com",
  password: "blahblahblah",
  role: "user"
}

Accounts.register_user(user)
