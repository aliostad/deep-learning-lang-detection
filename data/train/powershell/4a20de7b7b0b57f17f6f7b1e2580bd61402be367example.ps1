# =======================================================
# NAME: example.ps1
# AUTHOR: Dupré Maxime
# DATE: 23/02/2016
#
# KEYWORDS: 
# VERSION 1.0
# 
# COMMENTS: 
#   Example d'utilisation de la fonctions load_conf
# 
#			
#
#Requires -Version 2.0
# =======================================================

$folder = split-path $myinvocation.mycommand.path
$folder_conf = "$folder\conf"

. "$folder\load_conf_functions.ps1"

#Chargement du fichier de configuration

$conf_app = load_conf "$folder_conf\config.xml"
$conf_mysql = load_conf "$folder_conf\mysql.xml"

$conf_app.applications.rep_log 
$conf_mysql.mysql.user

exit 0