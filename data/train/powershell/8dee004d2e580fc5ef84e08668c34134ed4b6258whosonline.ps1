function Excel_load {
    Write-Progress -Activity "Starting Excel" -Status "loading $Excel_file" -PercentComplete (0)
    $xl = New-Object -comobject "Excel.Application"
    $xl.Visible = $False

    $wb = $xl.Workbooks.Open($Excel_file)
    $ws = $wb.Sheets.Item(1)

    $rowcounter = 2
    $rowdata = @()
    $schoolnames = @()
    $data = $ws.Cells.Item($rowcounter, 3).Value()
    $sname = $ws.Cells.Item($rowcounter, 1).Value()

    do {
        Write-Progress -Activity $rowcounter -Status "loading  $data" -PercentComplete (0)
        $rowdata += $data
        $schoolnames += $sname
        $rowcounter++
        $data = $ws.Cells.Item($rowcounter, 3).Value()
        $sname = $ws.Cells.Item($rowcounter, 1).Value()
    }
    while ($data -ne $null)
    
    $rowdata
    $null = $xl.Quit()
    $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
} # end of Excel_load

$myPath =  split-path $SCRIPT:MyInvocation.MyCommand.Path -parent # (the path to this powershell script file)
$Excel_file = $myPath + "\schools.xls"

 $targets = Excel_load

