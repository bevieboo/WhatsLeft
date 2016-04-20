CREATE DATABASE whatsleft;

\c whatsleft;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(50) NOT NULL,
  password_digest VARCHAR (400) NOT NULL
);

CREATE TABLE recipes (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  difficulty VARCHAR(200),
  made_count INTEGER,
  prep_time INTEGER NOT NULL,
  cook_time INTEGER NOT NULL,
  servings INTEGER NOT NULL,
  -- ingredients VARCHAR(5000) NOT NULL,
  directions VARCHAR(5000),
  user_id INTEGER
);

CREATE TABLE ingredients (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(200) NOT NULL
  -- recipe_id INTEGER
  -- recipe2_id
);

CREATE TABLE ingredient_recipes (
  id SERIAL4 PRIMARY KEY,
  recipe_id integer,
  ingredient_id integer
  -- recipe_id INTEGER
);

ALTER TABLE users ADD img_url VARCHAR(500);
ALTER TABLE recipes ADD img_url VARCHAR(500);

DROP TABLE recipes;
DROP TABLE ingredients;
DROP TABLE ingredient_recipes;
