#リモートディレクトリにログインする

function Login-Remote
{
	param(
		[string]$path=""
		,[string]$user=""
		)
		
	if($path -eq "")
	{
		Write-Host "This command requires destination path to log-in."
		return
	}

	if($user -eq "")
	{
		$message = "Enter UserName "
		$user = Read-Host $message
		if($user -eq "")
		{
			return
		}
	}

	$message = "Enter password for '" +  $user + "'" 
	$password = Read-Host $message -AsSecureString
	$password = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
	$password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($password)

	net use $path $password /user:$user
}

Export-ModuleMember -Function Login-Remote
