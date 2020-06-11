# Copyright © 2008, Microsoft Corporation. All rights reserved.

PARAM($RepairName, $RepairText, $FailResolution)
#Non NDF Informational Resolution (defined non-manual so we don't need to prompt the user to see the repair)

#include utility functions
. .\UtilityFunctions.ps1
Import-LocalizedData -BindingVariable localizationString -FileName LocalizationData

#the strings come in as raw resource strings, load the actual strings
$repairNameStr = LoadResourceString $RepairName;
$repairTextStr = LoadResourceString $RepairText;

#display the help topic interaction
Get-DiagInput -ID "IT_InfoOnlyRepair" -Parameter @{"IT_P_Name"=$repairNameStr; "IT_P_Description"=$repairTextStr; }

if($FailResolution -eq "TRUE")
{
    throw "Issue not resolved."
}
