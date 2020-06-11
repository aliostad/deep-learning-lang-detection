#The API key you get from your settings page in Whetstone
$apiKey = "PASTE YOUR API KEY HERE"; 

#The base URL
$resource = "http://instance-name.whetstoneeducation.com";

#The API resource (this script gets the list of schools so it's /api/v1/schools)
$endpoint = "/api/v2/schools";

#This is the URL that will authenticate you using your key
$authURL = "$resource/auth/api";

#This is the data we're sending to the authentication server - your unique key
$data = @{
  apikey=$apiKey
}
#convert it to JSON 
$json = $data | ConvertTo-Json

#Make a POST request to the authorization URL to get a token
$request = Invoke-RestMethod -Method Post -Uri "$resource/auth/api" -Body $json -ContentType "application/json"

#We are now authenticated! 
#The $request variable is now an object with the response from our server. It has your token in it. 

#Now we can make a request to the API

#We need to include the token and the key in the header to make sure everything is secure
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("x-access-token", $request.token)
$headers.Add("x-key", $apiKey)

#Now we make a GET request to the API
$data = Invoke-RestMethod -Method Get -Uri "$resource$endpoint" -Headers $headers -ContentType "application/json";

#The requested data is now stored in the $data variable as an object

#This is where you would do something cool with the data.
#We'll just loop through the $data object and print the name of each school to the shell window
foreach($school in $data) {
  Write-Output $school.name
}