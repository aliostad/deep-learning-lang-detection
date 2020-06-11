CREATE TABLE evenements as (
	SELECT distinct he1.idEvenement ,
	he1.idTypeStructure,
	he1.idTypeEvenement,
	he1.idUtilisateur,
	he1.idSource,
	he1.idEvenementRecuperationTitre,
	he1.idImagePrincipale,
	he1.titre,
	he1.description,
	he1.dateDebut,
	he1.isDateDebutEnviron,
	he1.dateFin,
	he1.dateCreationEvenement, 
	he1.nbEtages,
	he1.ISMH,
	he1.MH,
	he1.numeroArchive,
	he1.parent
	FROM `historiqueEvenement` he1, historiqueEvenement he2
	
	WHERE he1.idEvenement = he2.idEvenement
	GROUP BY he1.idEvenement, he1.idHistoriqueEvenement
	HAVING he1.idHistoriqueEvenement = max(he2.idHistoriqueEvenement)

);

ALTER TABLE `evenements` ADD PRIMARY KEY ( `idEvenement` ) ;

SET SQL_MODE=NO_AUTO_VALUE_ON_ZERO;
ALTER TABLE `evenements` CHANGE `idEvenement` `idEvenement` INT( 10 ) UNSIGNED NOT NULL AUTO_INCREMENT  ;
SET SQL_MODE='';




delimiter //
CREATE TRIGGER trig_historique_evenement_update
BEFORE UPDATE ON evenements FOR EACH ROW
  BEGIN
    SET NEW.dateCreationEvenement = NOW();
    INSERT INTO historiqueEvenement
      ( idEvenement ,
	idTypeStructure,
	idTypeEvenement,
	idUtilisateur,
	idSource,
	idEvenementRecuperationTitre,
	idImagePrincipale,
	titre,
	description,
	dateDebut,
	isDateDebutEnviron,
	dateFin,
	dateCreationEvenement, 
	nbEtages,
	ISMH,
	MH,
	numeroArchive,
	parent)
    VALUES
      (
      
	NEW.idEvenement ,
	NEW.idTypeStructure,
	NEW.idTypeEvenement,
	NEW.idUtilisateur,
	NEW.idSource,
	NEW.idEvenementRecuperationTitre,
	NEW.idImagePrincipale,
	NEW.titre,
	NEW.description,
	NEW.dateDebut,
	NEW.isDateDebutEnviron,
	NEW.dateFin,
	NEW.dateCreationEvenement, 
	NEW.nbEtages,
	NEW.ISMH,
	NEW.MH,
	NEW.numeroArchive,
	NEW.parent
      );
  END;
//
delimiter ;


delimiter //
CREATE TRIGGER trig_historique_evenement_insert
AFTER INSERT ON evenements FOR EACH ROW
  BEGIN
    INSERT INTO historiqueEvenement
      ( idEvenement ,
	idTypeStructure,
	idTypeEvenement,
	idUtilisateur,
	idSource,
	idEvenementRecuperationTitre,
	idImagePrincipale,
	titre,
	description,
	dateDebut,
	isDateDebutEnviron,
	dateFin,
	dateCreationEvenement, 
	nbEtages,
	ISMH,
	MH,
	numeroArchive,
	parent)
    VALUES
      (
      
	NEW.idEvenement ,
	NEW.idTypeStructure,
	NEW.idTypeEvenement,
	NEW.idUtilisateur,
	NEW.idSource,
	NEW.idEvenementRecuperationTitre,
	NEW.idImagePrincipale,
	NEW.titre,
	NEW.description,
	NEW.dateDebut,
	NEW.isDateDebutEnviron,
	NEW.dateFin,
	NEW.dateCreationEvenement, 
	NEW.nbEtages,
	NEW.ISMH,
	NEW.MH,
	NEW.numeroArchive,
	NEW.parent
      );
  END;
//


delimiter ;