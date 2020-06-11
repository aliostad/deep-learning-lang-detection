function global:Encrypt-ReverseCipher{
[CmdletBinding(
	DefaultParameterSetName="message",
	SupportsShouldProcess=$False)
	]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,HelpMessage=’Text you wish to cipher’)]
	[string]$message)
	
Begin
{
	
}
Process
{
	$translate=""
	$i = $message.Length - 1
	while($i -ge 0){$translate += $message[$i];$i -= 1}
	Write-Output $translate
}
End
{
	
}

}