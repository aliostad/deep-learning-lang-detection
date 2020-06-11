# Credits:
# v1 using the preview AzureML API
# Doug Finke @dfinke
# http://www.dougfinke.com/blog/index.php/2012/09/03/using-powershell-for-dynamic-json-parsing/
# v2 using the GA (2015) AzureML API
# jrv
# https://social.technet.microsoft.com/Forums/windowsserver/en-US/fb53a73b-35ac-4c8b-b5b2-c692db713ce9/creating-a-list-for-azure-machine-learning?forum=winserverpowershell

$api_key="[PUT_YOUR_API_KEY_HERE]"

$x=convertfrom-json '{"Inputs":{"input1":{"ColumnNames":["Survived","Pclass","Sex","Age","Fare"],"Values":[["0","1","F","35","75"]]}},"GlobalParameters":{}}'
$jsonObject=$x|convertto-json -depth 4

$headers=@{'Content-Type'='application/json';'Authorization'=('Bearer '+ $api_key)}
invoke-webrequest -uri "[PUT_YOUR_URL_HERE]" -method post -body $jsonObject -headers $headers
