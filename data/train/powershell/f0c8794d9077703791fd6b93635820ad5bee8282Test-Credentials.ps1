################################################function Test-Credentials################################################
<#
.Synopsis
   Tests Credentials saved in CSV file format
.DESCRIPTION
   Tests Credentials saved in CSV file format based on a feed file to provide a custom object
   that contains user names, service connections, and will create any missing credentials.   
   This will also attempt a connection to the AD service using Connect-QADService
.EXAMPLE
   Load-Credentials -Path C:\Scripts -LoadFile 
#>
function Test-Credentials
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
        # Loading Save credentials
        #. "D:\Scripts\PowerShell\DST\Functions\Save-Credential.ps1"
    }
    Process
    {
        $Credentials = @()
        
        # Loading file containing AD connection service location and users in DOMAIN\USERS
        $File = Import-Csv $LoadFile
        ForEach ($Line in $File) {


            $GoodCred = $false
            $Tries = 0
            #Testing Credentials against AD until successful
            while (($GoodCred -eq $false) -and ($Tries -lt 3)){

    	        $Service = $Line.Service
                $UserName = $Line.UserName

                $Domain = $UserName.Split("\\")[0]
                $User = $UserName.Split("\\")[1]
            
                $CredFile = ($Path + [System.Environment]::MachineName + "." + $Domain + "." + $User + ".csv")

                # Testing to see if credential file exists, if not create a credential file
                If (!(Test-Path $CredFile)) {

                    Write-Verbose "$CredFile doesn't exist, creating the file"
                    Save-Credential -Path $Path -Message "Credential File $CredFile doesn't exist creating file for $UserName" -UserName $UserName

                } #If (!(Test-Path $CredFile))

                #Loading Credential File
                $PasswordFile = Import-Csv $CredFile

                # Testing Credential
                $ErrorCount = $Error.Count

                $Credential = New-Object System.Management.Automation.PSCredential($UserName,($PasswordFile.Password | ConvertTo-SecureString)) -ErrorAction SilentlyContinue
                If ($Error.Count -eq $ErrorCount) {

                    # Testing Connection
                    $ErrorCount = $Error.Count

                    Write-Verbose "Testing $UserName on $Service"
                    (Connect-QADService -Service $Service -Credential $Credential -ErrorAction SilentlyContinue) | Out-Null

                    If ($Error.Count -eq $ErrorCount) {

                        Write-Verbose "Credential $UserName connected to $Service"
                        $GoodCred = $true

                    } else {
                        $Tries +=1
                        Write-Verbose "Credential $UserName FAILED to connected to $Service"
                        $GoodCred = $false
                        Save-Credential -Path $Path -Message "User $UserName failed connection to $Service, you need to update the credentials." -UserName $UserName

                    } #Connect-QADService

                } else {

                    Write-Verbose "Credential $UserName FAILED to connected to $Service"
                    $GoodCred = $false
                    Save-Credential -Path $Path -Message "User $UserName credentials are bad, you need to update the credentials." -UserName $UserName

                } # Credential Creation Test
                
            } # while ($GoodCred -eq $false)
          
        } #$File | ForEach-Object
        

    } #Process 
    End
    {


    }
}