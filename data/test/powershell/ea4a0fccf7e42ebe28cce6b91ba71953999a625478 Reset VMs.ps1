# Start of Settings 
# Set the number of days to show reset VMs
$VMsResetAge =1
# End of Settings

$OutputResetVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmResettingEvent"}| Select createdTime, UserName, fullFormattedMessage)
$OutputResetVMs

$Title = "Reset VMs"
$Header =  "VMs Reset (Last $VMsResetAge Day(s)) : $(@($OutputResetVMs).count)"
$Comments = "The following VMs have been reset over the last $($VMsResetAge) days"
$Display = "Table"
$Author = "James Scholefield"
$PluginVersion = 1.0
$PluginCategory = "vSphere"