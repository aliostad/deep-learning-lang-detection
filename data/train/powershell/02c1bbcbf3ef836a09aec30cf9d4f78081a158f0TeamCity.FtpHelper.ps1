# 
# Imbibe Technologies Pvt Ltd® - http://imbibe.in
# Copyright (c) 2014
# by Imbibe Technologies Pvt Ltd
# 
# This software and associated files including documentation (the "Software") is goverened by Microsoft Public License (MS-PL),
# a copy of which is included with the Software as a text file, License.txt.

function escapeTeamCityBuildOutput ([string] $value) {
	$value = $value.Replace("|", "||").Replace("'", "|'").Replace('`n', '|`n').Replace('`r', '|`r').Replace("[", "|[").Replace("]", "|]");
                
    return ($value);
}

function writeTeamCityMessage ($message, $errorDetails, $status) {
    $message = escapeTeamCityBuildOutput($message)
	$output = "##teamcity[message text='" + $message + "'";
    
    if($errorDetails -ne $null){
        $errorDetails = escapeTeamCityBuildOutput($errorDetails);
        $output = $output + " errorDetails='" + $errorDetails + "'";
    }
    
    $output = $output + " status='" + $status + "']";
    
    Write-Host $output;
}

