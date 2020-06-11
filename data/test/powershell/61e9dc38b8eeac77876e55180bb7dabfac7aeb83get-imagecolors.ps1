#requires -version 4
Function Get-ImageColor{
<#
.SYNOPSIS
  Analyse and extract the predominant colors from one or several images.
.DESCRIPTION
  The Get-ImageColor function is part of Imagga module. It analyses and extract the predominant colors from one or several images.
.PARAMETER url
  The url of the image to be tagged. It has to be accessible from imagga server, so make sure it's a public url.
.PARAMETER apikey
  Your imagga API key. If you don't have one follow the doc: https://docs.imagga.com/#introduction
.PARAMETER secret
  Your imagga API secret.
.PARAMETER noOverallColors
  Exclude the overall image colors from extraction.
.PARAMETER noObjectColors
  Force the service not to extract object and non-object (a.k.a. foreground and background) colors separately. 
.INPUTS
  None
.OUTPUTS
  A JSON containing suggested tags.
.NOTES
  Version:        1.0
  Author:         Marco Torello
  Creation Date:  10/10/2016
  Purpose/Change: Initial script development
  
.EXAMPLE
  Get-ImageColor -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -apikey '1111111111' -apisecret '1dsa23dasd234dfg354'
  
.EXAMPLE
  Get-ImageColor -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -imaggaObj $credential
#>



  [CmdletBinding()]
  Param(
      [parameter(Mandatory=$true)] [String] $url,
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $apikey,
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $secret,
      [parameter(ParameterSetName="ConnectionObject",Mandatory=$true)] [pscredential] $imaggaObj,
      [switch] $noOverallColors,
      [switch] $noObjectColors
  )
  
  Begin{
    Write-debug "Starting execution of Get-ImageColor. Url is: $url"
  }
  
  Process{
    if ($PsCmdlet.ParameterSetName -eq "ApiKey"){
      $mycreds = new-imaggaConnection -apikey $apikey -secret $secret
    }

    if ($PsCmdlet.ParameterSetName -eq "ConnectionObject"){
      $mycreds = $imaggaObj
    }

    _CheckValidImage -url $url
    $urlOptions = "url=$url"

    if ($noOverallColors){
        $urlOptions += "&extract_overall_colors=0"
    }
    
    if ($noObjectColors){
        $urlOptions += "&extract_object_colors=0"
    }

    Try{
        $json = _InvokeImaggaApi -credential $mycreds -parameters $urlOptions -function 'colors'
    }
    Catch{
      Write-debug $_.Exception 
      Throw "Problem contacting imagga API"
      $json = $null
    }
    
    return $json 
  }
  
  End{
    If($?){
      Write-debug "Completed Successfully."
    }
  }
}
