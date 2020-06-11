#Allows you to add subscribers to a synchronized password.
param(
    $tpamAddress,$keyFile,$apiUser,
    $SyncPassName,$SystemName,$AccountName
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"

try {
	$result = $clnt.addSyncPwdSub($syncPassName,$SystemName,$AccountName)
	"addSyncPwdSubscriber: rc = " + $result.returnCode + ", message =" + $result.message
	$clnt.disconnect()
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error occured: $errDescrption"
}