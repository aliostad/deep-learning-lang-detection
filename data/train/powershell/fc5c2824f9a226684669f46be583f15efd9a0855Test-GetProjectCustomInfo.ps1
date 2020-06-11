#
# get custom fields for MS Project
#
param ($localFile = 'D:\Projects\ediTRACK\Project Plan - Windsor.mpp')

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

$Project = New-Object -ComObject msproject.application  
$Project.Visible = $Visible
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
# get the BuiltinDocumentProperties
#
$properties = $Project.ActiveProject.BuiltinDocumentProperties

# Write-Host "File: ${localFile}"

.\Get-DocumentProperties.ps1 -PropertyCollection $properties -FullName $localFile

$Project.Quit($pjDoNotSave)

write-host "Done"