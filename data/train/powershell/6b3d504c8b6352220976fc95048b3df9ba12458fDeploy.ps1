
Write-Host "Start Coping DB VHD from $DBVHDSOURCELOCATION to $DBVHDLOCATION - $((Get-Date).ToString("G"))"

#$DBVHDSOURCELOCATION = "\\d101666\f\"
#$DBVHDLOCATION = "V:\VMS\DEV03\"
#$VMNAME = "DEV_03"

#$DEV_03_DB_VhdFileName = "DEV_03_DB.vhd"
$DEV_03_DB_VhdFileName = "TestVHD.vhd"

$FullyQualifiedSourceFileName = "$DBVHDSOURCELOCATION\$DEV_03_DB_VhdFileName"

$FullyQualifiedDestinationFileName = "$DBVHDLOCATION\$DEV_03_DB_VhdFileName"

if ((Test-Path $DBVHDLOCATION) -and (Test-Path $DBVHDSOURCELOCATION ))
{
   try
   {
       $out = & 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' list runningvms 2>&1 | where {$_ -match $VMNAME}
       if($out)
       {
          # stop vm
		  Write-Host "Stoping VM $VMNAME - $((Get-Date).ToString("G"))"
          & 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' controlvm $VMNAME acpipowerbutton |Write-Host
       }
       copy-item -path $FullyQualifiedSourceFileName  -destination $FullyQualifiedDestinationFileName | Write-host
       
       #& 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' internalcommands sethduuid $DEV_03_DB_VhdFileName | Write-host
       
       Write-Host "Copy Complete - $((Get-Date).ToString("G"))"
   }
   catch
   {
       Write-Host "Copy Aborted  - $((Get-Date).ToString("G"))"  $error 
   }
}
elseif(Test-Path $DBVHDSOURCELOCATION)
{
    $VM_Drive_And_FileName = $DBVHDLOCATION -match '(?<drive_letter>.*(?=\:\\(?<directory_name>\w+)))'
    try
    {
        new-item -path "$Matches.drive_letter:\" -name $Matches.directory_name -type directory
        
        copy-item -path $FullyQualifiedSourceFileName  -destination $FullyQualifiedDestinationFileName 
        
        #& 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' internalcommands sethduuid $DEV_03_DB_VhdFileName | Write-Host
        
        Write-Host "Copy Complete - $((Get-Date).ToString("G"))"
    }
    catch
    {
         Write-Host "Copy Aborted  - $((Get-Date).ToString("G"))" $error
    }
}
else
{
    Write-Host "Copy Aborted: Source doen't exist! - $((Get-Date).ToString("G"))"
}


 

