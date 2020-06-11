#what version of Powershell are you using?
$PSVersionTable

#Let's find out more about Get-Item
Get-Help Get-Item -ShowWindow

#Take note of the following:
# -How many arguements does it have?
# -What kind of object does it output?
# -Can you figure out what argument will be used if none are specified?

#Any aliases?
Get-Alias -Definition Get-Item

#Let's compare the current helpfile with the online version
#(Only do this if you have internet access)
Get-Help Get-Item -Online

#Find the cmdlet to make a new firewall rule
Get-Command *New*Firewall*

#Let's now find out about it
Get-Help New-NetFirewallRule -ShowWindow

#Take note of the following:
# -How many arguements does it have?
# -What kind of object does it output?

#Does it have any alases?
Get-Alias -Definition New-NetFirewallRule