##################################################################################
#
#
#  Script name: 	Get-SI-Archive-Items-To-Fix.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

param([string]$starter, [switch]$help)
#Load Assembly
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: GetSIArchiveItemsToFix
Extracts the 

PARAMETERS: 
-starter: the counter to start at.

SYNTAX:

GetSIArchiveItemsToFix -starter "0"

Writes the items of interest to a specified CSV to "SIItemsToUpdate"

Write-List -help

Displays the help topic for the script

"@
$HelpText

}

#Load Assembly

$env:path = $env:path +";D:\Scripts\Collection"

#URL of Site Collection
$url = "http://xxxx:14000"

#Other Variables
#$csvfile = ".\SIItemsToUpdate.csv" #This is for the log file
$web = "/SafetyEnvironment/SafetyInteractions/" #The subsite you are working on
$listname = "My List"

$csvtracker = ".\Tracker.csv"

$csvDate = Get-Date -format yyyyMMdd-HHmm
$csvOutput = ".\SIItemsToUpdate." + $csvDate + ".csv" 

#Load SP Objects
$spsite = New-Object microsoft.sharepoint.spsite($url)
$spweb = $spsite.Openweb($web)
$splist = $spweb.Lists[$listname]

$listcount = $splist.items.count

$upperbound = [int]$starter + 4999

$archivedItems = $splist.Items[$starter..$upperbound] | where {$_["Archived Date"] -ne $null} | select ID, @{label="ArchivedDate";Expression={$_["Archived Date"]}}, 
@{label='Date of Observation';expression={$_["Date of Observation"];}},
@{label='Due Date';expression={$_["Due Date"];}},
@{label='Follow Up Due Date';expression={$_["Follow Up Due Date"];}},
@{label="Processed";Expression={$false}}

$archivedItems | Export-Csv -Path $csvOutput -NoTypeInformation

$newstart = $upperbound, $csvOutput, "UnProcessed"

$newstart | add-content -path $csvtracker
