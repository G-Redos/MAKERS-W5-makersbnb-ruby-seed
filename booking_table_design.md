# Two Tables (Many-to-Many) Design Recipe Template

_Copy this recipe template to design and create two related database tables having a Many-to-Many relationship._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORIES:


```

```
Nouns:

student_names, tags, 
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| users                | 
| spaces                 | 
| bookings              | date, confirmation, total_cost, user_id, space_id

1. Name of the first table (always plural): `students` 

    Column names: `name`

2. Name of the second table (always plural): `tags` 

    Column names: `title`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: students
id: SERIAL
name: text


Table: tags
id: SERIAL
title: text
```

## 4. Design the Many-to-Many relationship

Make sure you can answer YES to these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

```
# EXAMPLE

1. Can one tag have many students? YES
2. Can one student have many tags? YES
```

_If you would answer "No" to one of these questions, you'll probably have to implement a One-to-Many relationship, which is simpler. Use the relevant design recipe in that case._

## 5. Design the Join Table

The join table usually contains two columns, which are two foreign keys, each one linking to a record in the two other tables.

The naming convention is `table1_table2`.

```
# EXAMPLE

Join table for tables: students and tags
Join table name: students_tags
Columns: student_id, tag_id
```

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: posts_tags.sql

-- Replace the table name, columm names and types.

-- Create the first table.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  username text,
  email text,
  password text
);

-- Create the second table.
CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  t text
);

-- Create the join table.
CREATE TABLE bookings (
  user_id int,
  space_id int,
  constraint fk_post foreign key(user_id) references users(id) on delete cascade,
  constraint fk_tag foreign key(space_id) references spaces(id) on delete cascade,
  PRIMARY KEY (user_id, space_id)
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < posts_tags.sql
```

