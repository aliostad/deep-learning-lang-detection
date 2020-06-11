#Returns the details associated with the specified password request.
param(
    $tpamAddress,$keyFile,$apiUser,
	$RequestID,
	[string[]]$propsToList = @('systemName','accountName','status')
)
$psScriptsDir = (Get-Item $MyInvocation.MyCommand.Path).Directory
. "$psScriptsDir\Common.ps1"

try {
    $request = New-Object eDMZ.ParApi.PwdRequest
	$res = $clnt.getPwdRequest($RequestID,[ref]$request)
	
	if($propsToList.count -eq 1){
       $propsToList=$propsToList[0].Split(',')
    }
	
	$res.entries|ft -AutoSize -Property $propsToList 
} catch {
	$errDescrption = $Error[0].Exception.Message
	Write-Output "Error occured: $errDescrption"
}finally{
    $clnt.disconnect()
}