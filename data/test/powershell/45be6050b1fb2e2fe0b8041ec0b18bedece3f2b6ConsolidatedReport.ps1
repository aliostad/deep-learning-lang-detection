$reportDir = $myinvocation.MyCommand.Definition | split-path -parent # destination's folder, it gets the script running folder
$smokeTestDir = ($reportDir | split-path -parent) + '\Smoke_Tests' # source 1 folder
$fullDir = ($reportDir | split-path -parent) + '\Full_Testing' # source 2 folder

$reportPath = $reportDir + '\ConsolidatedReport.xlsx' # destination's fullpath
$smokeTests = $smokeTestDir + '\Smoke_TestCases.xlsx' # source 1 fullpath
$fullTests = $fullDir + '\Full_TestCases.xlsx' # source 2 fullpath

$xl = new-object -c excel.application
$xl.displayAlerts = $false # don't prompt the user
$wb1 = $xl.workbooks.open($reportPath) # open target

while ($wb1.sheets.item(2).Name -ne $null) # delete existing sheets
{
	$wb1.sheets.item(2).delete()
}

$wb3 = $xl.workbooks.open($smokeTests, $null, $true) # open source 1 (Smoke), readonly
$wb2 = $xl.workbooks.open($fullTests, $null, $true) # open source 2 (Full), readonly

$sh1_wb1 = $wb1.sheets.item(1) # first sheet in destination workbook
$sheetToCopy = $wb3.sheets.item('Smoke_TCs') # source sheet to copy
$sheetToCopy.copy($sh1_wb1) # copy source sheet to destination workbook

$sh1_wb1 = $wb1.sheets.item(2)
$sheetToCopy = $wb2.sheets.item('Full_TCs')
$sheetToCopy.copy($sh1_wb1)

$sh1_wb1 = $wb1.sheets.item(3)
$sheetToCopy = $wb3.sheets.item('Smoke_Summary')
$sheetToCopy.copy($sh1_wb1)

$sh1_wb1 = $wb1.sheets.item(4)
$sheetToCopy = $wb2.sheets.item('Full_Summary')
$sheetToCopy.copy($sh1_wb1)

$sh1_wb1 = $wb1.sheets.item(5) # delete extra file
$sh1_wb1.delete()

$wb3.close($false) # close source 1 (Smoke) workbook w/o saving
$wb2.close($false) # close source 2 (VM) workbook w/o saving
$wb1.close($true) # close and save destination workbook
$xl.quit()
spps -n excel

# This is a sample code, if you have any questions, please, visit http://ap-test-team.blogspot.ru/