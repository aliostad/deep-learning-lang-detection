param (
    [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $path = "C:\Users\jw8923\Desktop\test.xlsx", 
    [switch] $PassThru
)

Write-Host "Creating new Excel object..."
$objExcel = New-Object -ComObject Excel.Application

Write-Host "Entering Process..."
if ((test-path $path) -and ($path -match ".xl\w*$")) {
    $path = (resolve-path -Path $path).path 
    $savePath = $path -replace ".xl\w*$",".csv"
    Write-Host "Path is $path and savePath is $savePath"
    
    $objworkbook=$objExcel.Workbooks.Open( $path)
    Write-Host "Opened workbook"
    
    $objworkbook.SaveAs($savePath,6) # 6 is the code for .CSV 
    Write-Host "Saved to CSV"
    
    $objworkbook.Close($false) 
    if ($PassThru) {
        Import-Csv -Path $savePath
    }
}
else {
    Write-Host "$path : not found"
}

$objExcel.Quit()