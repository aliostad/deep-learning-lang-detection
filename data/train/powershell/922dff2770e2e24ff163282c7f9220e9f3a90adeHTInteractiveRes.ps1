# Copyright © 2008, Microsoft Corporation. All rights reserved.

PARAM($RepairName, $RepairText, $HelpTopicLink, $HelpTopicLinkText, $FailResolution)
#Non NDF Help Topic Resolution (defined non-manual so we don't need to prompt the user to see the repair)

#include utility functions
. .\UtilityFunctions.ps1
Import-LocalizedData -BindingVariable localizationString -FileName LocalizationData

#the strings come in as raw resource strings, load the actual strings
$repairNameStr = LoadResourceString $RepairName;
$repairTextStr = LoadResourceString $RepairText;
$helpTopicLinkTextStr = LoadResourceString $HelpTopicLinkText

#display the help topic interaction
Get-DiagInput -ID "IT_HelpTopicRepair" -Parameter @{"IT_P_Name"=$repairNameStr; "IT_P_Description"=$repairTextStr; "IT_P_HelpTopicText" = $helpTopicLinkTextStr; "IT_P_HelpTopicLink" = $HelpTopicLink;}

if($FailResolution -eq "TRUE")
{
    throw "Issue not resolved."
}
