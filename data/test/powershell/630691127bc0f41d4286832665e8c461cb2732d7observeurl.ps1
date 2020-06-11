
$arg = $args[0]
if($args.count -gt 0){}else{break}
$account = $arg

$email = ''
$pass = ''
$masteraccount = '/api/accounts/60072'



#grab cookie from master account
$url = "https://us-3.rightscale.com/api/session"
$postparam = @{email=$email;password=$pass;account_href=$masteraccount}
$r = Invoke-WebRequest -Uri "$url" -Method Post -Body $postparam -Headers @{'X_API_VERSION'='1.5'} -SessionVariable "s";

#use cookie to get oberserver to any account
$url2 = "https://us-3.rightscale.com/global//admin_accounts/"+$account+"/access"
$r2 = Invoke-WebRequest -Uri "$url2" -Method Post  -Headers @{'Host'='us-3.rightscale.com';'Referer'='https://us-3.rightscale.com/global//admin_accounts/44/'} -WebSession $s;

Write-Host "Account: "+$arg+" should now have observer access"

