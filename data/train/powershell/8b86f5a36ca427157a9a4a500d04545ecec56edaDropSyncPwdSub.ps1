#Removes a subscriber from a synchronized password.
param(
    $tpamAddress,$keyFile,$apiUser,
    $syncPassName,$systemName,$accountName
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"

try {
	$result = $clnt.dropSyncPwdSub($syncPassName,$SystemName,$AccountName)
	"dropSyncPwdSubscriber: rc = " + $result.returnCode + ", message =" + $result.message
	$clnt.disconnect()
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error occured: $errDescrption"
}