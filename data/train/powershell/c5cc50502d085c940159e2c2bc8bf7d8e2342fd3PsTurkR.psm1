#########################################################################################
# PsTurkR Module
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# CONTENTS
# about_PsTurkR

#########################################################################################
# Settings

[string]$Global:AmtModulePath = Get-Module -ListAvailable PsTurkR | Split-Path -Parent

#########################################################################################
<# 
 .SYNOPSIS 
  PowerShell scripts to access TurkR and Amazon Mechanical Turk

 .DESCRIPTION
  PowerShell scripts to access TurkR and Amazon Mechanical Turk
    
 .LINK
  http://www.mturk.com
  http://mturkdotnet.codeplex.com/
#>
function about_PsTurkR {}

#########################################################################################
# Exports 
Export-ModuleMember about_PsTurkR

# AmtUtil
# done in AmtUtil.ps1

# AmtApi Exports
# done in AmtApi.ps1

#########################################################################################