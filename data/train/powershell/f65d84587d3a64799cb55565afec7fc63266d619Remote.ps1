[CmdletBinding()] 
    Param( 
        [ValidateNotNullOrEmpty()] 
        [Parameter(Mandatory=$True)] 
        [string]$server, 
                  
        [Parameter(Mandatory=$False)] 
        [string]$Username, 
         
        [Parameter(Mandatory=$False)]
        [string]$Password,

        [switch]$Save
    )

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

. $dir\Functions.ps1

$a = $args.length

$ip = [System.Net.Dns]::GetHostAddresses($server).IpAddressToString

$oldname = $Host.UI.RawUI.WindowTitle
$Host.UI.RawUI.WindowTitle = $server

$inifile = $dir + "\Remote.ini"
$ini = Get-IniContent $inifile

if ($Username)
{
    $user = $Username
}
elseif ($ini["Username"][$server])
{
    $user = $ini["Username"][$server]
}
else
{
    $user = Read-Host "Username"    
    $promptwrite = "True"
}

if ($Password)
{
    $encpassword = ConvertTo-SecureString $Password -AsPlainText -Force
}
elseif ($ini["Password"][$server])
{
    $locpassword = $ini["Password"][$server]
    $encpassword = ConvertTo-SecureString $locpassword
}
else
{
    $plaintextpassword = Read-Host "Password" 
    $encpassword = ConvertTo-SecureString $plaintextpassword -AsPlainText -Force   
    $promptwrite = "True"
}

if ($promptwrite)
{
    $AskSave = Read-Host "Save credentials? (Y/N)"
}

if ($Save -Or $AskSave -eq "Y")
{
    $ini["Username"][$server] = $user
    $outpassword = ConvertFrom-SecureString $encpassword
    $ini["Password"][$server] = $outpassword
    Out-IniFile -InputObject $ini -FilePath $inifile -Force
}

$cred = New-Object -typename System.Management.Automation.PSCredential($user, $encpassword )
CLS
Enter-PSSession -ComputerName $ip -Credential $cred