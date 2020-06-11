cls
$ConnectionString = "Data Source=L80\SQL2012;Initial Catalog=tempdb;Integrated Security=True;"
#$ErrorActionPreference = "Stop"

[System.Reflection.Assembly]::LoadFrom(".\CsvDataReader\bin\Debug\CsvDataReader.dll")

$reader = New-Object SqlUtilities.CsvDataReader(".\CsvDataReaderTest\SimpleCsv.txt")

#while ($reader.Read())
#{
#    $reader.GetValue(0);
#}
#
#$reader.Close();
#$reader.Dispose();

$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $ConnectionString
$bulkCopy.DestinationTableName = "CsvDataReader"
$bulkCopy.BatchSize = 100000
$bulkCopy.BulkCopyTimeout = 0

# Sample syntax if column mapping is needed
# Columns ARE CASE SENSITIVE!
# $bulkCopy.ColumnMappings.Add("PrimaryNumber", "PrimaryNumber") | Out-Null

$bulkCopy.WriteToServer($reader);

$reader.Close();
$reader.Dispose();