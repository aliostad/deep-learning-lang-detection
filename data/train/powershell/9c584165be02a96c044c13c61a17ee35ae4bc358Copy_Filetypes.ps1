#copy-item C:\Users\Kristen\Desktop\tmp\cut_paste\items\* -destination C:\Users\Kristen\Desktop\tmp\cut_paste -recurse -PassThru 
#move-item C:\Users\Kristen\Desktop\tmp\cut_paste\items\* -destination C:\Users\Kristen\Desktop\tmp\cut_paste -PassThru 

$pathname = read-host "Enter the path to your files."

$file_type = read-host "Enter the file extension you would like moved."

$destination = read-host "Enter the destination for your files."

#$content = Get-ChildItem C:\Users\Kristen\Desktop\tmp\cut_paste\items -recurse
$content = Get-ChildItem $pathname -recurse

#$copy = $content | where {$_.extension -eq ".txt" -or $_.extension -eq ".pdf"}
$copy = $content | where {$_.extension -eq ".$file_type"}

#$copy | move-item -destination C:\Users\Kristen\Desktop\tmp\cut_paste -whatif
$copy | copy-item -destination $destination -force

Write-Host $copy.Count "items were moved!"