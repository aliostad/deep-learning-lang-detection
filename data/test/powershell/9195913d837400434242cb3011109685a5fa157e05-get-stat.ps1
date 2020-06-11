# on recupere le repertoire courant
$rep = (Get-Location).path
$server=$rep.split("\\""_")[5]

$destination="D:\_Stordata\traitement-ntw"
$sources="$destination\sources\$server"

If (-not (Test-Path $sources)) { New-Item -ItemType Directory $sources }
if(test-path "$sources\05-get-stat*.xlsx") {remove-item "$sources\05-get-stat*.xlsx"}

$ntwreport=".\STD.sa.ms.output.csv"

if ((test-path $ntwreport) -eq "true") {


$stat=ipcsv $ntwreport -Header "Month", "Amount of Data (B)", "Number of Files", "Number of Save Sets" | where {$_."Number of Files" -match '[0-9]'}

$Excel = New-Object -ComObject excel.application 
$workbook = $Excel.workbooks.add() 

$xlout = "$($sources)\05-get-stat.xlsx"
$i = 1 
foreach($results in $stat) 
{
$results."Amount of Data (B)"=$results."Amount of Data (B)" -replace ',', ''
$results."Number of Files"=$results."Number of Files" -replace ',', ''
$results."Number of Save Sets"=$results."Number of Save Sets" -replace ',', ''

$results."Amount of Data (B)"=$results."Amount of Data (B)" -replace ' ', ''
$results."Number of Files"=$results."Number of Files" -replace ' ', ''
$results."Number of Save Sets"=$results."Number of Save Sets" -replace ' ', ''

 $excel.cells.item($i,1) = $results."Month"
 $excel.cells.item($i,2) = $results."Amount of Data (B)"
 $excel.cells.item($i,3) = $results."Number of Files"
 $excel.cells.item($i,4) = $results."Number of Save Sets"


 $i++ 
} 
$Excel.visible = $false

$Workbook.SaveAs($xlout, 51)
$excel.Quit()
}
else {
echo "pas de fichier $ntwreport"
}