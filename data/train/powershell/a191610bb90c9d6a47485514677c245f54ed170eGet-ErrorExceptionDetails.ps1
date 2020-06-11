###############################################################################
##  $FileName: Get-ErrorExceptionDetails.ps1
##  $Version: 1.0
##  $Description:
###############################################################################

<#
.Synopsis
  Returns the Error Exception's message and ItemName
	
.DESCRIPTION
  Returns the Error Exception's message and ItemName
	
.PARAMETER Error 
  Error object. Uses $error[0] if not specified
#>
function Get-ErrorExceptionDetails {
  [CmdletBinding()]
  param (
    [parameter(
      Mandatory=$true,
      ValueFromPipeline=$true,
      Position=0)]$Error
  )
	   
  $ExceptionMessage = $Error.Exception.Message
	$ExceptionItemName = $Error.Exception.ItemName
	
	return $ExceptionMessage, $ExceptionItemName
	
} # function Get-ErrorExceptionDetails




