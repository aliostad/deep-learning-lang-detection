INSERT INTO CategoryModel VALUES (1,'Fruit',2);
INSERT INTO CategoryModel VALUES (2,'Books',2);
INSERT INTO CategoryModel VALUES (3,'Films',2);
INSERT INTO CategoryModel VALUES (4,'CD-ROMs',2);
INSERT INTO CategoryModel VALUES (5,'Headsets',2);
INSERT INTO CategoryModel VALUES (6,'Tools',2);
INSERT INTO CategoryModel VALUES (7,'Locomotives',2);

INSERT INTO UserModel (email, address1, address2, dob, firstname, lastname, password, postcode, rights, telephone, town) VALUES ('cmon@letsgo.com','TORSGATAN 44','C/O Nonsense','2012-02-01','Tom','Whitemore','password','14462',0,'0704596049','Stockholm');
INSERT INTO UserModel (email, address1, address2, dob, firstname, lastname, password, postcode, rights, telephone, town)  VALUES ('lefi@1337.se','Bergvägen 4','C/O ','Bergvägen 4','Sam','Bobson','Test','14462',0,'0704596049','Stockholm');
INSERT INTO UserModel (email, address1, address2, dob, firstname, lastname, password, postcode, rights, telephone, town)  VALUES ('Persson@persson.se','Strandvägen 2','','1943-08-12','Olle','Persson','ollerockz','14462',0,'0703487564','Stockholm');
INSERT INTO UserModel (email, address1, address2, dob, firstname, lastname, password, postcode, rights, telephone, town)  VALUES ('viktor.soderstrom@live.se','Säterstigen 13','','1942-02-01','Viktor','Söderström','okok007','14462',0,'0703209874','Rönninge');
INSERT INTO UserModel (email, address1, address2, dob, firstname, lastname, password, postcode, rights, telephone, town)  VALUES ('admin','n/a','n/a','n/a','n/a','n/a','admin','n/a',1,'n/a','n/a');

INSERT INTO ProductModel VALUES (1,40,'Small round fruit, tasty. Both green and red in color.','http://www.sprayitaway.com/wp-content/uploads/2013/08/apple_by_grv422-d5554a4.jpg', true,'Apple' ,2,20,35);
INSERT INTO ProductModel VALUES (2,22,'Small round fruit, tasty. Only comes in orange, as the name suggests','http://www.plitka.eu/published/publicdata/PLITKAT/attachments/SC/products_pictures/plitka-tile-EU-SP2-Navarti-Ceramica-Golf-Orange-450-450-434-425-.jpg', true,'Orange',2,20,0);
INSERT INTO ProductModel VALUES (3,10,'Small pear-shaped fruit, tasty. Comes in many colors including red, black and yellow.', 'http://www.visitrockypoint.com/wp-content/uploads/2014/01/pear_1.jpg', true,'Pear',2,20,90);
INSERT INTO ProductModel VALUES (4,35,'A hammer is used to hammer stuff.','http://www.pachd.com/free-images/household-images/hammer-01.jpg', true,'Hammer',2,20,10);
INSERT INTO ProductModel VALUES (5,15,'Not the drink.', 'http://3.bp.blogspot.com/-YJ5K4CJRCK0/UaNezxzHodI/AAAAAAAAIzg/XKQdQkJQGa4/s1600/Harvey+wallbanger.jpg', true, 'Screwdriver',2,20,52);
INSERT INTO ProductModel VALUES (6,1000,'In other words, a train','http://upload.wikimedia.org/wikipedia/commons/9/95/M62_diesel_locomotive_from_Luninets_depot.jpg', true,'Locomotive',2,20,2);

INSERT INTO ProductModel_CategoryModel VALUES (1,1);
INSERT INTO ProductModel_CategoryModel VALUES (2,1);
INSERT INTO ProductModel_CategoryModel VALUES (2,4);
INSERT INTO ProductModel_CategoryModel VALUES (2,5);
INSERT INTO ProductModel_CategoryModel VALUES (3,1);
INSERT INTO ProductModel_CategoryModel VALUES (3,4);
INSERT INTO ProductModel_CategoryModel VALUES (3,2);
INSERT INTO ProductModel_CategoryModel VALUES (4,6);
INSERT INTO ProductModel_CategoryModel VALUES (5,6);
INSERT INTO ProductModel_CategoryModel VALUES (5,3);
INSERT INTO ProductModel_CategoryModel VALUES (6,7);

