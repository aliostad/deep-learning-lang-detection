DROP DATABASE CheapoMail;
CREATE DATABASE CheapoMail;
 
use CheapoMail;

CREATE TABLE User (
    id INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    password VARCHAR(15) NOT NULL,
    username VARCHAR(15) NOT NULL,
    PRIMARY KEY(id)
    )ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;
    
CREATE TABLE Message (
    id INT NOT NULL AUTO_INCREMENT,
    body VARCHAR(3000) NOT NULL,
    subject VARCHAR(1000) NOT NULL,
    user_id INT,
    recipient_ids VARCHAR(50) NOT NULL,
    PRIMARY KEY(id)
    )ENGINE=MyISAM AUTO_INCREMENT=2000 DEFAULT CHARSET=utf8;

CREATE TABLE Message_read (
    id INT AUTO_INCREMENT,
    message_id INT,
    reader_id INT,
    date DATETIME NOT NULL,
    PRIMARY KEY(id)
    )ENGINE=MyISAM AUTO_INCREMENT=3000 DEFAULT CHARSET=utf8;
    
INSERT INTO User(firstname, lastname, password,username) VALUES('Toni-Ann','Fitzgerald','Passw0rd','tonitiffy');
INSERT INTO User(firstname, lastname, password,username) VALUES('Karah','Bowen','Passw0rd','krhbowen');
INSERT INTO User(firstname, lastname, password,username) VALUES('Damoya','Jackson','Passw0rd','damoya-jackson');


INSERT INTO Message(body, subject, user_id, recipient_ids) VALUES('Hello, how are you doing?', 'Greetings', 1000, '1001');
INSERT INTO Message_read(message_id,reader_id,date) VALUES(2000,1001, STR_TO_DATE('11/29/2014 4:30:26 PM', '%c/%e/%Y %r'));

INSERT INTO Message(body, subject, user_id, recipient_ids) VALUES('Hello, I am doing fine thank you.', 'Greetings', 1001, '1000');
INSERT INTO Message_read(message_id,reader_id,date) VALUES(2001,1000, STR_TO_DATE('11/29/2014 4:32:26 PM', '%c/%e/%Y %r'));

INSERT INTO Message(body, subject, user_id, recipient_ids) VALUES('Will you be stopping by today?', 'Greetings', 1000, '1001');
INSERT INTO Message_read(message_id,reader_id,date) VALUES(2002,1001, STR_TO_DATE('11/29/2014 4:36:26 PM', '%c/%e/%Y %r'));

INSERT INTO Message(body, subject, user_id, recipient_ids) VALUES('Yes, I will stop by on my way home from work.', 'Greetings', 1001, '1000');
INSERT INTO Message_read(message_id,reader_id,date) VALUES(2003,1000, STR_TO_DATE('11/29/2014 4:39:26 PM', '%c/%e/%Y %r'));

DELETE FROM Message WHERE id = 2002;
DELETE FROM Message_read WHERE id=3001;

SELECT * FROM Message JOIN Message_read ON message.id = Message_read.message_id WHERE message_read.reader_id = 1000 ORDER BY date;

SELECT * FROM Message JOIN Message_read ON message.id = Message_read.message_id;

SELECT * FROM Message JOIN Message_read ;

SELECT * FROM Message;
SELECT * FROM Message_read ORDER BY date;

SELECT last_insert_id() FROM Message;