# Credits: Doug Finke @dfinke
# http://www.dougfinke.com/blog/index.php/2012/09/03/using-powershell-for-dynamic-json-parsing/

$api_key="[PUT_YOUR_API_KEY_HERE]"

$jsonObject=[ordered]@{}
$jsonObject.Id="score00001"

$instance=@{}
$instance.FeatureVector=@{}

$features=@{}
# [DEFINE_YOUR_FEATURES_HERE]
#$features.Survived="0"
#$features.Pclass="1"
#$features.Sex="F"
#$features.Age="35"
#$features.Fare="75"

$instance.FeatureVector+=$features
$instance.GlobalParameters=@{}

$jsonObject.Instance=$instance
$jsonObject=$jsonObject |convertto-json

$headers=@{'Content-Type'='application/json';'Authorization'=('Bearer '+ $api_key)}
invoke-webrequest -uri "[PUT_YOUR_URL_HERE]" -method post -body $jsonObject -headers $headers