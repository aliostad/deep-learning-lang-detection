param (
	[string] $user = $(throw "Specify a user name")  )

$passSecure = read-host "Enter password for $user" -AsSecureString
$passBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR( $passSecure )
$pass = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR( $passBSTR )
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR( $passBSTR )

$zreqctx = new-object Zimbra.Client.RequestContext
$zreqapi = new-object Zimbra.Client.Account.AuthRequest $user, $pass

$global:zreq = new-object Zimbra.Client.RequestEnvelope $zreqctx , $zreqapi
$global:zres = $global:zdisp.SendRequest( $global:zreq )

$global:zreq.Context.Update( $global:zres.Context, $global:zres.ApiResponse )

echo $zres.ApiResponse 
