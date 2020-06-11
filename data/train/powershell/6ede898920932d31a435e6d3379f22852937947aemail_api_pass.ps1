########################
# Fill in your details #
########################
$username = "your_whois_api_username"
$password = "your_whois_api_password"

$emailAddress = "support@whoisxmlapi.com"

$validateDNS = "true"
$validateSMTP = "true"
$checkCatchAll = "true"
$checkFree = "true"
$checkDisposable = "true"

$uri = "https://www.whoisxmlapi.com/whoisserver/EmailVerifyService?"`
    + "emailAddress=$emailAddress"`
    + "&validateDNS=$validateDNS"`
    + "&validateSMTP=$validateSMTP"`
    + "&checkCatchAll=$checkCatchAll"`
    + "&checkFree=$checkFree"`
    + "&checkDisposable=$checkDisposable"`
    + "&username=$username"`
    + "&password=$password"


#######################
# Use a XML resource #
#######################
#using default outputFormat (xml)

$j = Invoke-WebRequest -Uri $uri
echo "XML:`n---" $j.content

#######################
# Use a JSON resource #
#######################
$format = "json"

$uri = $uri + "&outputFormat=json"
$j = Invoke-WebRequest -Uri $uri
echo "JSON:`n---" $j.content "`n"