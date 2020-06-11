# Removes a system, account or file from one or more collections.
#collectionName and systemName are required
param(
    $tpamAddress,$keyFile,$apiUser,
    $collectionName,$systemName,
	$accountName,$fileName
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"
try {	
	if ($accountName) {
	    $params = New-Object eDMZ.ParApi.DropCollectionMemberParms
		$params.accountName = $accountName
		$result = $clnt.dropCollectionMember($systemName,$collectionName,$params)
	}
	elseif ($fileName) {
	    $params = New-Object eDMZ.ParApi.DropCollectionMemberParms
		$params.fileName = $fileName
		$result = $clnt.dropCollectionMember($systemName,$collectionName,$params)
	}
	else {
	    $result = $clnt.dropCollectionMember($systemName,$collectionName)
	}

	# Check the outcome of the operation.
	"dropCollectionMember: rc = " + $result.returnCode + ", message =" + $result.message
	$clnt.disconnect()
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error arises: $errDescrption"
}