DELETE FROM EmergencyContact

INSERT INTO EmergencyContact
SELECT ReachID,
 'Contact ' + cast(ReachID as varchar(10)), --NameOfContact varchar(50),
 cast(ABS(Checksum(NewID()) % 100000) + 1 as varchar(10)) + ' Main St.', --StreetAddress1 varchar(50),
 'Level ' + cast(ABS(Checksum(NewID()) % 2) + 1 as varchar(10)), --StreetAddress2 varchar(50),
 'Apt. ' + cast(ABS(Checksum(NewID()) % 49) + 1 as varchar(2)), --StreetAddress3 varchar(50),
 City, --City varchar(50),
 State, --State varchar(30),
 Zip, --Zip varchar(50),
 cast(ABS(Checksum(NewID()) % 8998) + 1000 as varchar(4)), --Zip4 varchar(50),
 cast(ABS(Checksum(NewID()) % 898) + 100 as varchar(3)) + cast(ABS(Checksum(NewID()) % 898) + 100 as varchar(3)) + cast(ABS(Checksum(NewID()) % 8988) + 1000 as varchar(4)), --Phone varchar(50),
 NULL --PhoneWork varchar(50)
FROM Patient

UPDATE EmergencyContact
SET PhoneWork = left(Phone, 3) + + cast(ABS(Checksum(NewID()) % 898) + 100 as varchar(3)) + cast(ABS(Checksum(NewID()) % 8988) + 1000 as varchar(4))