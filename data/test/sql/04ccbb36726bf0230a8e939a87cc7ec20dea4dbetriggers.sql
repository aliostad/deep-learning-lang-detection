--Contraintes d'intégrité
ALTER TABLE AVION 
ADD CONSTRAINT CK_capacite 
CHECK (capacite between 15 and 30) ;

ALTER TABLE personnel_nav
ADD CONSTRAINT CK_salaire_nav 
CHECK (salaire > 0);

ALTER TABLE personnel_sol
ADD CONSTRAINT CK_salaire_sol 
CHECK (salaire > 0);

ALTER TABLE mission
ADD CONSTRAINT CK_ville_mission
CHECK (ville_dep != ville_arr);

--TRIGGER

--La législation aérienne impose une révision tous les 6 mois ou toutes les 500 heures
--de vols sous peine d’interdiction de vol. 




--Pour le personnel navigant qui compose les équipages, il est nécessaire de suivre
--leur nombre d’heures de vol du mois en cours ainsi que la totalité du nombre d’heures de vol.
--Le nombre d’heures maximum de vol mensuel est de 50 (temps d’escale comrpise) pour n’importe quel personnel navigant
