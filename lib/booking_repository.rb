require_relative "booking"

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    bookings = []
    query = "SELECT * FROM bookings;"
    result = DatabaseConnection.exec_params(query, [])
    result.each do |booking|
      new_booking = Booking.new
      new_booking.id = booking["id"].to_i
      new_booking.user_id = booking["user_id"].to_i
      new_booking.space_id = booking["space_id"].to_i
      new_booking.booking_date = booking["booking_date"]
      new_booking.confirmation = booking["confirmation"]
      new_booking.total_cost = booking["total_cost"].to_i
      new_booking.info << booking_info(booking["id"])
      bookings << new_booking
    end
  end

  def find_by_renter(id) #user_id
    bookings = []
    query = "SELECT * FROM bookings WHERE id = $1;"
    params = [id]
    result = DatabaseConnection.exec_params(query, params)
    result.each do |booking|
      new_booking = Booking.new
      new_booking.id = booking["id"].to_i
      new_booking.user_id = booking["user_id"].to_i
      new_booking.space_id = booking["space_id"].to_i
      new_booking.booking_date = booking["booking_date"]
      new_booking.confirmation = booking["confirmation"]
      new_booking.total_cost = booking["total_cost"].to_i
      new_booking.info << booking_info(booking["id"])

      p new_booking.info

      bookings << new_booking
      p bookings
    end
    bookings
  end

  def bookings_by_owner(id) #user_id
    query = "SELECT id FROM spaces WHERE user_id = $1;"
    params = [id]
    space_ids = DatabaseConnection.exec_params(query, params)

    @my_bookings = []
    space_ids.each do |space_id|
      params = [space_id["id"].to_i]
      p params
      query = "SELECT * FROM bookings WHERE space_id = $1;"
      result = DatabaseConnection.exec_params(query, params)
      p result.first
      result.each do |booking|
        new_booking = Booking.new
        new_booking.id = booking["id"]
        new_booking.user_id = booking["user_id"]
        new_booking.space_id = booking["space_id"]
        new_booking.booking_date = booking["booking_date"]
        new_booking.confirmation = booking["confirmation"]
        new_booking.total_cost = booking["total_cost"]
        new_booking.info << booking_info(booking["id"])
        @my_bookings << new_booking
      end
    end
    @my_bookings
  end

  def create(booking)
    # Executes the SQL query:
    query = "INSERT INTO bookings (user_id, space_id, booking_date, confirmation, total_cost) VALUES ($1, $2, $3, $4, $5);"
    params = [booking.user_id, booking.space_id, booking.booking_date, booking.confirmation, booking.total_cost]
    result = DatabaseConnection.exec_params(query, params)

    return nil
    # Returns nothing
    #sends email to owner
  end

  def confirm(id)
    # Executes the SQL query:

    query = "UPDATE bookings SET confirmation = true WHERE id = $1;"
    params = [id]
    result = DatabaseConnection.exec_params(query, params)
    return nil
    # Returns nothing
  end

  def booking_info(id) #booking_id
    query = "SELECT space_id, user_id FROM bookings WHERE id = $1;"
    params = [id]
    id_result = DatabaseConnection.exec_params(query, params)
    params = [id_result[0]["space_id"].to_i]
    query = "SELECT name FROM spaces WHERE id = $1;"
    name_result = DatabaseConnection.exec_params(query, params)
    name = name_result[0]["name"]
    query = "SELECT username FROM users WHERE id = $1;"
    params = [id_result[0]["user_id"].to_i]
    username_result = DatabaseConnection.exec_params(query, params)
    username = username_result[0]["username"]
    return { name: name, username: username }
  end
end
