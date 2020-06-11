set search_path to imdb;

-- Create a view that contains the max id of the movies in the current
-- movies table. The coalesce will return 0 if the movies table was empty
create view max_id as
(
	select coalesce(max(movie_id), 0) from movies
);

-- Create a view of movies made before 1990
create view old_movies as
(
	select *
	from movies
	where year < 1990
	order by
	movie_id asc
);

-- Create a view containing the new entires that will be added
create view new_movies as
(
	select
	-- Add the current row number to the max_id to get the id
	-- for the new movie
		(select * from max_id) + (row_number() over()) as movie_id,
	-- Append sequel to the title
		m.title || ': The Sequel' as title,
	-- Set the movie year as 2020
		2020 as year,
	-- Keep the old rating
		m.rating
	from 
		old_movies m
);

-- Now insert the values
insert into movies (select * from new_movies);