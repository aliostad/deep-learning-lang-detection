#CREATE TABLE show_date (
#ID char(4),
#showtime_ID char(4),
#date char(8),
#show_attributes char(1),
#show_comments varchar(200),
#show_date char(7),
#show_festival char(1),
#show_passes char(1),
#show_sound char(1),
#show_with char(1),
#showtimes varchar(200),
#source_date datetime,
#source_country char(3)
#);

CREATE TABLE showtime (
ID char(4),
IDtimes char(1),
movie_id char(6),
movie_name varchar(200),
showtime char(5),
theater_id char(5),

show_attributes char(1),
show_comments varchar(200),
show_date datetime,
show_festival char(1),
show_passes char(1),
show_sound char(1),
show_with char(1),
showtimes varchar(200),
source_date datetime,
source_country char(3),
source_file varchar(50)
);
