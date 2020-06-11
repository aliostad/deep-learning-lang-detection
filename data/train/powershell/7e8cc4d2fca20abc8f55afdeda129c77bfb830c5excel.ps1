[Reflection.Assembly]::LoadFrom("c:\dll\NPOI.OpenXml4Net.dll");
[Reflection.Assembly]::LoadFrom("c:\dll\NPOI.OpenXmlFormats.dll");
[Reflection.Assembly]::LoadFrom("c:\dll\ICSharpCode.SharpZipLib.dll");
[Reflection.Assembly]::LoadFrom("c:\dll\NPOI.dll");
[Reflection.Assembly]::LoadFrom("c:\dll\NPOI.OOXML.dll");

if (Test-Path  ("C:\temp\Result.xlsx"))
{
    Remove-Item "C:\temp\Result.xlsx";
}
$Connection="Server=aaaa;Database=msdb;Trusted_Connection=True;";
$Query="SELECT  T.NAME AS [TABLE NAME], C.NAME AS [COLUMN NAME], P.NAME AS [DATA TYPE], P.MAX_LENGTH AS[SIZE],   CAST(P.PRECISION AS VARCHAR) +'/'+ CAST(P.SCALE AS VARCHAR) AS [PRECISION/SCALE]
FROM SYS.OBJECTS AS T
JOIN SYS.COLUMNS AS C
ON T.OBJECT_ID=C.OBJECT_ID
JOIN SYS.TYPES AS P
ON C.SYSTEM_TYPE_ID=P.SYSTEM_TYPE_ID
WHERE T.TYPE_DESC='USER_TABLE';";

$SqlDataAdapter = new-object  System.Data.SqlClient.SqlDataAdapter ($Query, $Connection)
$SqlDataTable = new-object System.Data.DataTable;
try {
    $SqlDataAdapter.fill($SqlDataTable) | out-null;
    $wb = New-Object NPOI.XSSF.UserModel.XSSFWorkbook;
    
    $ws=$wb.CreateSheet("output");
    $ws.CreateRow(0)| out-null;
    for($i = 0; $i -lt $SqlDataTable.Columns.Count; $i++){
         $ws.GetRow(0).CreateCell($i).SetCellValue($SqlDataTable.Columns[$i].ColumnName)| out-null;
     }
     for($i = 0; $i -lt $SqlDataTable.Rows.Count; $i++){
     $ws.CreateRow(($i+1))| out-null;
  		for($j = 0; $j -lt $SqlDataTable.Columns.Count; $j++){
            $ws.GetRow($i+1).CreateCell($j).SetCellValue($SqlDataTable.Rows[$i][$j].ToString())| out-null;      	
  		}
	}
    $fs = new-object System.IO.FileStream("C:\temp\Result.xlsx",[System.IO.FileMode]'Create',[System.IO.FileAccess]'Write')
	$wb.Write($fs);
	$fs.Close()
    $SqlDataTable.Clear();
    $SqlDataTable.Dispose();
    [system.threading.Thread]::Sleep(10000);
}
catch [Exception] {
   throw $_.Exception;   
} 
