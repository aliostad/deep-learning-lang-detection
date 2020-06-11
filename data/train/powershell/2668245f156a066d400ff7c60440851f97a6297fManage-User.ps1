param($switch, $csvfile, $help)

function funHelp()
{
$helpText=@"
NAME: Manage-User.ps1

DESCRIPTION:
Скрипт для манипулирования пользователями.
 
PARAMETERS:
-switch		Принимает значения выпоняняемого действия (Add, Set, Del)
-csv-file	Файл с данными пользователя.
-help		Выводит эту справку.
 
SYNTAX:
CreateLocalUser.ps1
Generates an error. You must supply a user name
 
CreateLocalUser.ps1 -computer MunichServer -user myUser
 -password Passw0rd^&!
 
Creates a local user called myUser on a computer named MunichServer
with a password of Passw0rd^&!
 
CreateLocalUser.ps1 -user myUser -password Passw0rd^&!
with a password of Passw0rd^&!
 
Creates a local user called myUser on local computer with
a password of Passw0rd^&!
 
CreateLocalUser.ps1 -help ?

Displays the help topic for the script
"@
$helpText
exit
}

if($help){ "Obtaining help ..." ; funhelp }