# Set error foreground color to White
$host.PrivateData.ErrorForegroundColor = 'White'

# Disable loading the default AD: drive in the Active Directory Module
$env:ADPS_LoadDefaultDrive = 0

# Default parameter values
if ($host.Version.Major -ge 3) {
#$PSDefaultParameterValues.Add("*:Credential",$Cred)
#$PSDefaultParameterValues.Add("Get-ChildItem:Force",$True)
#$PSDefaultParameterValues.Add("Receive-Job:Keep",$True)
#$PSDefaultParameterValues.Add("Format-Table:AutoSize",{if ($host.Name -eq "ConsoleHost"){$true}})
$PSDefaultParameterValues.Add("Send-MailMessage:To","jan.egil.ring@crayon.com")
$PSDefaultParameterValues.Add("Send-MailMessage:SMTPServer","mail.crayon.com")
#$PSDefaultParameterValues.Add("Update-Help:Module","*")
$PSDefaultParameterValues.Add("Update-Help:ErrorAction","SilentlyContinue")
#$PSDefaultParameterValues.Add("Test-Connection:Quiet",$True)
$PSDefaultParameterValues.Add("Test-Connection:Count","1")
}

if ($host.Version.Major -ge 4) {
$PSDefaultParameterValues["Out-Default:OutVariable"] = "0"
}

# "Cheet sheet" variables

$V3 = @"

Exe argument passing: --%

"@

$DirectAccess_netsh = @"
netsh dnsclient show state
netsh namespace show effectivepolicy and netsh namespace show policy
netsh interface 6to4 show relay
netsh interface teredo show state
netsh interface httpstunnel show interfaces
netsh interface istatap show state and netsh interface istatap show router
netsh interface httpstunnel show interfaces
netsh advfirewall monitor show mmsa
netsh advfirewall monitor show qmsa
netsh advfirewall monitor show consec rule name=all
netsh advfirewall monitor show currentprofile
netsh interface ipv6 show interfaces
netsh interface ipv6 show interfaces level=verbose
netsh interface ipv6 show route
"@