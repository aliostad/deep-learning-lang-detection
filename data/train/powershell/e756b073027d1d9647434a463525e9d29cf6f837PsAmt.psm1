#########################################################################################
# PsAmt Module
# stwehrli@gmail.com
# 28apr2014
#########################################################################################

# Contents
# about_PsAmt

#########################################################################################
# Settings

[string]$Global:AmtModulePath = Get-Module -ListAvailable PsAmt | Split-Path -Parent

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
function about_PsAmt {}

#########################################################################################
# Exports 
Export-ModuleMember about_PsAmt

# AmtUtil
# done in AmtUtil.ps1

# AmtApi Exports
# done in AmtApi.ps1

#########################################################################################