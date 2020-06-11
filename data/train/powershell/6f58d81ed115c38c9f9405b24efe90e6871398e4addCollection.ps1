#Creates a new collection.
param(
    $tpamAddress,$keyFile,$apiUser,
    $collectionName,
	$description,
	$PSMDPAAffinity
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"

# Execute the operation on TPAM.
If($PSMDPAAffinity){
    $colctnParams = New-Object eDMZ.ParApi.AddCollectionParms
	$colctnParams.description = $description
	$colctnParams.psmDpaAffinity = $PSMDPAAffinity
	$result = $clnt.addCollection($collectionName,$colctnParams)
}else{
$result = $clnt.addCollection($collectionName,$description)
}
# Check the outcome of the operation.
"addCollection: rc = " + $result.returnCode + ", message =" + $result.message
$clnt.disconnect()