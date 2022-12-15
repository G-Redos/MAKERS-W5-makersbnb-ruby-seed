--use this to create your makersbnb database columns and use for makersbnb_test db too

TRUNCATE TABLE users, spaces, bookings RESTART IDENTITY;
DROP TABLE IF EXISTS "public"."bookings";
DROP TABLE IF EXISTS "public"."users";
DROP TABLE IF EXISTS "public"."spaces";


CREATE TABLE "public"."users" (
  id SERIAL PRIMARY KEY,
  name text,
  username text,
  email text,
  password text
);

-- Create the second table.
CREATE TABLE "public"."spaces" (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price int,
  user_id int
);

-- Create the join table.
CREATE TABLE "public"."bookings" (
  id SERIAL PRIMARY KEY,
  user_id int,
  space_id int,
  booking_date date,
  confirmation boolean,
  total_cost int,
  constraint fk_user foreign key(user_id) references users(id) on delete cascade,
  constraint fk_space foreign key(space_id) references spaces(id) on delete cascade
  
);