# MturkDotnet with PowerShell
# stwehrli@gmail.com
# 26sept2015

function MturkDotNet-With-PowerShell {
	# Add your AMT Credentials
	$AccessKeyId = "MyAccessKeyId"
	$SecretKey = "MySecretKeyId"

	# Load and config assembly
	$assemblyPath = "c:\AMT\Amazon.WebServices.MechanicalTurk.dll"
	$AmtAssembly = [Reflection.Assembly]::LoadFile($assemblyPath)
	$AmtServiceEndpoint = "https://mechanicalturk.amazonaws.com?Service=AWSMechanicalTurkRequester"
	$AmtWebsiteUrl = "https://mechanicalturk.amazonaws.com"
	$AmtConfig = New-Object Amazon.WebServices.MechanicalTurk.MTurkConfig($AmtServiceEndpoint, $AccessKeyId, $SecretKey)
	$AmtClient = New-Object Amazon.WebServices.MechanicalTurk.SimpleClient($AmtConfig)

	# Execute method
	$AmtClient.GetAccountBalance().AvailableBalance.FormattedPrice

	# List available methods and properties
	$AmtClient | Get-Member

	# See PsAmt for a more comprehensive PowerShell solution
	# https://github.com/DeSciL/PsAmt
}
