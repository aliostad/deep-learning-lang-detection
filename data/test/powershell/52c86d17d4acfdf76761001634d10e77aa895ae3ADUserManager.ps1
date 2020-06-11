#Import the Active Directory Module
Import-Module ActiveDirectory

#Save the CSV file contents to the $CSV Variable
$CSV = Import-Csv C:\scripts\ADUser.csv

#Foreach row in the CSV, do the following:
Foreach ($Row in $CSV){

#Save the Username as it's own variable
 $UserName = $Row.User

#Save the Manager name as it's own variable
 $ManagerName = $Row.Manager

#Get the user object that matches the username
 $User = Get-ADUser -Filter {Name -eq $Username}

#Get the user object that matches the manager name
 $Manager = Get-ADUser -Filter {Name -eq $ManagerName}

#Set the manager field on the user object
 Set-ADUser -Identity $User -Manager $Manager}
