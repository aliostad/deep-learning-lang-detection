# on recupere le repertoire courant
$rep = (Get-Location).path
$server=$rep.split("\\""_")[5]

$destination="D:\_Stordata\traitement-ntw"
$sources="$destination\sources\$server"

If (-not (Test-Path $sources)) { New-Item -ItemType Directory $sources }
if(test-path "$sources\16-get-dedup.xlsx") {remove-item "$sources\16-get-dedup.xlsx"}

$ntwreport="STD.dd.ds.output.csv"

if ((test-path $ntwreport) -eq "true") {


$stat=ipcsv $ntwreport -Header "Date", "Amount of Data (B)", "Target Size (B)", "Deduplication Ratio (%)", "Number of Files", "Number of Save Sets" | where {$_."Number of Save Sets" -match '[0-9]'}

$Excel = New-Object -ComObject excel.application 
$workbook = $Excel.workbooks.add() 

$xlout = "$($sources)\16-get-dedup.xlsx"
$i = 1 
foreach($results in $stat) 
{
$results."Amount of Data (B)"=$results."Amount of Data (B)" -replace ',', ''
$results."Number of Files"=$results."Number of Files" -replace ',', ''
$results."Number of Save Sets"=$results."Number of Save Sets" -replace ',', ''
$results."Target Size (B)"=$results."Target Size (B)" -replace ',', ''

$results."Amount of Data (B)"=$results."Amount of Data (B)" -replace ' ', ''
$results."Number of Files"=$results."Number of Files" -replace ' ', ''
$results."Number of Save Sets"=$results."Number of Save Sets" -replace ' ', ''
$results."Target Size (B)"=$results."Target Size (B)" -replace ' ', ''


 $excel.cells.item($i,1) = $results."Date"
 $excel.cells.item($i,2) = $results."Amount of Data (B)"
 $excel.cells.item($i,3) = $results."Target Size (B)"
 $excel.cells.item($i,4) = $results."Deduplication Ratio (%)"


 $i++ 
} 
$Excel.visible = $false

$Workbook.SaveAs($xlout, 51)
$excel.Quit()
}
else {
echo "pas de fichier $ntwreport"
}