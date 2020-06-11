# --- Tidy up check
if (Get-Item .\Data\Example6.xlsx -ErrorAction SilentlyContinue) {Remove-Item .\Data\Example6.xlsx -Force -Confirm:$false}
if (Get-Item .\Data\Example7.xlsx -ErrorAction SilentlyContinue) {Remove-Item .\Data\Example7.xlsx -Force -Confirm:$false}
if (Get-Item .\Data\Example8.xlsx -ErrorAction SilentlyContinue) {Remove-Item .\Data\Example8.xlsx -Force -Confirm:$false}
if (Get-Item .\Data\Example9.xlsx -ErrorAction SilentlyContinue) {Remove-Item .\Data\Example9.xlsx -Force -Confirm:$false}

#--- Copy worksheet data from one spreadsheet to another
Invoke-Item .\Data\Example3.xlsx

Get-Service | Select-Object Name,DisplayName,Status,StartType | Export-Excel -WorkSheetname 'Services' -Path .\Data\Example6.xlsx -AutoSize

Copy-ExcelWorkSheet -SourceWorkSheet 'Services' -SourceWorkbook .\Data\Example3.xlsx -DestinationWorkSheet 'New Services Data' -DestinationWorkbook .\Data\Example6.xlsx -Show

# --- Handle Number Formatting
# --- No Number Formatting
Get-CimInstance win32_logicaldisk -filter "drivetype=3" | 
Select-Object DeviceID,Volumename,Size,Freespace | 
Export-Excel -Path .\Data\Example7.xlsx -Show -AutoSize

# --- Set number format to 0 decimal places
Get-CimInstance win32_logicaldisk -filter "drivetype=3" | 
Select-Object DeviceID,Volumename,Size,Freespace | 
Export-Excel -Path .\Data\Example8.xlsx -Show -AutoSize -NumberFormat "0"

# --- Set number format to a custom format to indicate percentages
$PercentageData = $(
    New-PSItem 1
    New-PSItem .5
    New-PSItem .3
    New-PSItem .41
    New-PSItem .2
    New-PSItem -.12
)

$PercentageData | Export-Excel -Path .\Data\Example9.xlsx -Show -AutoSize -NumberFormat "0.0%;[Red]-0.0%"

# --- Generate a spreadsheet with data from a table in Wikipedia
# --- The cmdlet name is possibly a little misleading
Start-Process 'chrome.exe' 'https://en.wikipedia.org/wiki/List_of_Buffy_the_Vampire_Slayer_episodes'

Import-Html -URL 'https://en.wikipedia.org/wiki/List_of_Buffy_the_Vampire_Slayer_episodes' -Index 1