$Debug = $args[-1] -eq "debug"
Set-Variable RepDir "h:\Îòäåë ñîïðîâîæäåíèÿ ðûíêà\Îò÷åòû\Äëÿ ñîãëàñîâàíèÿ" -option constant
if ($Debug) {$Line = "-------------------------------------------------------------------------------------------------------------------------------------------"}
if ($Debug) {$DF = "CopyReport.debug"}
if ($Debug) {"Debug # Copy-Report #  Date: $([DateTime]::Now)" > $DF}
if ($Debug) {$Line >>$DF}
$a0 = $args[0]
$a1 = $args[1]
$a2 = $args[2]
if ($Debug) {$a0 >>$DF}
if ($Debug) {$a1 >>$DF}
if ($Debug) {$a2 >>$DF}
$SubLbl = ?? {$a0} {"Unknown"}
if ($Debug) {"Label: $SubLbl" >>$DF}
$ToFolder = ?? {$a1} {""}
if ($Debug) {$ToFolder >>$DF}
if ($Debug) {$Line >>$DF}
$CopiedAttrib = @{}
Dir "$RepDir\*$SubLbl*.xls" | % {$CopiedAttrib[$_.Name]=$_.LastWriteTime}
if ($Debug) {Test-Path "$ToFolder" -PathType Container >>$DF}
if (Test-Path "$ToFolder" -PathType Container)
{
  Dir "$ToFolder\*$SubLbl*.xls" | % {$CopiedAttrib[$_.Name]=$CopiedAttrib[$_.Name]-$_.LastWriteTime}
}
else
{
  "ScriptRes:Bad:NoFolder"
  exit
}
if ($Debug) {$CopiedAttrib >>$DF}
if ($Debug) {$Line >>$DF}
$FilesToCopy = $CopiedAttrib.GetEnumerator() | ? {$_.Value -ne 0} | % {$_.Key}
if ($Debug) {$FilesToCopy >>$DF}
if ($Debug) {$Line >>$DF}
if ($Debug) {$(($FilesToCopy.Length -eq 0) -or ($FilesToCopy -eq $null)) >>$DF}
if (($FilesToCopy.Length -eq 0) -or ($FilesToCopy -eq $null))
{
  "ScriptRes:Ok:NoNeed"
  exit
}
$To = ?? {$a2} {"asqe@rduvolgograd.ru"}
$Body = "Âûëîæåíû íîâûå äàííûå äëÿ ñîãëàñîâàíèÿ çà: `n"+$($FilesToCopy | % {$_.Substring(13,6)} | Sort)
Mail -To $To -Subject "Ñîãëàñîâàíèå ãåíåðàöèè" -Body $Body
if ($Debug) {$Line >>$DF}
Copy $($FilesToCopy | % {"$RepDir\$_"}) -Destination $ToFolder
$Cnt = ?: {$FilesToCopy -is [String]} {1} {$FilesToCopy.Length}
"ScriptRes:Ok:$Cnt"