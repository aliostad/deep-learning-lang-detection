Import-Module SQLPS -DisableNameChecking

#This will take about a minute
#Take notice of the Command Prompt after importing the module.
#PS SQLSERVER:\>

dir
cd SQL\SQL2008R2
dir
cd DEFAULT
dir
cd Databases
dir
cd ReportServer
dir
cd Users
dir
# or if you know where you are going 
dir SQLSERVER:\SQL\SQL2008R2\DEFAULT\Databases\ReportServer\Users\
dir SQLSERVER:\SQL\SQL2008R2\DEFAULT\Databases\ReportServerTempDB\Users\

#Show all Power Shell Drives
Get-PSDrive | Select name, Provider, Root