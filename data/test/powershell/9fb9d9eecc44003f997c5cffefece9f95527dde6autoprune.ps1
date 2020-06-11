$freespace = Get-WmiObject win32_logicaldisk -filter "DeviceID='E:'" | Select-Object FreeSpace
$totalspace = Get-WmiObject win32_logicaldisk -filter "DeviceID='E:'" | Select-Object Size
$percentused = (($totalspace.Size - $freespace.FreeSpace)/$totalspace.Size)*100
$showsdir = @(Get-ChildItem E:\Media\TV | ?{$_.PSIsContainer} | Select-Object FullName)
$seasondir = @()
 
 
if ($percentused -ge 85){
     
    foreach ($show in $showsdir){
        $season = Get-ChildItem $show.FullName | ?{ $_.PSIsContainer } | Select-Object FullName
        $seasondir += $season
        }
     
    foreach ($season in $seasondir){
        Get-ChildItem $season.FullName | Where-Object {$_.LastWriteTime -lt (get-date).AddDays(-60)} | Format-Table -a FullName 
        #replace with remove-item -force for production use
        }
         
}
 
else{
     
    exit
    #Write-Host "Only"$percentused"% used."
}