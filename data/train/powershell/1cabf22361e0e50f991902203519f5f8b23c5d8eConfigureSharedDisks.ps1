# ConfigureSharedDisks.ps1

# $SHAREDDISKXMLFILENAME='.\Install\Cluster\SharedDiskConfigSharedDB.xml'

#########################################################################
# Author: Stiven Skoklevski,
# Bring Shared disks online, initialised and then offline in preparation to be used by Windows Cluster
#########################################################################

#####################################################
# Configure drive
#####################################################
function ConfigureDrive([object]$disk, [string]$diskLabel, [string]$driveLetter)
{
    log "INFO: Configuring Drive - Label:$diskLabel, Letter: $driveLetter for drive number $($disk.Number) with friendly name '$($disk.FriendlyName)' "
    
    log "INFO: Stop the windows prompt asking to format drive."
    Stop-Service ShellHWDetection

    log "INFO: Setting disk to online"
    $disk | Set-Disk -IsOffline $false

    # once the disk is initialised for the first time this command will throw the exception 
    # 'Initialize-Disk : The disk has already been initialized.'
    # This exception can be ignored.
    log "INFO: Initialising disk"
    $disk | Initialize-Disk -PartitionStyle GPT -ErrorAction SilentlyContinue

    log "INFO: Create new partition"
    New-Partition –DiskNumber $($disk.Number) –DriveLetter $driveLetter -UseMaximumSize 

    # creating the partition takes time which cause the format volume to throw an exception that the disk is read-only,
    # so sleep to allow creation of partition to complete
    Start-Sleep -Seconds 10

    log "INFO: Format the volume"
    Format-Volume –DriveLetter $driveLetter –FileSystem NTFS -NewFileSystemLabel $diskLabel -Confirm:$false -AllocationUnitSize 65536

    log "INFO: Start the windows prompt asking to format drive."
    Start-Service ShellHWDetection

    # The SMS product installs software on all disks that do NOT contain a file with this name.
    # The SMS software should only be installed on the shared disk named PCDEVICES which is why this file is not created on this drive.
    if($diskLabel -ne "PCDEVICES")
    {
        $file = "$($driveLetter):\NO_SMS_ON_DRIVE.sms"
        New-Item $file -Type file -Force
        log "INFO: Created file: '$file'"
    }

    # store disk information so the disk can be set to offline. Not done here to ensure the disk is not reused
    $formattedDisks.add($disk.Number)

    log "INFO: Configured Drive - Label:$diskLabel, Letter: $driveLetter for drive number $($disk.Number) with friendly name '$($disk.FriendlyName)' "
}

#####################################################
# Manage Disks
#####################################################
function ManageDisks($xmlNodes)
{

    foreach($node in $xmlNodes)
    {

        # configure the disks. Execute within loop to pick up any changes from previous loop
        $disks = Get-Disk | Where-Object `
                            {($_.Path -like '*scsi*') -and `
                            ($_.IsClustered -eq $false) }
       
        # execute within loop to pick up any new volumes from previous loop
        $volumes = Get-Volume | Where-Object {$_.DriveType -eq "Fixed"}

        $diskLabel = $node.attributes['DiskLabel'].value
        $driveLetter = $node.attributes['DriveLetter'].value
        $type = $node.attributes['Type'].value
        $size = $node.attributes['Size'].value

        if([String]::IsNullOrEmpty($diskLabel))
        {
            log "WARN: diskLabel is empty."
            continue                            
        }
        if([String]::IsNullOrEmpty($driveLetter))
        {            
            log "WARN: driveLetter is empty."
            continue                            
        }
        if([String]::IsNullOrEmpty($type))
        {            
            log "WARN: type is empty."
            continue                            
        }
        if([String]::IsNullOrEmpty($size))
        {            
            log "WARN: size is empty."
            continue                            
        }

        log "INFO: ****************** Starting disk configuration for $diskLabel  ******************"
 
        $volumeLabelExists = $volumes | Where-Object {$_.FileSystemLabel -eq $diskLabel }
        if($volumeLabelExists -ne $null )
        {
            log "Warn: Volume with label $diskLabel already exists. Skipping"
            continue
        }

        $volumeLetterExists = $volumes | Where-Object {$_.DriveLetter -eq $driveLetter }
        if($volumeLetterExists -ne $null )
        {
            log "Warn: Volume with letter $driveLetter already exists. Skipping"
            continue
        }

        # find the disk that matches the Size property in the XML
        $GBconversion = 1073741824
        $diskSizeKB = $GBconversion * [double]$size
        log "INFO: Disk Size in KB: $diskSizeKB size in GB from XML: $size"

        $candidateDisks = $disks | Where-Object {$_.Size -eq $diskSizeKB -and ($_.PartitionStyle -eq "RAW" -or $_.OperationalStatus -eq "Offline")}
        if($candidateDisks -eq $null)
        {
            log "WARN: Disk of Size: $diskSizeKB could not be found. Skipping"
            continue
        }

        ConfigureDrive $candidateDisks[0] $diskLabel $driveLetter
    }
}

#####################################################
# Main
#####################################################


. .\FilesUtility.ps1
. .\VariableUtility.ps1
. .\PlatformUtils.ps1
. .\LaunchProcess.ps1

if([String]::IsNullOrEmpty($SHAREDDISKXMLFILENAME))
{
   log "The SHAREDDISKXMLFILENAME parameter is null or empty."
}
else
{
    # *** configure and validate existence of input file
    $inputFile = "$scriptPath\$SHAREDDISKXMLFILENAME"

    if ((CheckFileExists( $inputFile)) -ne $true)
    {
        log "ERROR: $inputFile is missing, users will not be configured."
        return
    }

    log "INFO: ***** Executing $inputFile ***********************************************************"

    $formattedDisks = New-Object collections.arraylist

    # Get the xml Data
    $xml = [xml](Get-Content $inputFile)

    $nodes = $xml.SelectNodes("//*[@DiskLabel]")

    ManageDisks $nodes

    # set disks to Offline in prep for the Cluster
    foreach($formattedDisk in $formattedDisks)
    {
        $disk = Get-Disk -Number $formattedDisk

        log "INFO: Setting disk: $formattedDisk to offline"
        $disk | Set-Disk -IsOffline $true
        log "INFO: Set disk: $formattedDisk to offline"
    }
}