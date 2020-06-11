PARAM(
[STRING]$BusinessName=$(Read-Host -prompt "What is the customers Full Business Name? e.g. ExamplePtyLtd"),
[STRING]$EmailAddress=$(Read-Host -prompt "What is the Contacts Address? e.g. 'Billy.Bob@spacetrucker.com.au' or 'Accounts@spacetrucker.com.au'"),
[STRING]$DisplayName=$(Read-Host -prompt "What is the Contacts Display Name? e.g. 'Billy Bob' or 'Accounts @ Some Business'"),
[STRING]$FirstName=$(Read-Host -prompt "What is the Contacts First Name? e.g. 'Billy' or 'Accounts'"),
[STRING]$LastName,
[STRING]$DomainController,
[STRING]$ExchangeServer
)
#
# Import modules and snapins
if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $null ){Add-PsSnapin Microsoft.Exchange.Management.PowerShell.E2010}
if ( (Get-module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null ){Import-module ActiveDirectory}
#
# Functions
function logMessage($type, $string){
    $colour=""
    if($type -eq "warning"){$colour = "yellow"}
    elseif($type -eq "error"){$colour = "red"}
    elseif($type -eq "info"){$colour = "white"}
    write-host $string -foregroundcolor $colour
    ($(get-date -format "yyyy-mm-dd_ss") + ":" + $type.ToUpper() + ": " + $string) | out-file -Filepath $LogFile -append
}
function logMessageSilently($type, $string){
    $colour=""
    if($type -eq "warning"){$colour = "yellow"}
    elseif($type -eq "error"){$colour = "red"}
    elseif($type -eq "info"){$colour = "white"}
    ($(get-date -format "yyyy-mm-dd_ss") + ":" + $type.ToUpper() + ": " + $string) | out-file -Filepath $logfile -append
}
function ConvertFrom-DN{
param([string]$DN=(Throw '$DN is required!'))
    foreach ( $item in ($DN.replace('\,','~').split(",")))
    {
        switch -regex ($item.TrimStart().Substring(0,3))
        {
            "CN=" {$CN = '/' + $item.replace("CN=","");continue}
            "OU=" {$ou += ,$item.replace("OU=","");$ou += '/';continue}
            "DC=" {$DC += $item.replace("DC=","");$DC += '.';continue}
        }
    }
    $canoincal = $dc.Substring(0,$dc.length - 1)
    for ($i = $ou.count;$i -ge 0;$i -- ){$canoincal += $ou[$i]}
    $canoincal += $cn.ToString().replace('~',',')
    return $canoincal
}
function Validate-Email ([string]$Email){ 
  return $Email -match "^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$" 
}  
function Select-MyDomainController{
# Shamelessly stolen from http://blog.vertigion.com/post/16926803996/powershell-pick-a-domain-controller
    param(
        [Parameter(
            HelpMessage = "If set, will return the result intead of setting globally."
        )]
        [switch] $Return
    )
     
    $DCList = $null
    while ($DCList -eq $null) {
        $DCList = Get-ADDomainController -Filter * | Select HostName
    }
    if ($Return.isPresent) {
        $DC = ''
        while ($DC -eq $myDC) {
            $DC = $DCList[$(Get-Random -Minimum 0 -Maximum ($DCList | Measure-Object).Count)].HostName
        }
        return $DC
    } else {
        $global:myDC = $DCList[$(Get-Random -Minimum 0 -Maximum ($DCList | Measure-Object).Count)].HostName
        echo $myDC
    }
}
function Select-MyExchangeHost{
# Shamelessly stolen (and modified) from http://blog.vertigion.com/post/16926803996/powershell-pick-a-domain-controller
    param(
        [Parameter(
            HelpMessage = "If set, will return the result intead of setting globally."
        )]
        [switch] $Return
    )
     
    $EXList = $null
    while ($EXList -eq $null) {
        $EXList = @(Get-ExchangeServer | Where-Object {$_.serverrole -like "*Mailbox*"})
    }
    if ($Return.isPresent) {
        $EX = ''
        while ($EX -eq $myEX) {
            $EX = $EXList[$(Get-Random -Minimum 0 -Maximum ($EXList | Measure-Object).Count)].fqdn
        }
        return $EX
    } else {
        $global:myEX = $EXList[$(Get-Random -Minimum 0 -Maximum ($EXList | Measure-Object).Count)].fqdn
        echo $myEx
    }
}
function Create-Delay($seconds){Start-Sleep -s $seconds}
function Check-CustomerExists($custName){
    if((Get-ADOrganizationalUnit -Filter 'Name -like $custName' -SearchBase $hostedExchange_baseDN) -ne $null){
   		echo $true
   	}else{
   		if((Get-ADOrganizationalUnit -Filter 'Name -like $custName' -SearchBase $hostedExchange_baseDN) -eq $null){
   			echo $false
   		}else{
   			echo $false
   	    }
    }
}
function Get-CustomerShortname($custName){
    $test=$(Try {(get-ADOrganizationalUnit -Identity "OU=$custName,$hostedExchange_baseDN" -Properties Description).description}Catch{echo $false})
    if($test -ne $false){
        $(get-ADOrganizationalUnit -Identity "OU=$custName,$hostedExchange_baseDN" -Properties Description).description
    }elseif($test -eq $false){
        echo $false
    }else{
        # Something fucked up
        echo $false
    }
}


# Static Variables
$hostedExchange_ClientOU="HostedClients"               # relative OU to root of domain
$LogFile="C:\manage\scripts\new-hecontact.log"         # log all messages to this location
$allReports= @()                                       # Somewhere to store reports
#
# Dynamic Global Variables
#
# --> Set base domain info (DN,Canonical,DNSRoot)
$ad = Get-ADDomain
$hostedExchange_domain = $ad.DNSroot
$hostedExchange_baseDN = "OU=" + $hostedExchange_ClientOU + "," + $ad.DistinguishedName
$hostedExchange_baseOU =  $hostedExchange_domain + "/" + $hostedExchange_ClientOU
$contactOU = ($hostedExchange_baseOU + "\" + $BusinessName + "\Contacts")
#
# --> Select Domain Controller
$hostedExchange_dchost=$(Select-MyDomainController)
#
# --> Select Exchange Server
$hostedExchange_exhost=$(Select-MyExchangeHost)
#
# Start of show