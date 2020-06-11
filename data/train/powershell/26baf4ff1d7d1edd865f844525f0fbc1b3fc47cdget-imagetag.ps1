#requires -version 4
Function Get-ImageTag{
<#
.SYNOPSIS
  Get recommended tags from imagga
.DESCRIPTION
  The Get-ImageTag function is part of Imagga module. It retrieves the suggested tags to associate to the image passed as parameter.
.PARAMETER url
  The url of the image to be tagged. It has to be accessible from imagga server, so make sure it's a public url.
.PARAMETER language
  The tags languages. Supported languages can be found here: http://docs.imagga.com/#multi-language-support.
.PARAMETER apikey
  Your imagga API key. If you don't have one follow the doc: https://docs.imagga.com/#introduction
.PARAMETER secret
  Your imagga API secret.
.PARAMETER imaggaObj
  The connection object created using new-imaggaconnection.
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
  Get-ImageTag -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -apikey '1111111111' -apisecret '1dsa23dasd234dfg354'
  
.EXAMPLE
  Get-ImageTag -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -imaggaObj $credential
#>

  [CmdletBinding()]
  Param(
      [parameter(Mandatory=$true)] [String] $url,
      [parameter(Mandatory=$false)] [String] $language = "en",
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $apikey,
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $secret,
      [parameter(ParameterSetName="ConnectionObject",Mandatory=$true)] [pscredential] $imaggaObj
  )
  
  Begin{
    Write-debug "Starting execution of Get-ImageTag. Url is: $url"
  }
  
  Process{
    if ($PsCmdlet.ParameterSetName -eq "ApiKey"){
      $mycreds = new-imaggaConnection -apikey $apikey -secret $secret
    }

    if ($PsCmdlet.ParameterSetName -eq "ConnectionObject"){
      $mycreds = $imaggaObj
    }

    _CheckValidImage -url $url
    _CheckValidLanguage -language $language
    
    Try{
        $json = _InvokeImaggaApi -credential $mycreds -parameters "url=$url&language=$language" -function 'tagging'
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
