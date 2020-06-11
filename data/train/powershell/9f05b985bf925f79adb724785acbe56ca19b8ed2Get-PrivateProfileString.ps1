##############################################################################
##
## Get-PrivateProfileString.ps1
##
## Get an entry from an INI file.
##
## ie:
##
##  PS >Get-PrivateProfileString.ps1 C:\winnt\system32\ntfrsrep.ini text DEV_CTR_24_009_HELP
##
##############################################################################

param(
    $file,
    $category,
    $key
)

Write-Verbose "+++ Get-PrivateProfileString.ps1"

## Prepare the parameter types and parameter values for the Invoke-WindowsApi script
$returnValue = New-Object System.Text.StringBuilder 500
$parameterTypes = [string], [string], [string], [System.Text.StringBuilder], [int], [string]
$parameters = [string] $category, [string] $key, [string] "", 
   [System.Text.StringBuilder] $returnValue, [int] $returnValue.Capacity, [string] $file

## Invoke the API
[void] (Invoke-WindowsApi "kernel32.dll" ([UInt32]) "GetPrivateProfileString" `
   $parameterTypes $parameters)

## And return the results
$returnValue.ToString()

Write-Verbose "--- Get-PrivateProfileString.ps1"
