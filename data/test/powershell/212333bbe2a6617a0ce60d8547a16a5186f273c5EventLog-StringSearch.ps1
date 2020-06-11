#Measure-Command { 
$count = '3'
$Logs = Get-EventLog -LogName Application -InstanceId '1073741869' -Newest $count -Message "*MWR*"
foreach ($Log in $Logs) {
    $Lines = @()
    $Lines = $Log.Message.Split("`n")
    Foreach ($Line in $Lines) {
        If ($Line -like "Name: MWR*") { 
            $LowValue = $null
            $UpValue = $null
            $LowValue = [array]::IndexOf($Lines,$Line)
            $UpValue = $LowValue + 7
            $Lines[$LowValue]
            $Lines[$UpValue]
        }
    }
}
# }