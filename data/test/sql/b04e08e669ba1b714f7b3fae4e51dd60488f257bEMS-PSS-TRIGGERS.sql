USE EMS;

DELIMITER $$

/* UserInsert Triggers */

DROP TRIGGER IF EXISTS newUser$$
CREATE TRIGGER newUser
BEFORE INSERT ON User
FOR EACH ROW
    BEGIN
		DECLARE mydata INT;
		DECLARE numOfUsers INT;
		SET mydata := new.id;

		IF ( (SELECT MAX(id) FROM User) IS NULL) THEN
			SET new.id := 1;
		ELSE
			SET new.id := (SELECT MAX(id) FROM User) + 1;
		END IF;

		IF ( (SELECT COUNT(id) FROM USER WHERE (user.id = mydata)) = 0) THEN
			SET mydata := null;
		END IF;

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'User', new.id, 'username', null, new.username, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'User', new.id, 'password', null, new.password, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'User', new.id, 'securityLevel', null, new.securityLevel, 'Insert');
    END$$

DROP TRIGGER IF EXISTS updateUser$$
CREATE TRIGGER updateUser
BEFORE UPDATE ON User
FOR EACH ROW
	BEGIN
		DECLARE mydata INT;
		SET mydata := new.id;

		SET new.id := old.id;

		IF (mydata > (SELECT COUNT(id) FROM User)) THEN
			SET mydata := null;
		END IF;
		
		/* Start conditional Audit insert */

		IF (new.username != OLD.username) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'User', new.id, 'username', OLD.username, new.username, 'Update');
		END IF;

		IF (new.password != OLD.password) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'User', new.id, 'password', OLD.password, new.password, 'Update');
		END IF;

		IF (new.securityLevel != OLD.securityLevel) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'User', new.id, 'securityLevel', OLD.securityLevel, new.securityLevel, 'Update');
		END IF;
	END$$

/* Company Triggers */

DROP TRIGGER IF EXISTS newCompany$$
CREATE TRIGGER newCompany
BEFORE INSERT ON Company
FOR EACH ROW
    BEGIN
		DECLARE mydata INT;
		DECLARE numOfUsers INT;
		SET mydata := new.id;

		IF ( (SELECT MAX(id) FROM Company) IS NULL) THEN
			SET new.id := 1;
		ELSE
			SET new.id := (SELECT MAX(id) FROM Company) + 1;
		END IF;

		IF ( (SELECT COUNT(id) FROM USER WHERE (user.id = mydata)) = 0) THEN
			SET mydata := null;
		END IF;

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Company', new.id, 'corporationName', null, new.corporationName, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Company', new.id, 'dateOfIncorporation', null, new.dateOfIncorporation, 'Insert');
    END$$

DROP TRIGGER IF EXISTS updateCompany$$
CREATE TRIGGER updateCompany
BEFORE UPDATE ON Company
FOR EACH ROW
	BEGIN
		DECLARE mydata INT;
		SET mydata := new.id;

		SET new.id := old.id;

		IF (mydata > (SELECT COUNT(id) FROM User)) THEN
			SET mydata := null;
		END IF;
		
		/* Start conditional Audit insert */

		IF (new.corporationName != OLD.corporationName) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Company', new.id, 'corporationName', OLD.corporationName, new.corporationName, 'Update');
		END IF;

		IF (new.dateOfIncorporation != OLD.dateOfIncorporation) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Company', new.id, 'dateOfIncorporation', OLD.dateOfIncorporation, new.dateOfIncorporation, 'Update');
		END IF;
	END$$
    
/* Contractor Triggers */

DROP TRIGGER IF EXISTS newContractor$$
CREATE TRIGGER newContractor
BEFORE INSERT ON Contractor
FOR EACH ROW
    BEGIN
		DECLARE mydata INT;
		DECLARE numOfUsers INT;
		SET mydata := new.id;

		IF ( (SELECT MAX(id) FROM Contractor) IS NULL) THEN
			SET new.id := 1;
		ELSE
			SET new.id := (SELECT MAX(id) FROM Contractor) + 1;
		END IF;

		IF ( (SELECT COUNT(id) FROM USER WHERE (user.id = mydata)) = 0) THEN
			SET mydata := null;
		END IF;

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Contractor', new.id, 'company_id', null, new.company_id, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Contractor', new.id, 'buisnessNumber', null, new.buisnessNumber, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Contractor', new.id, 'contractStartDate', null, new.contractStartDate, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Contractor', new.id, 'contractStopDate', null, new.contractStopDate, 'Insert');
        
		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Contractor', new.id, 'fixedContractAmount', null, new.fixedContractAmount, 'Insert');
    END$$

DROP TRIGGER IF EXISTS updateContractor$$
CREATE TRIGGER updateContractor
BEFORE UPDATE ON Contractor
FOR EACH ROW
	BEGIN
		DECLARE mydata INT;
		SET mydata := new.id;

		SET new.id := old.id;

		IF (mydata > (SELECT COUNT(id) FROM User)) THEN
			SET mydata := null;
		END IF;
		
		/* Start conditional Audit insert */

		IF (new.company_id != OLD.company_id) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Contractor', new.id, 'company_id', OLD.company_id, new.company_id, 'Update');
		END IF;

		IF (new.buisnessNumber != OLD.buisnessNumber) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Contractor', new.id, 'buisnessNumber', OLD.buisnessNumber, new.buisnessNumber, 'Update');
		END IF;

		IF (new.contractStartDate != OLD.contractStartDate) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Contractor', new.id, 'contractStartDate', OLD.contractStartDate, new.contractStartDate, 'Update');
		END IF;

		IF (new.contractStopDate != OLD.contractStopDate) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Contractor', new.id, 'contractStopDate', OLD.contractStopDate, new.contractStopDate, 'Update');
		END IF;
        
		IF (new.fixedContractAmount != OLD.fixedContractAmount) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Contractor', new.id, 'fixedContractAmount', OLD.fixedContractAmount, new.fixedContractAmount, 'Update');
		END IF;
	END$$

/* Person Triggers */

DROP TRIGGER IF EXISTS newPerson$$
CREATE TRIGGER newPerson
BEFORE INSERT ON Person
FOR EACH ROW
    BEGIN
		DECLARE mydata INT;
		DECLARE numOfUsers INT;
		SET mydata := new.id;

		IF ( (SELECT MAX(id) FROM Person) IS NULL) THEN
			SET new.id := 1;
		ELSE
			SET new.id := (SELECT MAX(id) FROM Person) + 1;
		END IF;

		IF ( (SELECT COUNT(id) FROM USER WHERE (user.id = mydata)) = 0) THEN
			SET mydata := null;
		END IF;

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Person', new.id, 'firstName', null, new.firstName, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Person', new.id, 'lastName', null, new.lastName, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Person', new.id, 'SIN', null, new.SIN, 'Insert');

		INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
		(mydata, (SELECT NOW()), 'Person', new.id, 'dateOfBirth', null, new.dateOfBirth, 'Insert');
    END$$

DROP TRIGGER IF EXISTS updatePerson$$
CREATE TRIGGER updatePerson
BEFORE UPDATE ON Person
FOR EACH ROW
	BEGIN
		DECLARE mydata INT;
		SET mydata := new.id;

		SET new.id := old.id;

		IF (mydata > (SELECT COUNT(id) FROM User)) THEN
			SET mydata := null;
		END IF;
		
		/* Start conditional Audit insert */

		IF (new.firstName != OLD.firstName) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Person', new.id, 'firstName', OLD.firstName, new.firstName, 'Update');
		END IF;

		IF (new.lastName != OLD.lastName) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Person', new.id, 'lastName', OLD.lastName, new.lastName, 'Update');
		END IF;

		IF (new.SIN != OLD.SIN) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Person', new.id, 'SIN', OLD.SIN, new.SIN, 'Update');
		END IF;

		IF (new.dateOfBirth != OLD.dateOfBirth) THEN
			INSERT INTO Audit (user_id, changeTime, changedTable, recordId, changedField, oldValue, newValue, extra) VALUES 
			(mydata, (SELECT NOW()), 'Person', new.id, 'dateOfBirth', OLD.dateOfBirth, new.dateOfBirth, 'Update');
		END IF;
	END$$