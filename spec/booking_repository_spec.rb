require "booking_repository"
require "database_connection"

def reset_booking_table
  seed_sql = File.read("spec/seeds/bnb_test_tables.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do
    reset_booking_table
  end

  it "creates a booking with false confirmation" do
    repo = BookingRepository.new

    new_booking = Booking.new
    new_booking.user_id = 1
    new_booking.space_id = 3
    new_booking.booking_date = "2022/12/06"
    new_booking.confirmation = false
    new_booking.total_cost = 100

    create_booking = repo.create(new_booking)
    bookings = repo.all
    expect(bookings.length).to eq 6
    expect(bookings[5].id).to eq 6
    expect(bookings[5].user_id).to eq 1
    expect(bookings[5].space_id).to eq 3
    expect(bookings[5].confirmation).to eq "f"
  end

  it "confirms a booking by changing the confimation value to true in the db" do
    repo = BookingRepository.new
    repo.confirm(1)
    bookings = repo.all
    bookings.sort_by! { |hash| hash.id }

    expect(bookings[0].confirmation).to eq "t"
  end

  it "gives us a property name and username for a booking" do
    repo = BookingRepository.new
    result = repo.booking_info(1)
    expect(result).to eq ""
  end

  it "gives us a space id" do
    repo = BookingRepository.new
    result = repo.bookings_by_owner(1)
    expect(result).to eq ""
  end

  it "finds bookings by renter" do
    repo = BookingRepository.new
    result = repo.find_by_renter(1)
    expect(result).to eq ""
  end

  it "booking by owner" do
    repo = BookingRepository.new
    result = repo.bookings_by_owner(1)
    expect(result).to eq ""
  end
end
