use nextbook;
CREATE TABLE books (
  	isbn13 VARCHAR(100) NOT NULL ,
	title VARCHAR(255) NOT NULL ,
	author VARCHAR(100) ,
	pub_nm VARCHAR(100) ,
	link VARCHAR(255) ,
	cover_l_url VARCHAR(255) ,
	category VARCHAR(100) NOT NULL ,
	PRIMARY KEY (isbn13));
	
use nextbook;
INSERT INTO books(isbn, title, author, publisher, category)
VALUES ('978-86-6077-438-4','미래를 바꾼 아홉가지 알고리즘', '존 맥코빅 지음 / 민병교 옮김', '에이콘', '1');
	
INSERT INTO books(isbn, title, author, publisher, category)
VALUES ('978-89-8437-075-3','구해줘', '기욤 뮈소 지음 / 윤미연 옮김', '밝은세상', '2');

INSERT INTO books(isbn, title, author, publisher, category)
VALUES ('978-89-509-2629-8','생각 버리기 연습', '코이케 류노스케 지음 / 유윤환 옮김', '21세기북스', '3');

use nextbook;
CREATE TABLE read_books (
	read_book_id INT(11) NOT NULL AUTO_INCREMENT,
  	username VARCHAR(45) NOT NULL ,
	isbn13 VARCHAR(45) NOT NULL ,
	PRIMARY KEY (read_book_id),
	FOREIGN KEY (username) REFERENCES users (username),
	FOREIGN KEY (isbn13) REFERENCES books (isbn13));

use nextbook;
INSERT INTO read_books(username, isbn)
VALUES ('yongdae91@hanmail.net', '978-86-6077-438-4');

INSERT INTO read_books(username, isbn)
VALUES ('yongdae91@hanmail.net', '978-89-8437-075-3');

INSERT INTO read_books(username, isbn)
VALUES ('admin@hanmail.net', '978-89-8437-075-3');

use nextbook;
SELECT *
FROM read_books rb LEFT OUTER JOIN books b
ON rb.isdn = b.isdn
WHERE username = 'yongdae91@hanmail.net'

use nextbook;
SELECT COUNT(*) FROM nextbook.books WHERE isbn='9788984370753'

use nextbook;
SELECT COUNT(*) FROM nextbook.read_books WHERE username='yongdae91@hanmail.net' AND isbn='97889843707532'

use nextbook;
ALTER TABLE books convert to charset utf8;
ALTER TABLE read_books convert to charset utf8;

use nextbook;
DELETE  FROM nextbook.read_books WHERE username='yongdae91@hanmail.net'

