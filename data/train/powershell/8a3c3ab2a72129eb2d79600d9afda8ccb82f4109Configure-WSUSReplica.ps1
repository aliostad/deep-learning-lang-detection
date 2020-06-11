# Configure WSUS Replica Server 
 
#------------------------------ 
# Setup Error Logging 
$erroractionpreference="Continue" 
$error.clear() 
 
#------------------------------ 
# Load the WSUS assenbly DLL and assign it to the $wsus variable 
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null 
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(); 
 
#------------------------------ 
# Assign the wsus configuration property objects to the $wsusconfig variable 
$wsusConfig = $wsus.GetConfiguration() 
 
#------------------------------ 
# Set the WSUS Update Source to goto another WSUS server rather than Microsoft 
$wsusConfig.SyncFromMicrosoftUpdate=$false 
 
#------------------------------ 
# Set the Upstream Server Name - Replace Server1 with your Primary WSUS server name 
$wsusConfig.UpstreamWsusServerName="w0001op01.internal.dentsply.net" 
 
#------------------------------ 
# Set the Upstream server Port Number - Replace 8530 with your port number 
$wsusConfig.UpstreamWsusServerPortNumber=8530 
 
#------------------------------ 
# Set the WSUS Server as a Replica of its Upstream Server 
$wsusConfig.IsReplicaServer=$True 
 
#------------------------------ 
# Set client side targeting for group membership 
$wsusConfig.TargetingMode="Client" 
 
#------------------------------ 
# Save the configuration 
$wsusConfig.Save() 
 
#------------------------------ 
# Assign the wsus Subscription Property objects to the $wsussub variable 
$wsusSub = $wsus.GetSubscription() 
 
#------------------------------ 
# Set the WSUS Server Syncronisation to Automatic 
$wsusSub.SynchronizeAutomatically=$True 
 
#------------------------------ 
# Set the WSUS Server Syncronisation Time 
$wsusSub.SynchronizeAutomaticallyTimeOfDay="00:00:00" 
 
#------------------------------ 
# Set the WSUS Server Syncronisation Number of Syncs per day 
$wsusSub.NumberOfSynchronizationsPerDay="6" 
 
#------------------------------ 
# Save the Syncoronisation Configuration 
$wsusSub.Save() 
 
#------------------------------ 
# Start a Sync 
#$wsusSub.StartSynchronization() 
 
#if ($error.count -ne 0) 
# { 
# Exit 10 
# }