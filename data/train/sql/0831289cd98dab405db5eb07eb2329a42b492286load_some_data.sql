--bookID|title|author|series|seriesName|bookInSeries|ISBN|pubYear|catalogingData|read|completedDate
INSERT INTO books (book_id, title, pub_year) VALUES (1, 'Hornblower and the "Hotspur"', 1962);
INSERT INTO authors (author_id, name) VALUES (1, 'C.S. Forester');
INSERT INTO series (series_id, name) VALUES (1, 'The Hornblower Series');
INSERT INTO books_authors (book_id, author_id) VALUES (1, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (1, 1, 3);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (1, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (1, '0316288993', 'TRUE');


-- 2|Lieutenant Hornblower|C.S. Forester|1|The Hornblower Saga|2|0-316-29063-7|1951||1|
INSERT INTO books (book_id, title, pub_year) VALUES (2, 'Lieutenant Hornblower', 1951);
INSERT INTO books_authors (book_id, author_id) VALUES (2, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (2, 1, 2);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (2, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (2, '0316290637', 'TRUE');

-- 3|Mr. Midshipman Hornblower|C.S. Forester|1|The Hornblower Saga|1|0-316-29060-02(HC)~0-0316-28912-4 (PB)|1948||1|
INSERT INTO books (book_id, title, pub_year) VALUES (3, 'Mr. Midshipman Hornblower', 1948);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (3, 1, 1);
INSERT INTO books_authors (book_id, author_id) VALUES (3, 1);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (3, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (3, '03162906002', 'TRUE');
INSERT INTO isbns (book_id, isbn, is_main) VALUES (3, '00316289124', 'FALSE');

-- 4|Hornblower During the Crisis|C.S. Forester|1|The Hornblower Saga|4|0-316-28915-9 (HC)~0-316-28944-2 (PB)|1950||1|
INSERT INTO books (book_id, title, pub_year) VALUES (4, 'Hornblower During the Crisis', 1950);
INSERT INTO books_authors (book_id, author_id) VALUES (4, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (4, 1, 4);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (4, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (4, '0316289159', 'TRUE');
INSERT INTO isbns (book_id, isbn, is_main) VALUES (4, '0316289442', 'TRUE');

-- 5|Admiral Hornblower in the West Indies|C.S. Forester|1|The Hornblower Saga|11|0-316-28941-8 (PB)|1957||1|
INSERT INTO books (book_id, title, pub_year) VALUES (5, 'Admiral Hornblower in the West Indies', 1957);
INSERT INTO books_authors (book_id, author_id) VALUES (5, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (5, 1, 11);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (5, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (5, '0316289418', 'TRUE');

-- 6|Lord Hornblower|C.S. Forester|1|The Hornblower Saga|10|0-316-28943-4 (PB)|1946||1|
INSERT INTO books (book_id, title, pub_year) VALUES (6, 'Lord Hornblower', 1946);
INSERT INTO books_authors (book_id, author_id) VALUES (6, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (6, 1, 10);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (6, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (6, '0316289434', 'TRUE');

-- 7|Commodore Hornblower|C.S. Forester|1|The Hornblower Saga|9|0-316-28938-8 (PB)|1945||1|
INSERT INTO books (book_id, title, pub_year) VALUES (7, 'Commodore Hornblower', 1945);
INSERT INTO books_authors (book_id, author_id) VALUES (7, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (7, 1, 9);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (7, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (7, '0316289388', 'TRUE');

-- 8|Flying Colors|C.S. Forester|1|The Hornblower Saga|8|0-316-28939-6 (PB)|1938||1|
INSERT INTO books (book_id, title, pub_year) VALUES (8, 'Flying Colors', 1938);
INSERT INTO books_authors (book_id, author_id) VALUES (8, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (8, 1, 8);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (8, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (8, '0316289396', 'TRUE');

-- 9|Ship of the Line|C.S. Forester|1|The Hornblower Saga|7|0-316-28936-1 (PB)|1938||1|
INSERT INTO books (book_id, title, pub_year) VALUES (9, 'Ship of the Line', 1938);
INSERT INTO books_authors (book_id, author_id) VALUES (9, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (9, 1, 7);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (9, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (9, '0316289361', 'TRUE');

-- 10|Hornblower and the "Atropos"|C.S. Forester|1|The Hornblower Saga|5|0-316-28911-6 (HC)~0-316-28929-9 (PB)|1953||1|
INSERT INTO books (book_id, title, pub_year) VALUES (10, 'FHornblower and the "Atropos"', 1953);
INSERT INTO books_authors (book_id, author_id) VALUES (10, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (10, 1, 5);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (10, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (10, '0316289116', 'TRUE');
INSERT INTO isbns (book_id, isbn, is_main) VALUES (10, '0316289299', 'TRUE');

-- 11|Beat to Quarters|C.S. Forester|1|The Hornblower Saga|6|0-316-28932-9 (PB)|1938||1|
INSERT INTO books (book_id, title, pub_year) VALUES (11, 'Beat to Quarters', 1938);
INSERT INTO books_authors (book_id, author_id) VALUES (11, 1);
INSERT INTO book_series (book_id, series_id, book_in_series) VALUES (11, 1, 6);
INSERT INTO books_read (book_id, was_read, date_read) VALUES (11, 'TRUE', null);
INSERT INTO isbns (book_id, isbn, is_main) VALUES (11, '0-316289329', 'TRUE');

