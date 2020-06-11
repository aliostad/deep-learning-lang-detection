function Get-UebSystems {
    [CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)]
		[string] $Name,
		
		[Parameter(Mandatory=$false)]
		[switch] $local
	)

    begin {
		CheckConnection
    }
	
	process {        
		$response = UebGet("/api/systems/?include_pending=1&include_rejected=1")
		$obj = $response.appliance
    
		if($Name) {
			$obj = $obj | Where-Object { $_.name -like $Name }
		}
		
		if($local) {
			$obj = $obj | Where-Object { $_.local -like "True" }
		}
        
		$prop = @('name','host','role','status')
         
		FormatUebResult $obj $prop
	}
	
	end {
	}
}
