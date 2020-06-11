function invoke-twilioRESTSMS
(
    [Parameter(Mandatory=$true)][String]$message,
    [Parameter(Mandatory=$true)][String]$toTel,
	[Parameter(Mandatory=$true)][String]$AccountSid,
	[Parameter(Mandatory=$true)][String]$authToken,
	[Parameter(Mandatory=$true)][String]$fromTel
)
{
	# Build a URI
    $URI = "https://api.twilio.com/2010-04-01/Accounts/$AccountSid/SMS/Messages.json"

    # encode authorization header
    $secureAuthToken = ConvertTo-SecureString $authToken -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($AccountSid,$secureAuthToken) 
    
    # content
    $postData = "From=$fromTel&To=$toTel&Body=$message"
    
    # Fire Request
    $msg = Invoke-RestMethod -Uri $URI -Body $postData -Credential $credential -Method "POST" -ContentType "application/x-www-form-urlencoded"
	$msg
	
	# Example usage
	# invoke-twilioRESTSMS -message <your_sms_message_body> -toTel <your_to_number> -AccountSid <your_account_sid> -authToken <your_auth_token> -fromTel <your_from_number>
}



function invoke-twilioRESTCall
(
    [Parameter(Mandatory=$true)][String]$message,
    [Parameter(Mandatory=$true)][String]$toTel,
	[Parameter(Mandatory=$true)][String]$AccountSid,
	[Parameter(Mandatory=$true)][String]$authToken,
	[Parameter(Mandatory=$true)][String]$fromTel
)
{
    # encode authorization header
    $secureAuthToken = ConvertTo-SecureString $authToken -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($AccountSid,$secureAuthToken) 
	$baseURL = "http://twimlets.com/message?Message="
	$baseURL = [system.uri]::EscapeDataString($baseURL)
	$message = [system.uri]::EscapeDataString($message)
	$message = [system.uri]::EscapeDataString($message)
	$url = $baseURL + $message
	$URI = "https://api.twilio.com/2010-04-01/Accounts/$AccountSid/Calls.json"
	$postData = "From=$fromTel&To=$toTel&Url=$url"
    
	# Fire Request
    $msg = Invoke-RestMethod -Uri $URI -Body $postData -Credential $credential -Method "POST" -ContentType "application/x-www-form-urlencoded"
	$msg
	
	# Example usage
	# invoke-twilioRESTCall -message <your_message> -toTel <your_to_number> -AccountSid <your_account_sid> -authToken <your_auth_token> -fromTel <your_from_number>
}


function invoke-twilioRESTApplication
(
    [Parameter(Mandatory=$true)][String]$toTel,
	[Parameter(Mandatory=$true)][String]$applicationSid,
	[Parameter(Mandatory=$true)][String]$AccountSid,	
	[Parameter(Mandatory=$true)][String]$authToken,
	[Parameter(Mandatory=$true)][String]$fromTel	
)
{
    # encode authorization header
    $secureAuthToken = ConvertTo-SecureString $authToken -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($AccountSid,$secureAuthToken) 
	$fromTel = "+13142000847"
	$URI = "https://api.twilio.com/2010-04-01/Accounts/$AccountSid/Calls.json"
	$postData = "From=$fromTel&To=$toTel&ApplicationSid=$applicationSid"
    
	# Fire Request
    $msg = Invoke-RestMethod -Uri $URI -Body $postData -Credential $credential -Method "POST" -ContentType "application/x-www-form-urlencoded"
	$msg
	
	# Example usage
	# invoke-twilioRESTApplication -toTel <your_to_number> -applicationSid <your_application_sid> -AccountSid <your_account_sid> -authToken <your_auth_token> -fromTel <your_from_number>
}