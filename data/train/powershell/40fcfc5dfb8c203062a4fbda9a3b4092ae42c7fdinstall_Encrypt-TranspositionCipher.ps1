function global:Encrypt-TranspositionCipher{
[CmdletBinding()]
param (
	[parameter(Mandatory=$True,ValueFromPipeline=$True)]
	[string]$message,
	[parameter(Mandatory=$false)]
	[int]$key=8,
	[parameter(Mandatory=$false)]
	[boolean]$decrypt=$false
	)
	
Begin
{
		
}
Process
{
	function encryptMessage($key_var,$message_var)
	{
		$this_cipher_text = @()
		0..($key_var) | % {
			$this_cipher_text += ""
		}	
		$pointer = $_
		$col = 0
		$message_var.ToCharArray() | % {
			if ($col -eq $key_var) {$col = 0}
			$this_cipher_text[$col] += $_
			$col+=1
		}
			
		
		$retval = -join $this_cipher_text
		Write-Output $retval
	}
	function decryptCipher([int]$this_key, [string]$this_message)
	{
		$numOfColumns = [Math]::Ceiling($this_message.Length / $this_key)
		$numOfRows = $this_key
		$numOfShadedBoxes = $numOfColumns * $numOfRows - $this_message.Length
		$plaintext = @()
		0..$numOfColumns | % {$plaintext += ""}
		$col = 0
		$row = 0
		$this_message.ToCharArray() | % {
			if($col -eq $numOfColumns -or ($col -eq ($numOfColumns - 1) -and $row -ge ($numOfRows - $numOfShadedBoxes)))
			{
				$col = 0
				$row += 1
			}
			$plaintext[$col] += $_
			$col += 1
			
		}
		$function_retval = -join $plaintext 
		Write-Output $function_retval
		
	}
	if($key -ge ($message.Length / 2)){Throw "Please supply a value for key less than half the length for the message to encrypt"}
	$cipherText = if($decrypt){decryptCipher $key $message}else{encryptMessage $key $message}
	Write-Output $cipherText
		
}
End
{
	
}

}