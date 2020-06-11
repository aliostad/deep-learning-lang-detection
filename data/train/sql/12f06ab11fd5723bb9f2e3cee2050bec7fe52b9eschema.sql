CREATE TABLE ShowInfo (
    show_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    director TEXT,
    musical_director TEXT,
    show_info TEXT,
    page_live_date DATETIME,
    reserve_live_date DATETIME

);

CREATE TABLE Performances (
	show_id INTEGER,
	p_id INTEGER PRIMARY KEY AUTOINCREMENT,
	date_time DATETIME,
	tickets INTEGER,
	reserves INTEGER,
	FOREIGN KEY (show_id) REFERENCES ShowInfo(show_id)
);

CREATE TABLE Attendees (
	p_id INTEGER,
	name TEXT,
	email TEXT,
	FOREIGN KEY (p_id) REFERENCES Performances(p_id)
);

CREATE TABLE Reserves (
	show_id INTEGER,
	name TEXT,
	tickets_alloted INTEGER,
	email TEXT,
	FOREIGN KEY (show_id) REFERENCES ShowInfo(show_id)
);