#Creates a new collection member where the system, account, and or file and
#collection(s) currently exist.
param(
    $tpamAddress,$keyFile,$apiUser,
    $collectionName,
	$systemName,
	$accountName,
	$fileName
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"

try {
	if ($accountName) {
    $params = New-Object eDMZ.ParApi.AddCollectionMemberParms
	$params.accountName = $accountName
	$result = $clnt.addCollectionMember($systemName,$collectionName,$params)
}
elseif ($fileName) {
    $params = New-Object eDMZ.ParApi.AddCollectionMemberParms
	$params.fileName = $fileName
	$result = $clnt.addCollectionMember($systemName,$collectionName,$params)
}
else {
    $result = $clnt.addCollectionMember($systemName,$collectionName)
}
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error arises: $errDescrption"
}

# Check the outcome of the operation.
"addCollectionMember: rc = " + $result.returnCode + ", message =" + $result.message
$clnt.disconnect()