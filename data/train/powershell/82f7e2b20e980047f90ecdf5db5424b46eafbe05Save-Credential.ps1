<#
.Synopsis
   Saves Credentials for later use to CSV file
.DESCRIPTION
   Saves Credentials to a CSV file, with the file name based on credentials provided
   When prompted for credentials you will need to provide them in DOMAIN\USERNAME format

   Files will be saved as: 

   PATH\MACHINE.DOMAIN.USER.CSV

.EXAMPLE
   Save-Credential
.EXAMPLE
   Save-Credential -Path C:\Scripts
#>
function Save-Credential
{
    [CmdletBinding()]
    Param
    (
        # Path to save the credentials, the default path is:
        # D:\Scripts\Input\Credentials\" + [Environment]::Username + "\"
        [String]$Path = "H:\Scripts\Input\Credentials\" + [Environment]::Username + "\",

        # User Name to pre-populate Credential field
        [String]$UserName,

        # Message to send to Get-Credential
        [String]$Message = "Enter Credentials to Save"
    )

    Begin
    {

        If (!(Test-Path $Path)){New-Item -Path $Path -ItemType Directory}

    }
    Process
    {
    
        # Test for desired credential name, this is usually passed from test-credential function
        If (($UserName -eq $null) -and ($Message -eq $null)) {

            $Credential = Get-Credential

        } elseif (($UserName -eq $null) -and ($Message -ne $null)) { 

            $Credential = Get-Credential -Message $Message

        } elseif (($UserName -ne $null) -and ($Message -eq $null)) { 

            $Credential = Get-Credential -UserName $UserName

        } else { 

            $Credential = Get-Credential -Message $Message -UserName $UserName

        }

        $PlainTxtCred = New-Object System.Object
        $PlainTxtCred | Add-Member -type NoteProperty -name UserName -value $Credential.UserName
        $PlainTxtCred | Add-Member -type NoteProperty -name Password -value ($Credential.Password | ConvertFrom-SecureString)
        $PlainTxtCred | Export-Csv -NoTypeInformation ($Path + [System.Environment]::MachineName + "." + ($Credential.UserName -split "\\")[0] + "." + ($Credential.UserName -split "\\")[1] + ".csv") -Force

    }
    End
    {
    }
}