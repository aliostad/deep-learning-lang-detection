param($libDir = (Resolve-Path .\).Path)
$ErrorActionPreference = "stop"
. "$libDir\signature_hash_parser.ps1"
[Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null

function new_service_bus_shared_access_signature_provider { param(
	$namespace,
	$key,
	$keyName)
	$obj = New-Object PSObject -Property @{
		Namespace = $namespace;
		SignatureHasher = (new_utf8_signature_hash_parser $key);
		KeyName = $keyName;
	}
	$obj | Add-Member -Type ScriptMethod _get_expiration {
		$origin = New-Object DateTime(1970, 1, 1, 0, 0, 0, 0)
		$utcNow = [DateTime]::Now.ToUniversalTime()
		$diff = $utcNow.Subtract($origin)
		$result = [Convert]::ToUInt32($diff.TotalSeconds) + (100000 * 20)
		$result
	}
	$obj | Add-Member -Type ScriptMethod GetHeader {
		#sr=your-namespace.servicebus.windows.net&sig=tYu8qdH563Pc96Lky0SFs5PhbGnljF7mLYQwCZmk9M0%3d&se=1403736877&skn=RootManageSharedAccessKey
		$uri = "$($this.Namespace).servicebus.windows.net"
		$encodedUri = [Web.HttpUtility]::UrlEncode($uri.ToLowerInVariant())
		$expiration = $this._get_expiration()
		#$expiration = "1435143079"
		Write-Verbose "Shared access expiration: $($expiration)"
		$stringToSign = "$($encodedUri)`n$($expiration)"
		Write-Verbose "Shared access signature string to sign: $($stringToSign)"
		$hash = $this.SignatureHasher.execute($stringToSign)
		Write-Verbose "Shared access signature hash: $($hash)"
		$encodedHash = [Web.HttpUtility]::UrlEncode($hash) 
		$result = "SharedAccessSignature sr=$($encodedUri)&sig=$($encodedHash)&se=$($expiration)&skn=$($this.KeyName)"
		Write-Verbose "Returning shared access signature: $($result)"
		$result
	}
	$obj
}
