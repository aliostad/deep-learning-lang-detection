$folder = 'D:\mssqlserver\MSSQL11.MSSQLSERVER\MSSQL\DATA'
$debug = 5
$instance = 'Tiny'

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

$server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $instance
if ($debug -eq 3)
 {
    "Database List"
    "-------------"
    foreach($sqlDatabase in $Server.databases) 
        { write-host "DB:" $sqlDatabase.name
        }
 #end debug
 }


# loop through each  of the file
foreach ($file in Get-ChildItem $folder)
{
 #Debug
 if ($debug -eq 1)
    {
     write-host "All files: " $file.name
     #end debug
    }

 if ($file.Extension -eq '.mdf') 
    {
     if ($debug -eq 1)
     {
      write-host "MDF Files: "  $file.name
      #end debug
     }

     # loop through each  of the databases
     foreach($sqlDatabase in $Server.databases | Where-Object {$_.ISSystemObject -eq $false} ) 
        {

         $sqlfg = $sqlDatabase.FileGroups
         foreach ($fg in $sqlfg | Where-Object {$_.ISDefault -eq $true})
         {
          if ($debug -eq 6)
          {
           Write-Host "File " $file.Name $sqlDatabase.name " " $fg.Name
          # end if
          }

          foreach ($dbfile in $fg.files | Where-Object {$_.ISPrimaryFile -eq $true} )
           {

            if ($debug -eq 4)
            {
            write-host "File" $file.BaseName " DB MDF File: "  $dbfile.Name
            #end debug
            }

            if ($file.FullName -eq $dbfile.FileName)
             { 
              if ($debug -eq 5)
              {
                write-host "Match " $file.FullName " = " $dbfile.FileName
               #end if
              }
              #end if
             }

           #end foreach db file
           }
         #end foreach filegroup
         }

        # end foreach 
        }

    # end if
    }

# end for loop of files
}
