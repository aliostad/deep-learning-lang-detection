$DATE=Get-Date

write-host "Serveur : Myslq.srv.GSB.coop" >> C:\Users\Administrateur\Documents\backup_conf\save.log
write-host "Nom des bases : GLPI" >> C:\Users\Administrateur\Documents\backup_conf\save.log
write-host "Nom utilisateur : GSB/administrateur" >> C:\Users\Administrateur\Documents\backup_conf\save.log
write-host "$DATE" >> C:\Users\Administrateur\Documents\backup_conf\save.log

write-host "______________________________________________________________" >> C:\Users\Administrateur\Documents\backup_conf\save.log

write-host "Debut de la tache de sauvegarde de bases de donnees" >> C:\Users\Administrateur\Documents\backup_conf\save.log

write-host "______________________________________________________________" >> C:\Users\Administrateur\Documents\backup_conf\save.log

write-host "sauvegarde de GLPI" >> C:\Users\Administrateur\Documents\backup_conf\save.log

C:\xampp\mysql\bin\mysqldump --opt --single-transaction --databases glpi -u root > C:\Users\Administrateur\Documents\Sauvegarde\glpi.sql

write-host "sauvegarde effectuee" >> C:\Users\Administrateur\Documents\backup_conf\save.log

write-host "______________________________________________________________" >> C:\Users\Administrateur\Documents\backup_conf\save.log
write-host sauvegarde effectuée
