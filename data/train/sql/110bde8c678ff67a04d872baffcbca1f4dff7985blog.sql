
CREATE TABLE blogs (
  id SERIAL PRIMARY,
  title VARCHAR(20) NOT NULL,
  persistent_nav(100) NOT NULL,
  theme REFERENCES theme id NOT NULL
);

CREATE TABLE blog_entries (
  id SERIAL PRIMARY,
  author REFERENCES user id NOT NULL,
  blog REFERENCES user id NOT NULL,
  comments REFERENCES comment id NOT NULL,
  date VARCHAR(10) NOT NULL,
  content VARCHAR(1000) NOT NULL

);


CREATE TABLE users (
  id SERIAL PRIMARY,
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(20) NOT NULL
 );

CREATE TABLE comments (
  id SERIAL PRIMARY,
  user REFERENCES user id NOT NULL,
  date
  time
  content
);

CREATE TABLE tags(

);

CREATE TABLE categories(

);

CREATE TABLE categories_posts (
  id SERIAL PRIMARY,
  blog_entry_id integer REFERENCES blog_entry (id),
  category_id integer REFERENCES categories (id)

);
