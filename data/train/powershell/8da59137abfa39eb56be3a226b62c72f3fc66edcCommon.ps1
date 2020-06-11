#region Define paths
$projScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory.parent
$wrapper = Get-ChildItem -Path $projScriptsDir.FullName 'ParApiWrapper.dll'
$keyDir = $projScriptsDir.GetDirectories('keys')|Select -First 1
$keyFile = Get-ChildItem -Path $keyDir.FullName $keyFile
#endregion

#region Connect to TPAM server
try {
	[Reflection.Assembly]::LoadFile($wrapper.FullName)|Out-Null
$clnt = New-Object -TypeName eDMZ.ParApi.ApiClientWrapper -ArgumentList ($tpamAddress,$keyFile.FullName,$apiUser)
$clnt.connect()
$clnt.setCommandTimeout(70)
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error arises: $errDescrption"
}

#endregion

function Set-Flag([string]$flag) {
    switch ($flag) {
	'Y' {
		$res = [eDMZ.ParApi.Flag]::Y
        break
	}
	'N' {
	    $res = [eDMZ.ParApi.Flag]::N
		break
	}
	default {
	    $res = [eDMZ.ParApi.Flag]::NOT_SET
	    break
	}
    }
$res
}

function create-datetimewrapper {
	param(
		[string]$datetime
	)
    $time = @()
	$datetime.Split(',')|%{$time+=[int]$_}
	$chtime = New-Object eDMZ.ParApi.DateTimeWrapper $time
    $chtime
}