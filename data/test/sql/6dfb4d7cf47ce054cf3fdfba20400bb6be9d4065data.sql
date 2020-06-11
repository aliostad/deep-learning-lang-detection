
USE capstone;

DROP TABLE STEP;
DROP TABLE NAVIGATION;
DROP TABLE BEACONS;



CREATE TABLE BEACONS(majorId INT, minorId INT, info VARCHAR(50), building VARCHAR(50), subject VARCHAR(50),PRIMARY KEY(majorId));

INSERT INTO BEACONS (majorId, minorId, info, building, subject) VALUES (9299,1234,"This cafe is so blah blah", "Kelly", "Food");
INSERT INTO BEACONS (majorId, minorId, info, building, subject) VALUES (22929,10368,"This 105 lab", "Kelly", "Room");
INSERT INTO BEACONS(majorId, minorId, info, building, subject) VALUES (0823,5678,"This is Kelly Engineering office", "Kelly", "Office");

CREATE TABLE NAVIGATION(navId INT, fromId INT, toId INT, PRIMARY KEY(navId),
						FOREIGN KEY(fromId) REFERENCES BEACONS(majorId), FOREIGN KEY(toId) REFERENCES BEACONS(majorId));
						
						

INSERT INTO NAVIGATION(navId, fromId, toId) VALUES (92991,9299, 0823);


CREATE TABLE STEP(id INT AUTO_INCREMENT, imageUrl VARCHAR(50),navId INT, majorId INT, stepNum INT, instruction VARCHAR(255), PRIMARY KEY(id), FOREIGN KEY(navId) REFERENCES NAVIGATION(navId));

INSERT INTO STEP(imageURL, navId, majorId, stepNum, instruction) VALUES ("google.com", 92991, 0, 1, "go left turn around");
