<#
    .DESCRIPTION
       Helper for import

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .LINK
       http://...
#>

. $LocalDir\Load-Module.ps1
. $LocalDir\New-ADPatch.ps1
. $LocalDir\Get-FreeADLogin.ps1
. $LocalDir\New-RandomPassword.ps1
. $localDir\Get-Translit.ps1

if (!(Load-Module DashingLogger)){
    Write-Error "Module DashingLogger must be installed"
    exit  
}

#if (!(Load-Module ActiveDirectory)){
#    Write-Error "Module ActiveDirectory must be installed"
#    exit  
#}

#config file
[xml]$CF = Get-Content "$LocalDir\Config.xml"
$C = $CF.cfg
