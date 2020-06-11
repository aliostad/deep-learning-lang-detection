# --- Export to Excel
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-Excel -Path .\Data\Example2.xlsx -Show

# --- Export to Excel specifying Worksheet name and format the file to column width
Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-Excel -WorkSheetname 'Services' -Path .\Data\Example3.xlsx -AutoSize -Show

# --- Tidy up check
if (Get-Item .\Data\Example5.xlsx -ErrorAction SilentlyContinue) {Remove-Item .\Data\Example5.xlsx -Force -Confirm:$false}

# --- Get process data and include a chart.
# --- Most parameters are supplied via splatting
$Data = Invoke-Sum (Get-Process) company handles,pm,VirtualMemorySize

$Chart = New-ExcelChart -Title Stats `
    -ChartType LineMarkersStacked `
    -Header "Stuff" `
    -XRange "Processes[Company]" `
    -YRange "Processes[PM]","Processes[VirtualMemorySize]"
 
$ExcelParams = @{

    WorksheetName = 'Processes'
    Path = '.\Data\Example5.xlsx'
    AutoSize = $true
    Show = $true
}

$Data | Export-Excel @ExcelParams -TableName Processes -ExcelChartDefinition $Chart