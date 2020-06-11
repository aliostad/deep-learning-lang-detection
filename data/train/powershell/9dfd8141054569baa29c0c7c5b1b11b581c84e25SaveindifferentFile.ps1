$ServerName='MyServer'# the server it is on
$Database='MyDatabase' # the name of the database you want to script as objects
$DirectoryToSaveTo='D:\CMRS Operations\Scripts\Script out Data from the database' 
$d=Get-Content .\TableNames.txt
foreach($a in $d)
{
    $SavePath="$($DirectoryToSaveTo)\$a.sql"
   # create the directory if necessary (SMO doesn't).
   if (!( Test-Path -path $SavePath )) # create it if not existing
   {
   Try { New-Item $SavePath -type file | out-null }
   Catch [system.exception]{
            Write-Error "error while creating '$SavePath' $_"
            return
         }
    }    
}
    # tell the scripter object where to write it
   # $scripter.Options.Filename = "$SavePath\$($_.name -replace '[\\\/\:\.]','-').sql";
    # Create a single element URN array
   # $UrnCollection = new-object ('Microsoft.SqlServer.Management.Smo.urnCollection')
   # $URNCollection.add($_.urn)
    # and write out the object to the specified file
   # $scripter.script($URNCollection)