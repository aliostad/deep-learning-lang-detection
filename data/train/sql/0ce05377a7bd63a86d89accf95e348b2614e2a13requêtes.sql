--Display
set linesize 250
column email format a33
column dateDeNaissance format a15
column prenom format a10
column nom format a12
column pseudo format a10

--Joueurs : {pseudo {pk}, nom, prénom, dateDeNaissance, email, nbPartiesJouees}
CREATE TABLE Joueurs (
	pseudo VARCHAR(30),
	nom VARCHAR(50) NOT NULL,
	prenom VARCHAR(50) NOT NULL,
	dateDeNaissance DATE NOT NULL, --DATE - format YYYY-MM-DD
	email VARCHAR(80) NOT NULL,
	nbPartiesJouees INT DEFAULT 0,
	PRIMARY KEY (pseudo),
	CHECK (
		REGEXP_LIKE (pseudo,'^[A-Za-z0-9]+[A-Za-z0-9._%+-]')
		AND (REGEXP_LIKE (nom,'^[A-Za-z][A-Za-z]*$'))
		AND (REGEXP_LIKE (prenom,'^[A-Za-z][A-Za-z]*$'))
		AND (REGEXP_LIKE (email,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'))
		AND (nbPartiesJouees >= 0)
	)
);
--------------------------------------------------------------------------------
--Parties : {iDPartie {pk}, début, finie}
CREATE TABLE Parties (
	iDPartie INT,
	debut DATE DEFAULT CURRENT_DATE,
	finie NUMBER(1) DEFAULT 0,
	PRIMARY KEY (iDPartie),
	CHECK ((iDPartie >= 0) AND (finie in (0,1)))
);

--Trigger qui vérifie que l'attribut "debut" a pour valeur le jour actuel
CREATE OR REPLACE TRIGGER trg_check_dates
BEFORE INSERT ON Parties
FOR EACH ROW
BEGIN
	IF( to_date(:new.debut, 'YYYY-MM-DD') <> to_date(CURRENT_DATE, 'YYYY-MM-DD') )
	THEN
		RAISE_APPLICATION_ERROR( -20001, 
		'Invalid debut: debut must be set to the current date - value = ' || 
		to_char( to_date(:new.debut, 'YYYY-MM-DD') ) || '. Instead of ' || to_char(to_date(CURRENT_DATE, 'YYYY-MM-DD')));
		END IF;
END;
/

--------------------------------------------------------------------------------
--Vainqueurs : {iDPartie{fk,pk}, pseudo{fk} }
CREATE TABLE Vainqueurs (
	iDPartie INT,
	pseudo VARCHAR(30),
	PRIMARY KEY (iDPartie),
    FOREIGN KEY (iDPartie) REFERENCES Parties (iDPartie),
    FOREIGN KEY (pseudo) REFERENCES Joueurs (pseudo)
);

--------------------------------------------------------------------------------
--Participants : {joueur1{fk}, joueur2{fk}, iDPartie{pk, fk}, (old : iDPartie{fk, pk})
CREATE TABLE Participants (
	iDPartie INT,
	joueur1 VARCHAR(30) NOT NULL,
	joueur2 VARCHAR(30) NOT NULL,
	PRIMARY KEY (iDPartie),
    FOREIGN KEY (iDPartie) REFERENCES Parties (iDPartie),
    FOREIGN KEY (joueur1) REFERENCES Joueurs (pseudo),
    FOREIGN KEY (joueur2) REFERENCES Joueurs (pseudo),
    CHECK (
    		joueur1 <> joueur2
    	)
);
--------------------------------------------------------------------------------
--Actions : {iDPartie {fk, pk}, pseudo{pk, fk}, iDBateau{fk}, nTour {pk}, nAction{pk}, x, y, type (tir, dep), direction (rg, rd, av, ar)}
CREATE TABLE Actions (
	iDPartie INT,
	pseudo VARCHAR(30),
	iDBateau INT,
	nTour INT DEFAULT 0 ,
	nAction INT DEFAULT 0,
	x INT,
	y INT,
	type VARCHAR(3) NOT NULL,
	direction VARCHAR(2),
	PRIMARY KEY (iDPartie, pseudo, nTour, nAction),
    FOREIGN KEY (iDPartie, pseudo, iDBateau) REFERENCES Bateaux (iDPartie, pseudo, iDBateau),
	CHECK (
		nTour >= 0
		AND nAction >= 0
		AND	(x BETWEEN 0 AND 9)
    	AND (y BETWEEN 0 AND 9)
    	AND (type IN ('tir', 'dep'))
    	AND (direction IN ('rg', 'rd', 'av', 'ar'))
	)
);

--Trigger qui vérifie que les attributs x et y sont bien définis que lorsque l'attribut type vaut 'tir'
CREATE OR REPLACE TRIGGER trg_check_coherence
BEFORE INSERT OR UPDATE ON Actions
FOR EACH ROW
BEGIN
	IF(:new.type = 'tir')
	THEN
		IF(:new.x IS NULL)
		THEN
			RAISE_APPLICATION_ERROR( -20002, 'Invalid x: x must be set.');
		ELSIF(:new.y IS NULL)
		THEN
			RAISE_APPLICATION_ERROR( -20002, 'Invalid y: y must be set.');
		END IF;
	END IF;
	IF(:new.type = 'dep')
	THEN
		IF(:new.x IS NOT NULL)
		THEN
			RAISE_APPLICATION_ERROR( -20002, 'Invalid x: x must not be set.');
		ELSIF(:new.y IS NOT NULL)
		THEN
			RAISE_APPLICATION_ERROR( -20002, 'Invalid y: y must not be set.');
		END IF;
	END IF;
END;
/
--------------------------------------------------------------------------------
--Display
set linesize 250
column pseudo format a13
column orientation format a1
column orientationI format a1

--Bateaux : {iDPartie {pk,fk}, pseudo{pk, fk}, iDBateau{pk}, état, taille, x, y, orientation, xI, yI, orientationI(n,s,e,o)}
CREATE TABLE Bateaux (
	iDPartie INT,
	pseudo VARCHAR(30),
	iDBateau INT,
	etat INT NOT NULL,
	taille INT NOT NULL,
	xI INT NOT NULL,
	yI INT NOT NULL,
	orientationI CHAR NOT NULL,
	x INT,
	y INT,
	orientation CHAR,
	PRIMARY KEY (iDPartie, pseudo, iDBateau),
    FOREIGN KEY (iDPartie) REFERENCES Parties (iDPartie),
    FOREIGN KEY (pseudo) REFERENCES Joueurs (pseudo),
    CHECK(
    	(iDBateau BETWEEN 1 AND 3)
    	AND (x BETWEEN 0 AND 9)
    	AND (y BETWEEN 0 AND 9)
    	AND (xI BETWEEN 0 AND 9)
    	AND (yI BETWEEN 0 AND 9)
    	AND (etat BETWEEN 0 AND taille)
    	AND (taille IN (2,3))
    	AND (
    	((orientation = 'n' ) AND (y + taille - 1 <= 9))
    	OR ((orientation = 's' ) AND (y - taille + 1 >= 0))
    	OR ((orientation = 'e' ) AND (x + taille - 1 <= 9))
    	OR ((orientation = 'o' ) AND (x - taille + 1 >= 0))
    	)
    )
);

--Trigger qui vérifie la validité de la position des bateaux (pas de collision)
CREATE OR REPLACE TRIGGER trg_init_bateaux
BEFORE INSERT OR UPDATE ON Bateaux
FOR EACH ROW
DECLARE cnt integer;
BEGIN
	SELECT COUNT(iDBateau) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) );
	IF(cnt > 2)
	THEN
		RAISE_APPLICATION_ERROR( -20003, 'One player cannot have more than 3 boats.');
	END IF;
	SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND (y = :new.y));
	IF(cnt > 0)
	THEN
		SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND (x = :new.x));
		IF(cnt > 0)
		THEN
			RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
		END IF;
		SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND ((:new.orientation = 'e') OR (:new.orientation = 'o' )) AND (orientation = :new.orientation) AND ( ((x - :new.x > 0) AND ABS(x - :new.x) < :new.taille ) OR ((x - :new.x < 0) AND ABS(x - :new.x) < taille) ));
		IF(cnt > 0)
		THEN
			RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
		END IF;
		
		SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND (((orientation = 'o') AND (:new.orientation = 'e') AND (x - :new.x < taille + :new.taille - 1)) OR ((orientation = 'e') AND (:new.orientation = 'o') AND (:new.x - x < taille + :new.taille - 1))));
		IF(cnt > 0)
		THEN
			RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
		END IF;
	ELSE
		SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND (x = :new.x));
	IF(cnt > 0)
		THEN
			SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND ((:new.orientation = 'e') OR (:new.orientation = 'o' )) AND (orientation = :new.orientation) AND ( ((y - :new.y > 0) AND ABS(y - :new.y) < :new.taille ) OR ((y - :new.y < 0) AND ABS(y - :new.y) < taille) ));
			IF(cnt > 0)
			THEN
				RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
			END IF;
			SELECT COUNT(*) INTO cnt FROM Bateaux WHERE ((iDPartie = :new.iDPartie) AND (pseudo = :new.pseudo) AND (iDBateau <> :new.iDBateau) AND (((orientation = 'n') AND (:new.orientation = 's') AND (y - :new.y < taille + :new.taille - 1)) OR ((orientation = 's') AND (:new.orientation = 'n') AND (:new.y - y < taille + :new.taille - 1))));
			IF(cnt > 0)
			THEN
				RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
			END IF;
		ELSE
			SELECT COUNT(*) INTO cnt FROM Bateaux WHERE (
			(iDPartie = :new.iDPartie) 
			AND (pseudo = :new.pseudo) 
			AND (iDBateau <> :new.iDBateau) 
			AND (
				((orientation = 'n') AND (:new.orientation = 'o') AND (:new.y BETWEEN y AND y + taille - 1) AND (x BETWEEN :new.x - :new.taille + 1 AND :new.x))
				OR ((orientation = 's') AND (:new.orientation = 'o') AND (:new.y BETWEEN y - taille + 1 AND y) AND (x BETWEEN :new.x - :new.taille + 1 AND :new.x))
				OR ((orientation = 'n') AND (:new.orientation = 'e') AND (:new.y BETWEEN y AND y + taille - 1) AND (x BETWEEN :new.x AND :new.x + :new.taille - 1))
				OR ((orientation = 's') AND (:new.orientation = 'e') AND (:new.y BETWEEN y - taille + 1 AND y) AND (x BETWEEN :new.x AND :new.x + :new.taille - 1))
				OR ((orientation = 'o') AND (:new.orientation = 'n') AND (y BETWEEN :new.y AND :new.y + :new.taille - 1) AND (:new.x BETWEEN x - taille + 1 AND x))
				OR ((orientation = 'e') AND (:new.orientation = 'n') AND (y BETWEEN :new.y AND :new.y + :new.taille - 1) AND (:new.x BETWEEN x AND x + taille - 1))
				OR ((orientation = 'o') AND (:new.orientation = 's') AND (y BETWEEN :new.y - :new.taille + 1 AND :new.y ) AND (:new.x BETWEEN x - taille + 1 AND x))
				OR ((orientation = 'e') AND (:new.orientation = 's') AND (y BETWEEN :new.y - :new.taille + 1 AND :new.y ) AND (:new.x BETWEEN x AND x + taille - 1 ))
			));
			IF(cnt > 0)
			THEN
				RAISE_APPLICATION_ERROR( -20003, 'The new boat is colliding with an existing one.');
			END IF;
		END IF;
	END IF;
END;
/
--------------------------------------------------------------------------------
--Display
set linesize 250
column ville format a15
column nomRue format a10
column pseudo format a10

--Adresses : {pseudo{fk}, numRue, nomRue, CP, Ville}
CREATE TABLE Adresses (
	pseudo VARCHAR(30),
	numRue INT NOT NULL,
	nomRue VARCHAR(50)  NOT NULL,
	CP INT  NOT NULL,
	ville VARCHAR(50)  NOT NULL,
	PRIMARY KEY (pseudo),
	FOREIGN KEY (pseudo) REFERENCES Joueurs (pseudo),
	CHECK(
		numRue > 0
		AND REGEXP_LIKE (nomRue,'^[A-Za-z0-9]+[A-Za-z0-9._%+-]')
		AND CP BETWEEN 0 AND 1000000
		AND REGEXP_LIKE (ville,'^[A-Za-z0-9]+[A-Za-z0-9._%+-]')
		)
);
