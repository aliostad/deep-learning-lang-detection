<# Custom Script for Windows #>
Param ( 
	[string] $RGName,
	[string] $VMName,
	[string] $CSName
)
Try
{
	$output = Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $RGName -VMName $VMName -Name $CSName -Status
	$StdOut = $output.SubStatuses[0].Message
	$StdErr = $output.SubStatuses[1].Message
	Write-Output "VM has the following StdOut: $StdOut"
	Write-Output "VM has the following StdErr: $StdErr"
	$outputTable = @{
								"StdOut" = $StdOut;
								"StdErr" = $StdErr
					}
	Write-Output $outputTable
	if ([string]::IsNoNullOrEmpty($StdErr)) {}
	else
	{
		exit 1
	}
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	exit 1
}
#Finally
#{
#	$Time=Get-Date
#}
