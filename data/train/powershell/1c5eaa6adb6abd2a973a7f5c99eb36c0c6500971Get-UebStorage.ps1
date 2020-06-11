function Get-UebStorage {
    [CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)]
		[string] $Name,
        [Parameter(Mandatory=$false)]
		[string] $Type
	)

    begin {
		CheckConnection
    }
	
	process {        
		$response = UebGet("/api/storage")
		$obj = $response.storage
    
		if($Name) {
			$obj = $obj | Where-Object { $_.name -like $Name }
		}
 
		if($Type) {
			$obj = $obj | Where-Object { $_.type -like $Type }
		}
        
		$prop = @('name','system_name','type','usage')
         
		FormatUebResult $obj $prop
	}
	
	end {
	}
}
