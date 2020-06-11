#requires -version 4
Function Get-CroppedImage{
<#
.SYNOPSIS
  Get cropped images from imagga
.DESCRIPTION
  The Get-CroppedImage function is part of Imagga module. It retrieves cropped version of the image passed as parameter. Images will match dimension passed in the resolution parameter.
.PARAMETER url
  The url of the image to be tagged. It has to be accessible from imagga server, so make sure it's a public url.
.PARAMETER apikey
  Your imagga API key. If you don't have one follow the doc: https://docs.imagga.com/#introduction
.PARAMETER secret
  Your imagga API secret.
.PARAMETER imaggaObj
  The connection object created using new-imaggaconnection.
.PARAMETER resolution
  An array containing a list of dimension in the format <width>x<height>.
.PARAMETER noScaling
  Whether the cropping coordinates should exactly match the requested resolutions or just preserve their aspect ratios and let you resize the cropped image later. If set, the coordinates that the API is going to return would exactly match the requested resolution so there won't be a need to perform any scaling of the image after cropping it. Otherwise, after cropping the images with the suggested coordinates, you should resize them to the desired resolution.
.INPUTS
  None
.OUTPUTS
  A PowerShell object containing cropped images informations.
.NOTES
  Version:        1.0
  Author:         Marco Torello
  Creation Date:  11/10/2016
  Purpose/Change: Initial script development
  
.EXAMPLE
  Get-CroppedImage -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -apikey '1111111111' -apisecret '1dsa23dasd234dfg354' -resolution @('800x600','200x100')
  
.EXAMPLE
  Get-CroppedImage -url 'http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg' -imaggaObj $credential -resolution @('800x600') -noScaling
#>

  [CmdletBinding()]   
  Param(
      [parameter(Mandatory=$true)] [String] $url,
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $apikey,
      [parameter(ParameterSetName="ApiKey",Mandatory=$true)] [String] $secret,
      [parameter(ParameterSetName="ConnectionObject",Mandatory=$true)] [pscredential] $imaggaObj,
      [parameter(ParameterSetName="ConnectionObject",Mandatory=$true)][Parameter(ParameterSetName="ApiKey", Mandatory=$True)] [String[]] $resolution,
      [Switch] $noScaling

  )
  
  Begin{
    Write-Debug "Starting execution of Get-CroppedImage. Url is: $url"
  }
  
  Process{
    if ($PsCmdlet.ParameterSetName -eq "ApiKey"){
      $mycreds = new-imaggaConnection -apikey $apikey -secret $secret
    }

    if ($PsCmdlet.ParameterSetName -eq "ConnectionObject"){
      $mycreds = $imaggaObj
    }

    _CheckValidImage -url $url
    _VerifyResolutionMatrix -resolution $resolution

    $urlOptions = "url=$url"
    $resolution | ForEach-Object{
        $urlOptions += "&$_"
    }

    if ($noscaling){
        $urlOptions += "&no_scaling=1"
    }

    Try{
        $json = _InvokeImaggaApi -credential $mycreds -parameters $urlOptions -function 'croppings'
    }
    Catch{
      Write-output $_.Exception 
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
