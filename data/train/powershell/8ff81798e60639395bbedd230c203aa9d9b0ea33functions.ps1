# =======================================================
# NAME: load_conf.ps1
# AUTHOR: Dupré Maxime
# DATE: 23/02/2016
#
# KEYWORDS: 
# VERSION 1.0
# 
# COMMENTS: 
# load_conf  
# Lis le fichier de configuration donné et permet la lecture sous forme de $param.nombalise.valeur		
#			
#
#Requires -Version 2.0
# =======================================================


function load_conf()
{

param($path = $(throw “fichier de configuration XML non fourni”))

[xml]$xml= Get-Content "C:\Projet Hosting\conf\mysql.xml"
return $xml

}
