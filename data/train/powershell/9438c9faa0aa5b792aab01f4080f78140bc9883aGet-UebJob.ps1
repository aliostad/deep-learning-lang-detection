function Get-UebJob {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)]
		[switch] $Active,
		[Parameter(Mandatory=$false)]
		[switch] $Recent,
		[Parameter(Mandatory=$false)]
		[string] $Name
	)

	CheckConnection
	
	if($Active)
	{
		$response = UebGet("api/jobs/active")

		$obj = $response.data | Where-Object { $_.status -notmatch "Successful"}
		$prop = @('name','status','percent_complete','instance_name')
	} elseif($Recent){
		$response = UebGet("api/jobs/history")

		$obj = $response.data
		$prop = @('name','status','type','start_date')
	} else {	
		$response = UebGet("api/joborders")

		$obj = $response.data
		if($Name) {
			$obj = $obj | Where-Object { $_.name -like $Name }
		}

		$prop = @('name','type','last_status','status')
	}

	FormatUebResult $obj $prop
}