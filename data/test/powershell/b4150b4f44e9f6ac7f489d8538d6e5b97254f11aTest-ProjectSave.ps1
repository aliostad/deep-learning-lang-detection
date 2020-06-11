#
# test save of project
#

Remove-Item '.\Project Plan - asos_Cache.xml' -ErrorAction SilentlyContinue
Remove-Item '.\Project Plan - asos.xml' -ErrorAction SilentlyContinue
Remove-Item '.\Project Plan - asos.mpp' -ErrorAction SilentlyContinue

$localXmlFile = 'D:\Projects\ediTRACK\Project Plan - asos.xml'

Copy-Item '\\etfs05\Resource Plan\Project Plan - asos.mpp' '.\Project Plan - asos.mpp'

#region Project constants

# PjMergeType
$pjDoNotMerge = 0
$pjMerge      = 1
$pjPrompt     = 2
$pjAppend     = 3

# MsoAutomationSecurity
$msoAutomationSecurityLow          = 1  # Enables all macros. This is the default value when the application is started.
$msoAutomationSecurityByUI         = 2  # Uses the security setting specified in the Security dialog box.
$msoAutomationSecurityForceDisable = 3  # Disables all macros in all files opened programmatically, without showing any security alerts.

# PjFileFormat
$pjCSV   = 4   # Comma separated value (CSV) file.
$pjMPP   = 0   # Project 2010 or Project 2013 file.
$pjMPP12 = 23  # Office Project 2007
$pjMPP9  = 22  # Project 98, Project 2000, Project 2002, or Office Project 2003 file.
$pjMPT   = 11  # Project template.
$pjTXT   = 3   # Text file.
$pjXLS   = 5   # Excel workbook.
$pjXLSB  = 21  # Excel binary file.
$pjXLSX  = 20  # Excel OpenXML format file.

# PjSaveType
$pjDoNotSave  = 0  # Do not save.
$pjPromptSave = 2  # Prompt the user before saving.
$pjSave       = 1  # Save.

# PjPoolOpen
$pjDoNotOpenPool  = 4  # Do not open the pool.
$pjPoolAndSharers = 3  # Open pool and sharers.
$pjPoolReadOnly   = 1  # Open pool as read-only.
$pjPoolReadWrite  = 2  # Open pool as read/write.
$pjPromptPool     = 0  # Prompt the user before opening the pool.
#endregion

#
# let's open it and see what we find
#
$Project = New-Object -ComObject msproject.application  
$Project.Visible = $true
$Project.Application.AutomationSecurity = $msoAutomationSecurityForceDisable
$Project.Application.DisplayAlerts = $false
$Project.FileOpenEx($localFile,
                    $True,
                    $pjDoNotMerge,
                    $true,
                    "",
                    "",
                    $true,
                    "",
                    "",
                    "MSProject.mpp",
                    "",
                    $pjDoNotOpenPool
                   ) | Out-Null

#
# loop through the Resources for the Active Project
#
if ($false) {

$Project.FileSaveAs($localXmlFile)
$Project.Quit($pjDoNotSave)

#
# now read in the xml file
#
$info = Get-Content $localXmlFile
$doc = [xml]$info

write-host "done"

}


if ($false) {

if (Test-Path -LiteralPath $localXmlFile) {
  Remove-Item -LiteralPath $localXmlFile
}
Write-Host "Saving as ${localXmlFile}"
$Project.FileSaveAs($localXmlFile,$pjXLSX,$false,$false,$false,$false,"","","","MSProject.xml")

if (Test-Path -LiteralPath $localCsvFile) {
  Remove-Item -LiteralPath $localCsvFile
}
Write-Host "Saving as ${localCsvFile}"
$Project.FileSaveAs($localCsvFile,$pjCSV,$false,$false,$false,$false,"","","","MSProject.csv","BP Csv")

# 

}

$Project.FileSaveAs($localXmlFile,     # Name
                    $null,             # Format
                    $false,             # Backup
                    $false,             # ReadOnly
                    $true,             # TaskInformation
                    $false,             # Filtered
                    $null,             # Table
                    $null,             # UserID
                    $null,             # DatabasePassword
                    "MSProject.xml",   # FormatId
                    $null,             # Map
                    $null,             # Password
                    $null,             # WriteResPassword
                    $false,             # ClearBaseline
                    $false,             # ClearActuals
                    $false,             # ClearResourceRates
                    $false,             # ClearFixedCosts
                    $null,             # XMLName
                    $false              # ClearConfirmed
                    )

$Project.FileSaveAs($localXmlFile,     # Name
                    $null,             # Format
                    $false,             # Backup
                    $false,             # ReadOnly
                    $true,             # TaskInformation
                    $false,             # Filtered
                    $null,             # Table
                    $null,             # UserID
                    $null,             # DatabasePassword
                    "MSProject.xml"    # FormatId
                    )

$Project.FileSaveAs($localXmlFile,$pjXLSX)

$Project.FileSaveAs($localXmlFile)

$Project.Quit($pjDoNotSave)
