<#
.Synopsis
   Loads Credentials saved in CSV file format
.DESCRIPTION
   Loads Credentials saved in CSV file format based on a feed file to provide a custom object
   that contains user names, service connections, and 
.EXAMPLE
   Load-Credentials -Path C:\Scripts -LoadFile 
#>
function Load-Credentials
{
    [CmdletBinding()]
    Param
    (
        # Path to load the credentials, the default path is:
        # D:\Scripts\Input\Credentials\" + [Environment]::Username + "\"
        [ValidateScript({Test-Path $_})]
        [String]$Path = "H:\Scripts\Input\Credentials\" + [Environment]::Username + "\",

        # LoadFile is the location of the CSV file containing credentials to login to remote domains.
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string]$LoadFile

    )

    Begin
    {

    
    }
    Process
    {

        $Credentials = @()
        
        # Loading file containing AD connection service location and users in DOMAIN\USERS
        $File = Import-Csv $LoadFile
        $File | ForEach-Object {

    
            # 
    	    $Service = $_.Service
            $UserName = $_.UserName

            $Domain = $UserName.Split("\\")[0]
            $User = $UserName.Split("\\")[1]
            
            $PasswordFile = Import-Csv ($Path + [System.Environment]::MachineName + "." + $Domain + "." + $User + ".csv")
    		

            $Credential = New-Object psobject -Property @{
                UserName = $UserName;
                Domain = $Domain;
                User = $User;
                Service = $Service;
                Credential = New-Object System.Management.Automation.PSCredential($UserName,($PasswordFile.Password | ConvertTo-SecureString));
            }
           
            $Credentials += $Credential

        }

    }
    End
    {

        Return $Credentials

    }
}

function Open-Credentials
{
    [CmdletBinding()]
    Param
    (
        # Path to load the credentials, the default path is:
        # D:\Scripts\Input\Credentials\" + [Environment]::Username + "\"
        [ValidateScript({Test-Path $_})]
        [String]$Path = "H:\Scripts\Input\Credentials\" + [Environment]::Username + "\",

        # UserName is the Name you want to load
        [Parameter(Mandatory=$true)]
        [string]$UserName,

        # UserName is the Name you want to load
        [Parameter(Mandatory=$true)]
        [string]$Domain


    )

    Begin
    {

    
    }
    Process
    {

        $PasswordFile = Import-Csv ($Path + [System.Environment]::MachineName + "." + $Domain + "." + $UserName + ".csv")

        $Credential = New-Object System.Management.Automation.PSCredential($PasswordFile.UserName,($PasswordFile.Password | ConvertTo-SecureString))

    }
    End
    {

        Return $Credential

    }
}