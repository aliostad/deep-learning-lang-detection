# on recupere le repertoire courant
$rep = (Get-Location).path
$server=$rep.split("\\""_")[5]

$destination="D:\_Stordata\traitement-ntw"
$sources="$destination\sources\$server"

If (-not (Test-Path $sources)) { New-Item -ItemType Directory $sources }
if(test-path "$sources\07-get-ssfailed*.xlsx") {remove-item "$sources\07-get-ssfailed*.xlsx"}

$ntwreport=".\STD.su.ssdc.failed.output.csv"

if ((test-path $ntwreport) -eq "true") {


$ssfailed=import-csv $ntwreport -Header "Client Name", "Save Set Name", "Save Set ID", "Group Start Time", "Save Type", "Level", "Status" | where {$_.status -match "failed"}

$Excel = New-Object -ComObject excel.application 
$workbook = $Excel.workbooks.add() 

$xlout = "$($sources)\07-get-ssfailed.xlsx"
$i = 1 
foreach($results in $ssfailed) 
{
 $excel.cells.item($i,1) = $results."Client Name"
 $excel.cells.item($i,2) = $results."Save Set Name"
 $excel.cells.item($i,3) = $results."Group Start Time"
 $excel.cells.item($i,4) = $results."Save Type"
 $excel.cells.item($i,5) = $results."Level"
 $excel.cells.item($i,6) = $results."Status"

 $i++ 
} 
$Excel.visible = $false

$Workbook.SaveAs($xlout, 51)
$excel.Quit()
}
else {
echo "pas de fichier $ntwreport"
}