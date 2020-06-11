############################################################################## 
## 
## Set-PrivateProfileString.ps1 
##
## http://www.leeholmes.com/blog/2007/10/02/managing-ini-files-with-powershell/
##
## Set an entry from an INI file. 
## 
## ie: 
## 
##  PS >copy C:\winnt\system32\ntfrsrep.ini c:\temp\ 
##  PS >Set-PrivateProfileString.ps1 C:\temp\ntfrsrep.ini text ` 
##  >> DEV_CTR_24_009_HELP ”New Value” 
##  >> 
##  PS >Get-PrivateProfileString.ps1 C:\temp\ntfrsrep.ini text DEV_CTR_24_009_HELP 
##  New Value 
##  PS >Set-PrivateProfileString.ps1 C:\temp\ntfrsrep.ini NEW_SECTION ` 
##  >> NewItem ”Entirely New Value” 
##  >> 
##  PS >Get-PrivateProfileString.ps1 C:\temp\ntfrsrep.ini NEW_SECTION NewItem 
##  Entirely New Value 
## 
############################################################################## 

param( 
    $file, 
    $category, 
    $key, 
    $value) 

## Prepare the parameter types and parameter values for the Invoke-WindowsApi script 
$parameterTypes = [string], [string], [string], [string] 
$parameters = [string] $category, [string] $key, [string] $value, [string] $file 

## Invoke the API 
[void] (Invoke-WindowsApi “kernel32.dll” ([UInt32]) “WritePrivateProfileString” $parameterTypes $parameters)
