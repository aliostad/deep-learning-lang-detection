$Global:passwordPath = $("$env:APPDATA\dotuserpass.xml")
$Global:passwordXml = @{}
$Global:loggedin = $false

<#
Unserialize xml into object
#>
function load_passwords()
{
    try
    {
        $Global:passwordXml = Import-Clixml -path $Global:passwordPath
        return $true
    }
    catch
    {
        return $false
    }
}

<#
Serialize object and store in xml
#>
function save_passwords()
{
    try
    {
        Export-Clixml -InputObject $Global:passwordXml -Path $Global:passwordPath -Force
        return $true
    }
    catch
    {
        return $false
    }
}

function create_user([string]$username, [string]$password)
{
        $Global:passwordXml["$username"] = "$password"
}

function login([string]$username, [string]$password)
{
    if ($Global:passwordXml["$username"] -eq $password)
    {
        $Global:loggedin = $true
        return $true
    }
    else
    {
        return $false
    }
}
load_passwords
echo "> "
save_passwords