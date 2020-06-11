PARAM(
[STRING]$BusinessName=$(Read-Host -prompt "What is the customers Full Business Name? e.g. ExamplePtyLtd"),
[STRING]$EmailDomainName=$(Read-Host -prompt "What is the customers Full Domain Name? e.g. example.com.au"),
[STRING]$DomainController,
[STRING]$ExchangeServer
)

# Import modules and snapins
if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $null ){Add-PsSnapin Microsoft.Exchange.Management.PowerShell.E2010}
if ( (Get-module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null ){Import-module ActiveDirectory}

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
function validateCustomerDomain($newCustDomain){
    $failADCount="0"
    $failTLDCount="0"
    $tlds=".com",".org",".net",".edu",".asn",".co.uk",".co.nz",".info",".biz",".com.au",".net.au",".org.au",".edu.au",".asn.au"
    $tlds | foreach-object{
        if($newCustDomain -like "*$_"){
            $failTLDCount="1"
            Get-AcceptedDomain | ForEach-Object{
                if($newCustDomain -eq $_.DomainName){logMessage error ("Domain " + $newCustDomain + " is already an accepted domain"); $failADCount="1"}
            }
            if($failADCount -eq "0"){echo $true}elseif($failADCount -eq "1"){echo $false}else{logMessage error "Something went wrong! The failADCount variable in the validateCustomerDomain function should be 0 or 1"}
        }
    }
    if($failTLDCount -eq "0"){logMessage error ("The domain " + $newCustDomain + " doesn't match any of the valid TLD's in this script."); echo $false}
}
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
function Check-UpnIsFree($EmailDomainName){
    $found=0
    (Get-ADForest).UPNSuffixes | ForEach-Object{if($_ -eq "$EmailDomainName"){$found=1}}
    if($found -eq 1){echo $false}elseif($found -eq 0){echo $true}
}
function Check-AcceptedDomainIsFree($EmailDomainName){
    $found=0
    ((get-acceptedDomain).domainname).domain | ForEach-Object{if($_ -eq "$EmailDomainName"){$found=1}}
    if($found -eq 1){echo $false}elseif($found -eq 0){echo $true}
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
function createDelay($seconds){Start-Sleep -s $seconds}
function Create-AcceptedDomain($EmailDomainName){new-AcceptedDomain -Name $EmailDomainName -DomainName $EmailDomainName -DomainType 'Authoritative' | out-file -Filepath $SessionTranscript -append}
function Update-CustomerDomainsAttribute($BusinessName, $EmailDomainName){
    $custAcceptedDomains = $(get-ADOrganizationalUnit -Identity "OU=$BusinessName,$hostedExchange_baseDN" -Properties proxyAddresses)
    $custAcceptedDomains.proxyAddresses = ("ADDITIONAL:" + $EmailDomainName)
    Set-ADOrganizationalUnit -Instance $custAcceptedDomains
}
function readyToStart($BusinessName, $EmailDomainName){
    if((Check-CustomerExists $BusinessName) -eq "True"){
        if((Check-UpnIsFree $EmailDomainName) -eq "True"){
            if((Check-AcceptedDomainIsFree $EmailDomainName) -eq "True"){
                if((validateCustomerDomain $EmailDomainName) -eq "True"){
                    echo $true
                }else{
                    logMessage error ("There domain is not valid")
                    echo $false
                }
                }else{
                logMessage error ("There domain is already in use as an accepted domain")
                echo $false
            }
        }else{
            logMessage error ("There domain is already in use as a UPNSuffix")
            echo $false
        }
    }else{
        logMessage error ("BusinessName " + $BusinessName + " does not exist!")
        echo $false    
    }
}

# Static Variables
$hostedExchange_ClientOU="HostedClients"                                            # relative OU to root of domain
$LogFile="C:\manage\scripts\new-hecustomerdomain.log"                                     # log all messages to this location
$SessionTranscript="C:\manage\scripts\new-hecustomerdomain.SessionReport." + $BusinessName + ".log"         # log all messages to this location
#
# Dynamic Global Variables
#
# --> Set base domain info (DN,Canonical,DNSRoot)
$ad = Get-ADDomain
$hostedExchange_domain = $ad.DNSroot
$hostedExchange_baseDN = "OU=" + $hostedExchange_ClientOU + "," + $ad.DistinguishedName
$hostedExchange_baseOU =  $hostedExchange_domain + "/" + $hostedExchange_ClientOU
#
# --> Select Domain Controller
$hostedExchange_dchost=$(Select-MyDomainController)
#
# --> Select Exchange Server
$hostedExchange_exhost=$(Select-MyExchangeHost)

if($(readyToStart $BusinessName $EmailDomainName) -eq $true){
    # Create the new accepted domain    
    Create-AcceptedDomain $EmailDomainName
    # Updated the AD Attributes for the customer
    Update-CustomerDomainsAttribute $BusinessName $EmailDomainName
}