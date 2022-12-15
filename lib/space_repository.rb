# frozen_string_literal: true

require_relative 'space'

class SpaceRepository
  def all
    spaces = []

    sql = 'SELECT * FROM spaces;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      space = Space.new
      space.id = record['id'].to_i
      space.name = record['name']
      space.description = record['description']
      space.price = record['price'].to_i
      space.user_id = record['user_id'].to_i

      spaces << space
    end

    spaces
  end

  def find(id)
    sql = 'SELECT * FROM spaces WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    space = Space.new
    space.id = result_set[0]['id'].to_i
    space.name = result_set[0]['name']
    space.description = result_set[0]['description']
    space.price = result_set[0]['price'].to_i
    space.user_id = result_set[0]['user_id'].to_i

    space
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, description, price, user_id) VALUES ($1, $2, $3, $4);'
    result_set = DatabaseConnection.exec_params(sql, [space.name, space.description, space.price, space.user_id])

    space
  end

  def update_name(space)
    sql = 'UPDATE spaces SET name = $1 WHERE id = $2'
    result_set = DatabaseConnection.exec_params(sql, [space.name, space.id])
    space
  end

  def update_description(space)
    sql = 'UPDATE spaces SET description = $1 WHERE id = $2'
    result_set = DatabaseConnection.exec_params(sql, [space.description, space.id])
    space
  end

  def update_price(space)
    sql = 'UPDATE spaces SET price = $1 WHERE id = $2'
    result_set = DatabaseConnection.exec_params(sql, [space.price, space.id])
    space
  end

   def is_available?(id)
    space = self.find(id)
     sql = 'SELECT booking_date FROM bookings WHERE space_id = $1 AND confirmation = TRUE';
     result_set = DatabaseConnection.exec_params(sql, [id])
     result_set.each do |date|
      space.dates << date['booking_date']
     end
     return space
   end
end