CREATE TABLE users (name VARCHAR(255) PRIMARY KEY,
       	     	    password VARCHAR(255),
		    email VARCHAR(255),
		    capabilities VARCHAR(255),
		    UNIQUE(email));

CREATE TABLE posts (title VARCHAR(255) NOT NULL,
       	     	    author VARCHAR(255) REFERENCES users
		    	   ON UPDATE CASCADE
			   ON DELETE SET NULL,
		    body TEXT NOT NULL,
		    date TIMESTAMP NOT NULL,
		    id SERIAL PRIMARY KEY,
		    parent INTEGER REFERENCES posts
		    	   ON DELETE CASCADE,
	            thread INTEGER REFERENCES threads
		           ON DELETE CASCADE);

CREATE TABLE blog (title VARCHAR(255) NOT NULL,
       	     	  author VARCHAR(255) REFERENCES users
		  	 ON UPDATE CASCADE
			 ON DELETE SET NULL,
		  body TEXT NOT NULL,
		  date TIMESTAMP NOT NULL,
		  id SERIAL PRIMARY KEY);
			   
INSERT INTO posts (title, body, date, id)
       VALUES ('', '', '2003-8-4 23:3:0', 0);

CREATE TABLE threads (title VARCHAR(255) NOT NULL,
                      author VARCHAR(255) REFERENCES users
		      	     ON UPDATE CASCADE
			     ON DELETE SET NULL,
		      last_author VARCHAR(255) REFERENCES users
		      	     ON UPDATE CASCADE
			     ON DELETE SET NULL,
	 	      creation_date TIMESTAMP NOT NULL,
		      last_date TIMESTAMP NOT NULL,
		      id SERIAL PRIMARY KEY);
		      

CREATE VIEW newpost AS
       SELECT title, author, body, date, id, parent, thread FROM posts;

CREATE RULE newpost_insert AS ON INSERT TO newpost
       DO INSTEAD
       (INSERT INTO posts (title, author, body, date, parent, thread)
               VALUES (NEW.title,
       	       	    	  	 NEW.author,
				 NEW.body,
				 NEW.date,
				 NEW.parent,
				 NEW.thread);
        UPDATE threads SET last_author=NEW.author,
	       	       	   last_date=NEW.date
	       	       WHERE id=NEW.thread);

CREATE VIEW newthread AS
       SELECT posts.title, posts.body, posts.author, posts.date, threads.id
       	      FROM posts, threads
	      WHERE posts.thread=threads.id AND
	            posts.parent=0;

CREATE RULE newthread_insert AS ON INSERT TO newthread
       DO INSTEAD
       (INSERT INTO threads (title, author,
       	       	    	     last_author, creation_date,
			     last_date)
	       VALUES (NEW.title, NEW.author, NEW.author,
	       	       NEW.date, NEW.date);
        INSERT INTO posts (title, author, body, date, parent, thread)
	       VALUES (NEW.title, NEW.author, NEW.body, NEW.date, 0,
	       	       currval('threads_id_seq')));

; currval, nextval (table_col_seq)			   