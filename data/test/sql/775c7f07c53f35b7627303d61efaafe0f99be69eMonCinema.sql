/*==============================================================*/
/* Table : new_INDIVIDUS                                            */
/*==============================================================*/
create table new_INDIVIDUS
(
   Nr_Individus         smallint(4) unsigned not null AUTO_INCREMENT,
   Nom_Individu         tinytext,
   Sexe					char(1),
   primary key (Nr_Individus)
);

/*==============================================================*/
/* Table : new_ACTEURS                                              */
/*==============================================================*/
create table new_ACTEURS
(
   Nr_Individus         smallint(4) unsigned not null,
   Nr_Nation            char(3) not null,
   primary key (Nr_Individus)
);

/*==============================================================*/
/* Table : new_REALISATEURS                                         */
/*==============================================================*/
create table new_REALISATEURS
(
   Nr_Individus         smallint(4) unsigned not null,
   Nr_Nation            char(3) not null,
   primary key (Nr_Individus)
);

/*==============================================================*/
/* Table : new_SCENARISTE                                           */
/*==============================================================*/
create table new_SCENARISTE
(
   Nr_Individus         smallint(4) unsigned not null,
   primary key (Nr_Individus)
);

/*==============================================================*/
/* Table : new_A_ECRIT                                              */
/*==============================================================*/
create table new_A_ECRIT
(
   Nr_Film              smallint(4) unsigned not null,
   Nr_Individus         smallint(4) unsigned not null,
   primary key (Nr_Film, Nr_Individus)
);

/*==============================================================*/
/* Table : new_CINEPHILE                                            */
/*==============================================================*/
create table new_CINEPHILE
(
   Nr_cinephile         smallint(4) unsigned not null AUTO_INCREMENT,
   Password             tinytext,
   Nom_Cinephile        tinytext,
   primary key (Nr_cinephile)
);

/*==============================================================*/
/* Table : new_EST_CLASSE_DANS_LE                                   */
/*==============================================================*/
create table new_EST_CLASSE_DANS_LE
(
   Id_Genre             smallint(4) unsigned not null,
   Nr_Film              smallint(4) unsigned not null,
   primary key (Id_Genre, Nr_Film)
);

/*==============================================================*/
/* Table : new_EST_D_ORIGINE                                        */
/*==============================================================*/
create table new_EST_D_ORIGINE
(
   Nr_Film              smallint(4) unsigned not null,
   Nr_Nation            char(3) not null,
   primary key (Nr_Film, Nr_Nation)
);

/*==============================================================*/
/* Table : new_EST_INTERPRETER_PAR                                  */
/*==============================================================*/
create table new_EST_INTERPRETER_PAR
(
   Nr_Film              smallint(4) unsigned not null,
   Nr_Individus         smallint(4) unsigned not null,
   primary key (Nr_Film, Nr_Individus)
);

/*==============================================================*/
/* Table : new_EST_LA_VOIX_OFF                                      */
/*==============================================================*/
create table new_EST_LA_VOIX_OFF
(
   Nr_Film              smallint(4) unsigned not null,
   Nr_Individus         smallint(4) unsigned not null,
   personnage           tinytext,
   primary key (Nr_Film, Nr_Individus)
);

/*==============================================================*/
/* Table : new_EST_REALISE_PAR                                      */
/*==============================================================*/
create table new_EST_REALISE_PAR
(
   Nr_Film              smallint(4) unsigned not null,
   Nr_Individus         smallint(4) unsigned not null,
   primary key (Nr_Film, Nr_Individus)
);

/*==============================================================*/
/* Table : new_FILM                                                 */
/*==============================================================*/
create table new_FILM
(
   Nr_Film              smallint(4) unsigned not null AUTO_INCREMENT,
   Titre                text,
   Synopsis             text,
   Affiche              text,
   DVD                  bool,
   Date_Modif_Film      date,
   primary key (Nr_Film)
);

/*==============================================================*/
/* Table : new_GENRE                                                */
/*==============================================================*/
create table new_GENRE
(
   Id_Genre             smallint(4) unsigned not null AUTO_INCREMENT,
   Nom_Genre            char(20),
   primary key (Id_Genre)
);

/*==============================================================*/
/* Table : new_NATIONALITES                                         */
/*==============================================================*/
create table new_NATIONALITES
(
   Nr_Nation            char(3) not null,
   Nom                  tinytext,
   primary key (Nr_Nation)
);

/*==============================================================*/
/* Table : new_NOTE                                                 */
/*==============================================================*/
create table new_NOTE
(
   Nr_Note              smallint(4) unsigned not null AUTO_INCREMENT,
   Nr_cinephile         smallint(4) unsigned not null,
   Nr_Film              smallint(4) unsigned not null,
   Note_Film            smallint,
   Date_vu              date,
   Date_modif_note      date,
   primary key (Nr_Note)
);