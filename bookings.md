# {{Bookings}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `useraccounts`*

```
# EXAMPLE


```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, spaces, bookings RESTART IDENTITY;

INSERT INTO "public"."users" ("name", "username", "email", "password") VALUES
('James Beans', 'jb455', 'jbeans@gmail.com', 'password1'),
('Harrison Beef', 'beefer44', 'budweiser@budweiser.com', 'password2'),
('Quint Befton', 'hodjahorses', 'burn@queef.biz', 'password3'),
('Garrison DeSpurn', 'lilbean22', 'garyokay@yahoo.com', 'password4'),
('Donde Esther', 'quicklypeter', 'nonono@harrypotterworld.de', 'password5');


INSERT INTO "public"."spaces" ("name", "description", "price", "user_id") VALUES
('Beach House', 'House beach for five people located in the east spain', 1000, 3),
('The Brooklyn Penhouse', 'A pent house located in central brooklyn with ten rooms', 500, 1),
('Cozy Cool Cabin', 'Cabin loacted in the lake district middle of the woods', 200, 1);

INSERT INTO "public"."bookings" ("user_id", "space_id", "booking_date", "confirmation", "total_cost") VALUES
(1, 1, '2023-09-13', false, 1000),
(2, 1, '2023-12-01', false, 1000),
(3, 2, '2023-11-06', false, 500),
(4, 3, '2022-12-12', false, 500),
(5, 3, '2023-10-01', false, 200);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_accounts.rb)
class Booking
end

# Repository class
# (in lib/user_accounts_repository.rb)
class BookingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_accounts.rb)

class Booking

  # Replace the attributes by your own columns.
  attr_accessor :id, :user_id, :space_id, :booking_date, :confirmation, :total_cost
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# user_accounts = user_accounts.new
# user_accounts.name = 'Bossanova'
# user_accounts.name



```


*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
#1
# Table name: user_accounts

# Repository class
# (in lib/useraccounts_repository.rb)

class BookingRepository

  # Selecting all records
  # No arguments
  def create(booking)
   # Executes the SQL query:
  #INSERT INTO bookings (user_id, space_id, booking_date, confirmation, total_cost) VALUES ($1, $2, $3, $4, $5);

    # Returns nothing
    #sends email to owner
  end

 
  def confirm(id)
    # Executes the SQL query:

    # UPDATE bookings SET confirmation = true WHERE id = $1;

    # Returns nothing
  end


  # Add more methods below for each operation you'd like to implement.



```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

### user_account classes

# 1
# Create a booking with false confirmation
#@user_id
#@space_id = id (from current space)

repo = BookingsRepository.new

new_booking = Booking.new
new_booking.user_id = 1
new_booking.space_id = 3
new_booking.booking_date = "2022/12/06"
new_booking.confirmation = false
new_booking.total_cost = 100



create_booking = repo.create(new_booking)
bookings = repo.all
expect(bookings.length).to eq 6
bookings[5].id # =>  6
bookings[5].user_id # =>  1
bookings[5].space_id # =>  3
bookings[5].confirmation # =>  false







# 2
# confirm booking


repo = BookingRepository.new

 booking = repo.confirm(1)
 
 expect(booking[0].confirmation).to eq true





```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_accounts_repository_spec.rb

def reset_useraccounts_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe user_accountsRepository do
  before(:each) do 
    reset_useraccounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

