function Restore-PaPreviousVersion {
    <#
	.SYNOPSIS
		Reverts to previous configuration version
	.DESCRIPTION
		
	.EXAMPLE
        EXAMPLES!
	.EXAMPLE
		EXAMPLES!
	.PARAMETER PaConnectionString
		Specificies the Palo Alto connection string with address and apikey. If ommitted, $global:PaConnectionArray will be used
	#>

    Param (
        [Parameter(Mandatory=$False)]
        [alias('pc')]
        [String]$PaConnection
    )

    BEGIN {
        Function Process-Query ( [String]$PaConnectionString ) {
            $LastVers = (Send-PaApiQuery -op "<show><config><audit><info></info></audit></config></show>").response.result.entry[1].name
            $LoadLast = Send-PaApiQuery -op "<load><config><version>$LastVers</version></config></load>"
            if ($LoadLast.response.status -eq "succes") { Invoke-Pacommit } `
                else { throw $LoadLast.response.msg }
        }
    }
    
    PROCESS {
        if ($PaConnection) {
            Process-Query $PaConnection
        } else {
            if (Test-PaConnection) {
                foreach ($Connection in $Global:PaConnectionArray) {
                    Process-Query $Connection.ConnectionString
                }
            } else {
                Throw "No Connections"
            }
        }
    }
}