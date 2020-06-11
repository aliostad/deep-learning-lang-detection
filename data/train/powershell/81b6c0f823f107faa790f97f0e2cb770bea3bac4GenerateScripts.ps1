Param($ServerName,$DatabaseName,$XMLorCSVparameter,$DirectoryToSaveTo,$DirectoryToTakeFiles)
set-psdebug -strict
    
    
$ErrorActionPreference = "stop" # you can opt to stagger on, bleeding, if an error occurs
Import-Module .\ScriptoutDatafromLocation.psm1 -disablenamechecking

#$ServerName= "blrcmrsdevitg"
#$DatabaseName="CMRS_MASTER"
#$XMLorCSVparameter = "XML"
#$DirectoryToSaveTo= "D:\Operations\Scripts\TestSQLFiles"
#$DirectoryToTakeFiles = "D:\CMRS\CMRS_Dev_Source_Database\CMRS_Scripts\01_CMRS_MASTER\DMLs\03_Client Data\QA"


ScriptOutData -ServerName $ServerName -DatabaseName $DatabaseName -XMLorCSVparameter $XMLorCSVparameter -DirectoryToSaveTo "$DirectoryToSaveTo" -DirectoryToTakeFiles "$DirectoryToTakeFiles"