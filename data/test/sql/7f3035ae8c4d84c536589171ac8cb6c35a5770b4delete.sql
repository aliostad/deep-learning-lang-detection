/**
 * Projet BDD
 * Base de donnée de la NSA
 *
 * @author : Olivia Bruce
 * @author : Matthieu Riou
 * @author : Brice Thomas
 */


/* Suppression des Trigger */
DROP TRIGGER cookie;
DROP TRIGGER terroriste;
DROP TRIGGER mail_free_ajout;
DROP TRIGGER mail_orange_ajout;
DROP TRIGGER mail_laposte_ajout;
DROP TRIGGER telephone_sfr_ajout;
DROP TRIGGER telephone_free_ajout;
DROP TRIGGER telephone_orange_ajout;
DROP TRIGGER telephone_bouygues_ajout;
DROP TRIGGER telephone_numericable_ajout;

/* Suppression des Vues*/

DROP VIEW fbi_view;
DROP VIEW i_hack_you_view;
DROP VIEW mail_free_view;
DROP VIEW mail_orange_view;
DROP VIEW mail_laposte_view;
DROP VIEW telephone_sfr_view;
DROP VIEW telephone_free_view;
DROP VIEW telephone_orange_view;
DROP VIEW telephone_bouygues_view;
DROP VIEW telephone_numericable_view;

/* Suppression des Roles */
DROP ROLE NSA;
DROP ROLE FBI;
DROP ROLE FREE;
DROP ROLE ORANGE;
DROP ROLE LAPOSTE;
DROP ROLE SFR;
DROP ROLE BOUYGUES;
DROP ROLE NUMERICABLE;

/* Suppression des Procedure */
DROP PROCEDURE update_vente_sfr;
DROP PROCEDURE entourage_bis;
DROP PROCEDURE entourage;

/* Suppression des tables de notre base de données */
DROP TABLE Employe;
DROP TABLE Prioritaire;
DROP TABLE Relation;
DROP TABLE Mail;
DROP TABLE Telephone;
DROP TABLE CompteBancaire;
DROP TABLE Conversation;
DROP TABLE Personne;
DROP TABLE Entreprise;


