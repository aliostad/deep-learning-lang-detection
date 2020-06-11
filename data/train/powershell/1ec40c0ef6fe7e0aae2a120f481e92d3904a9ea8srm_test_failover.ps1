# Author:	@virtualhobbit
# Website:	http://virtualhobbit.com
# Ref:		Wednesday Tidbit: Test an SRM Recovery Plan using PowerCLI

# Variables
 
$vc = "vc.nl.mdb-lab.com"
$srm = "vc3.uk.mdb-lab.com"
$credential = Get-Credential
 

# Connect to VC and SRM server
Connect-ViServer $vc -Credential $credential
Connect-SrmServer $srm -Credential $credential

# Define API variable
$SrmConnection = Connect-SrmServer $srm -Credential $credential
$SrmApi = $SrmConnection.ExtensionData

# List Protection Groups
$SrmApi.Protection.ListProtectionGroups().GetInfo() | Format-Table Name,Type

# List Recovery Plans
$SrmApi.Recovery.ListPlans().GetInfo() | Format-Table Name,State

# Set variable
$RecoveryPlans=$SrmApi.Recovery.ListPlans()

# Begin work on Test Exchange failover Recovery Plan
$RPmoref = $SrmApi.Recovery.ListPlans()[1]

# Set recovery mode to Test
$RPmode = New-Object VMware.VimAutomation.Srm.Views.SrmRecoveryPlanRecoveryMode
$RPmode.Value__ = 1

# Begin test
$RPmoref.Start($RPmode)

# Pause script and wait for user to return
Write-Host "The script will now pause.  When you are satisfied the test has been successful, press enter to continue"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Set recovery mode to Cleanup
$RPmode.Value__ = 2

# Begin Cleanup
$RPmoref.Start($RPmode)

# Disconnect from VC and SRM server
Disconnect-ViServer $vc -Confirm:$false
Disconnect-SrmServer $srm -Confirm:$false