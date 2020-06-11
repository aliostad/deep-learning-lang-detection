$ScriptPath  = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\0-CommonInit.ps1"

# generate document using 0-MofStructure.ps1

# let us invoke the document
Start-DscConfiguration -Wait -Verbose -Force -Path "$OutputPath\HeloWorld" -ComputerName localhost 

# When a document is delivered, LCM saves the document as pending.mof
# Why ? Important bug fixed in V2/LTSB
dir "$env:windir\system32\configuration"

# fix the source of the issue
md c:\source 
1..10 | Out-File "c:\source\$($_).txt"

# invoke the next convergence cycle
# important to know how consistency cycle behaves depending
# on the configuration stage
Invoke-ConsistencyCheck

#new cmdlet is available to manage these Remove-DscConfigurationDocument 
Get-Command Remove-DscConfigurationDocument -Syntax

Remove-DscConfigurationDocument -Stage Pending -Verbose

