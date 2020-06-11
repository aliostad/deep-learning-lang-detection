Function Convert-xlsx {
    param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]
    $Path
    ,
    [Parameter(Mandatory=$true)]
    [string]
    $Destination
    )
        IF (!$Destination) {
        $Destination = $Path.Replace(".xlsx",".csv")
        }
            $objExcel = new-object -com Excel.Application;
            $objExcel.DisplayAlerts=$false;
            $objWorkBook = $objExcel.Workbooks.open($Path);
            $objWorkBook.SaveAs($Destination,6);
            $objExcel.Workbooks.close();
            $objExcel.quit();
}
