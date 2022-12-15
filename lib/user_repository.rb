

require_relative "user"
require_relative 'user'


class UserRepository
  def all
    users = []

    sql = "SELECT id, name, username, email, password FROM users;"
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      user = User.new
      user.id = record["id"].to_i
      user.name = record["name"]
      user.username = record["username"]
      user.email = record["email"]
      user.password = record["password"]

      users << user
    end

    return users
  end

  def create(user)
    sql = "INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4);"
    result_set = DatabaseConnection.exec_params(sql, [user.name, user.username, user.email, user.password])

    return ""
  end

  def find(email)
    sql = "SELECT id, name, username, email, password FROM users WHERE email = $1;" #Not sure if this is 1 or 4
    result_set = DatabaseConnection.exec_params(sql, [email])

    if result_set.first == nil
      return "incorrect"
    else
      user = User.new
      user.id = result_set[0]["id"].to_i
      user.name = result_set[0]["name"]
      user.username = result_set[0]["username"]
      user.email = result_set[0]["email"]
      user.password = result_set[0]["password"]

      return user
    end
  end


  def sign_in(email, submitted_password)
    user = find(email)

    return nil if user.nil?

    # Compare the submitted password with the encrypted one saved in the database
    if submitted_password == user.password
      return "correct"
    else
      return "incorrect"
   end
  end
end
