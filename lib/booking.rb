class Booking
  attr_accessor :id, :user_id, :space_id, :booking_date, :confirmation, :total_cost, :info

  def initialize
    @info = []
  end
end
