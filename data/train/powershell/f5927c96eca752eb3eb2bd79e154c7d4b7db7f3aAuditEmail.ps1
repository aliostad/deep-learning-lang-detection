$user = $(Read-Host "Enter User")
$ids = QueryPSA "select id from clients where login LIKE '$user';"
foreach($cl_id in $ids){
$domain_list = (QueryPSA "select name from domains where cl_id = '$cl_id';")
$cl_id
$domain_list
write-host "getting users"
foreach($domain in $domain_list){
	$API = New-WebServiceProxy -uri http://localhost:9998/Services/svcUserAdmin.asmx
    $domain=$domain.trim()
	if ($domain -ne ""){
		$results = $API.GetUsers($SMuser,$SMpass,$domain)
		$user_list = $results.users
		foreach($user in $user_list){
			$u_name = $user | %{$_.username}
			$pass = $user | %{$_.password}
			$output = $u_name+","+$pass
			$output #| out-file "C:\scripts\mailusers.csv" -append
		}
	}
}
}
#notepad.exe "C:\scripts\mailusers.csv"