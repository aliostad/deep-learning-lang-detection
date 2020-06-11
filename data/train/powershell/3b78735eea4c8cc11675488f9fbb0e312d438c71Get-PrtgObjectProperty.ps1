
function Get-PrtgObjectProperty {
	<#
	.SYNOPSIS
		
	.DESCRIPTION
		
	.EXAMPLE
		
	#>

    Param (
        [Parameter(Mandatory=$True,Position=0)]
		[alias('DeviceId')]
        [int]$ObjectId,

        [Parameter(Mandatory=$True,Position=1)]
        [string]$Property
    )

    BEGIN {
		if (!($PrtgServerObject.Server)) { Throw "Not connected to a server!" }
    }

    PROCESS {
		$Url = $PrtgServerObject.UrlBuilder("api/getobjectproperty.htm",@{
			"id"		= $ObjectId
			"name" 		= $Property
			"show" 		= "text"
		})

		$Data = $PrtgServerObject.HttpQuery($Url,$true)
		
		return $Data.Data.prtg.result
    }
}
