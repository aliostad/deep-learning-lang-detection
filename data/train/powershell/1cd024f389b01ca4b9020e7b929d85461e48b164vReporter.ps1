# You can change the following defaults by altering the below settings:
#

# Global variables for report output 
$SMTPSRV = "mysmtpserver.mydomain.local"  #SMTP server name

$EmailFrom = "me@mydomain.local"          #report from address
$EmailTo = "me@mydomain.local"            #report to address; separate with commas ex: "user1@mydomain.local,user2@mydomain.local"

$exportDirectory = "C:\TMP"
$dateFormat = "yyyyMMdd_HHmm"             # use "d-M-yyyy" for legacy v5.0 format

# Use the following area to define the colours of the report
$Colour1 = "CC0000" # Main Title - currently red
$Colour2 = "7BA7C7" # Secondary Title - currently blue

#### Detail Settings ####
# Set the username of the account with permissions to access the VI Server 
# for event logs and service details - you will be asked for the same username and password
# only the first time this runs after setting the below username.
# If it is left blank it will use the credentials of the user who runs the script
$SetUsername = ""
# Set the location to store the credentials in a secure manner
$CredFile = ".\mycred.crd"
# Set if you would like to see the helpfull comments about areas of the checks
$Comments = $true
# Set the warning threshold for Datastore % Free Space
$DatastoreSpace = "5"
# Set the warning threshold for snapshots in days old
$SnapshotAge = 14
# Set the number of days to show VMs created & removed for
$VMsNewRemovedAge = 5
# Set the number of days of VC Events to check for errors
$VCEventAge = 1
# Set the number of days of VC Event Logs to check for warnings and errors
$VCEvntlgAge = 1
# Set the number of days of DRS Migrations to report and count on
$DRSMigrateAge = 1
# Local Stored VMs, do not report on any VMs who are defined below
$LVMDoNotInclude = "Template_*|VDI*"
# VMs with CD/Floppy drives not to report on
$CDFloppyConnectedOK = "APP*"
# The NTP server to check
$ntpserver = "pool.ntp.org" #Multiple servers can be specified with pipe separator as in "pool.ntp.org|myntp.domain.local"
# vmkernel log file checks - set the number of days to check before today
$vmkernelchk = 1
# CPU ready on VMs - To learn more read here: http://communities.vmware.com/docs/DOC-7390
$PercCPUReady = 10.0
# Change the next line to the maximum amount of vCPUs your VMs are allowed
$vCpu = 2
# Number of slots available in a cluster
$numslots = 10
# VM Cpu above x for the last x days
$CPUValue = 75
$CPUDays = 2
# VM Disk space left, set the amount you would like to report on
$MBFree = 10
# Max number of VMs per Datastore
$NumVMsPerDatastore = 5
# HA VM reset day(s) number
$HAVMresetold = 1
# HA VM restart day(s) number
$HAVMrestartold = 1
# VMHost/VMFS quota
$VMHostVMFSQuota = 28
# Datastore OverAllocation %
$OverAllocation = 100
# vSwitch Port Left
$vSwitchLeft = 5

# This section can be used to turn off certain areas of the report which may not be relevent to your installation
# Set them to $False if you do not want them in your output.

# Show headers for all selected tests (not just problem/issues)
$ShowAllHeaders = $true
# General Summary Info
$ShowGenSum = $true
# Show version information of PowerCLI and snapins
$showPowerCLIVersion = $true
# Show CPU Cluster Ratios
$ShowCPUClusterRatio = $true
# Show Memory Cluster Ratios
$ShowMemClusterRatio = $true
# Show vRAM Calculations
$ShowvRAM = $true
# Show Cluster configuration issues
$ShowClusterConfig = $true
  # Specific Cluster configuration issues
  $checkClusterDataStores = $true  #good for VM datastored
  $checkClusterLUNs = $true        #good for LUNs used by RDM
  $checkClusterPortGroups = $true  #mis-matched port groups within a cluster
$checkClusterBIOSVersions = $true #inconsistent BIOS versions in cluster
# Snapshot Information
$ShowSnap = $true
# Datastore Information
$ShowData = $true
# Show SSL Certificate status
$showSSLexpiration = $true
# Hosts in Maintenance mode
$ShowMaint = $true
# Hosts not responding or Disconnected
$ShowResDis = $true
#Show Host Hardware Issues
$ShowHostHdwrIssues = $true
#Show hosts without AD Auth enabled
$ShowHostADAuth = $true
# Dead LunPath
$ShowLunPath = $true
#Create Guest OS Pivot table
$ShowGuestOSPivot = $true
# VMs Created or cloned
$ShowCreated = $true
# VMs vCPU
$ShowvCPU = $true
# VMs Removed
$ShowRemoved = $true
# Powered Off VMs with last powered on task date
$showOffLastPoweredOn = $true
# Host Swapfile datastores
$ShowSwapFile = $true
# DRS Migrations
$ShowDRSMig = $true
# Cluster Slot Sizes
$ShowSlot = $true
# VM Hardware Version
$ShowHWVer = $true
# VI Events
$ShowVIevents = $true
# VMs in inconsistent folders
$ShowFolders = $true
# VM Tools
$ShowTools = $true
# Connected CDRoms
$ShowCDRom = $true
# ConnectedFloppy Drives
$ShowFloppy = $true
#Find unwanted virtual hardware
$ShowUnwantedHardware = $true
$unwantedHardware = "VirtualUSBController|VirtualParallelPort|VirtualSerialPort"
# NTP Issues
$ShowNTP = $true
# Single storage VMs
$ShowSingle = $true
# VM CPU Ready
$ShowCPURDY = $true
# Host Alarms
$ShowHostAlarm = $true
# VM Alarms
$ShowVMAlarm = $true
# Cluster Alarms
$ShowCLUAlarm = $true
# Show Datastore Over Allocation
$ShowOverAllocation = $true
# Show Host Uptime warnings
$CheckHostUptime = $true
# Show Host vCenter Update Manager Non Compliance
$ShowHostVUMNonCompliance = $true
# Show Host version pivot table (ESX vs ESXi/with build numbers)
$HostOSPivot = $true
# VCB garbage
$ShowVCBGarbage = $true
# Show CBT Variations
$ShowCBT = $true
$CBTdefault = "true"
# VC Service Details
$ShowVCDetails = $true
# VC Event Log Errors
$ShowVCError = $true
# VC Event Log Warnings
$ShowVCWarnings = $true
# VMKernel Warning entries
$ShowVMKernel = $true
# Show VM CPU Usage
$ShowVMCPU = $true
# Show virtual machines with resource limits
$VMResourceLimts = $true
#Show thick provisioned virtual disks
$ShowThickDisk = $true
#Show VMs whose names don't match the installed OS name
$ShowMisnamedVM = $true
#Show VMs whose configured OS doesn't match installed OS
$ShowWrongOS = $true
#Show VMs pointing at the wrong syslog server
$ShowWrongSyslog = $true
$syslogserver = "Your_syslog_server:514"
#Show ESXi hosts listening on port 21 (remote TSM enabled)
$ShowRemoteTSM = $true
# Show ESXi Tech Support mode
$ShowTech = $true
# Show ESXi Hosts which do not have lockdown mode enabled
$Lockdown = $true
# Show VMs disk space check
$ShowGuestDisk = $true
# Show Number of VMs per Datastore
$ShowNumVMperDS = $true
# Show Overcommit
$ShowOvercommit = $true
# Show Ballooning and Swapping for VMs
$ShowSwapBal = $true
# HA VM reset log
$ShowHAVMReset = $true
# Host ConfigIssue
$ShowHostCIAlarm = $true
# Map Disk Region Events (http://kb.vmware.com/kb/1007331)
$ShowMapDiskRegionEvents = $true
# Capacity Info
$ShowCapacityInfo = $false
$LimitDiskCapacityForecastToSharedStorageOnly = $false
# VMHost/VMFS Quota
$VMHostVMFS = $true
# Check inaccessible or invalid VM
$ShowBlindedVM = $true
# Check VMTools Issues
$ShowToolsIssues = $true
# Show VMTools that need updates
$Showtoolsupdate = $true
# Show VMTools installer connected
$ShowtoolsConnected = $true
# Check vSwitch Port Left
$ShowVSwitchCheck = $true