-- Use this to populate your test databse

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
(3, 2, '2023-11-06', true, 500),
(4, 3, '2022-12-12', false, 500),
(5, 3, '2023-10-01', false, 200);
