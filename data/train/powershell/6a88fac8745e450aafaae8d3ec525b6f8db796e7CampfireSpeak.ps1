$args_ = , $args_
$message=$args;

##
## Modify these settings:

$roomId=12345; 
$token="your_token_goes_here";
$password="X";
$url="https://your_company_url.campfirenow.com/room/$roomId/speak.xml";

## You shouldn't have to modify anything past here
##


$messageXML = "<message>";
$messageXML+= "<body><![CDATA[";
$messageXML+= $message;
$messageXML+= "]]></body>";  
$messageXML+= "</message>";

$webClient = new-object "System.Net.WebClient"
$webClient.Credentials = new-object System.Net.NetworkCredential($token,$password )
$webClient.Headers.Add("Content-Type", "application/xml");
$response = $webClient.UploadString($url,$messageXML);
