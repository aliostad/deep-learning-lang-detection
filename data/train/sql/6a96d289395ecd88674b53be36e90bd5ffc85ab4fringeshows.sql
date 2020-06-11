
CREATE TABLE "shows" ("id" serial8 primary key, "created_at" date, "name" varchar(255), "price" decimal);
INSERT INTO "shows" VALUES (1, '2015-08-23 20:09:41.969902', 'Le Haggis', 12.99);
INSERT INTO "shows" VALUES (2, '2015-08-23 20:09:41.972179', 'Shitfaced Shakespeare', 16.50);
INSERT INTO "shows" VALUES (3, '2015-08-23 20:09:41.972999', 'Camille O''Sullivan', 17.99);
INSERT INTO "shows" VALUES (4, '2015-08-23 20:09:41.971545', 'Game of Thrones - The Musical', 16.50);
INSERT INTO "shows" VALUES (5, '2015-08-23 20:09:41.975610', 'Paul Dabek Mischief ', 12.99);
INSERT INTO "shows" VALUES (6, '2015-08-23 20:09:41.979784', 'Joe Stilgoe: Songs on Film â€“ The Sequel', 16.50);
INSERT INTO "shows" VALUES (7, '2015-08-23 20:09:41.981653', 'Aaabeduation â€“ A Magic Show', 17.99);
INSERT INTO "shows" VALUES (8, '2015-08-23 20:09:41.983556', 'Edinburgh Royal Tattoo', 32.99);
INSERT INTO "shows" VALUES (9, '2015-08-23 20:09:41.987003', 'Best of Burlesque', 7.99);
INSERT INTO "shows" VALUES (10, '2015-08-23 20:09:41.989455', 'Two become One', 8.50);
INSERT INTO "shows" VALUES (11, '2015-08-23 20:09:41.991271', 'Urinetown', 8.50);
INSERT INTO "shows" VALUES (12, '2015-08-23 20:09:41.992358', 'Two girls, one cup of comedy', 6.00);
INSERT INTO "shows" VALUES (13, '2015-08-23 20:09:41.996721', 'Balletronics', 32.00);


CREATE TABLE "times" ("id" serial8 primary key, "time" varchar(255), "show_id" int2);
INSERT INTO "times" (time, show_id) VALUES ('13:30', 1);
INSERT INTO "times" (time, show_id) VALUES ('19:30', 2);
INSERT INTO "times" (time, show_id) VALUES ('17:15', 3);
INSERT INTO "times" (time, show_id) VALUES ('19:30', 4);
INSERT INTO "times" (time, show_id) VALUES ('12:45', 5);
INSERT INTO "times" (time, show_id) VALUES ('17:15', 6);
INSERT INTO "times" (time, show_id) VALUES ('12:45', 7);
INSERT INTO "times" (time, show_id) VALUES ('22:00', 8);
INSERT INTO "times" (time, show_id) VALUES ('19:30', 9);
INSERT INTO "times" (time, show_id) VALUES ('14:15', 10);
INSERT INTO "times" (time, show_id) VALUES ('20:00', 11);
INSERT INTO "times" (time, show_id) VALUES ('12:45', 12);
INSERT INTO "times" (time, show_id) VALUES ('20:00', 13);


CREATE TABLE "users" ("id" serial8 primary key, "name" varchar(255));
INSERT INTO "users" (name) VALUES ('Rick Henri'), ('Jay Chetty'), ('Keith Douglas');

INSERT INTO "users" (name) VALUES
('Callum Dougan'),
('Andrew Insley'),
('Daniel Gillespie'),
('Bethany Fraser'),
('Nick Ridell'),
('Evelyn Utterson'),
('Sky Su'),
('Nicholas Hill'),
('Michael McLeod'),
('Callum Hogg'),
('Chris Sloan'),
('Gary Carmichael'),
('Oscar Brooks'),
('Ross Galloway'),
('Paul MacLean'),
('Stuart Ramsay'),
('Peter Forbes'),
('Euan Walls'),
('Aine Dunphy');

CREATE TABLE "shows_users" ("id" serial8 primary key, "show_id" int8, "user_id" int8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 1);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 2);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 5);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 7);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 10);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 16);
INSERT INTO "shows_users" (show_id, user_id) VALUES (1, 17);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 4);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 6);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 7);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 11);
INSERT INTO "shows_users" (show_id, user_id) VALUES (2, 14);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 1);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 5);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 13);
INSERT INTO "shows_users" (show_id, user_id) VALUES (3, 15);
INSERT INTO "shows_users" (show_id, user_id) VALUES (4, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (4, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (4, 10);
INSERT INTO "shows_users" (show_id, user_id) VALUES (4, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (4, 14);
INSERT INTO "shows_users" (show_id, user_id) VALUES (5, 2);
INSERT INTO "shows_users" (show_id, user_id) VALUES (5, 6);
INSERT INTO "shows_users" (show_id, user_id) VALUES (5, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (5, 10);
INSERT INTO "shows_users" (show_id, user_id) VALUES (6, 11);
INSERT INTO "shows_users" (show_id, user_id) VALUES (6, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (6, 13);
INSERT INTO "shows_users" (show_id, user_id) VALUES (6, 16);
INSERT INTO "shows_users" (show_id, user_id) VALUES (6, 17);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 2);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 4);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 6);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 7);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 11);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 15);
INSERT INTO "shows_users" (show_id, user_id) VALUES (7, 17);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 1);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 5);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 10);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 14);
INSERT INTO "shows_users" (show_id, user_id) VALUES (8, 15);
INSERT INTO "shows_users" (show_id, user_id) VALUES (9, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (9, 7);
INSERT INTO "shows_users" (show_id, user_id) VALUES (9, 13);
INSERT INTO "shows_users" (show_id, user_id) VALUES (9, 17);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 1);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 2);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 14);
INSERT INTO "shows_users" (show_id, user_id) VALUES (10, 16);
INSERT INTO "shows_users" (show_id, user_id) VALUES (11, 4);
INSERT INTO "shows_users" (show_id, user_id) VALUES (11, 11);
INSERT INTO "shows_users" (show_id, user_id) VALUES (11, 10);
INSERT INTO "shows_users" (show_id, user_id) VALUES (11, 13);
INSERT INTO "shows_users" (show_id, user_id) VALUES (11, 16);
INSERT INTO "shows_users" (show_id, user_id) VALUES (12, 2);
INSERT INTO "shows_users" (show_id, user_id) VALUES (12, 4);
INSERT INTO "shows_users" (show_id, user_id) VALUES (12, 5);
INSERT INTO "shows_users" (show_id, user_id) VALUES (12, 8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (12, 11);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 1);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 3);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 6);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 8);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 9);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 12);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 15);
INSERT INTO "shows_users" (show_id, user_id) VALUES (13, 17);