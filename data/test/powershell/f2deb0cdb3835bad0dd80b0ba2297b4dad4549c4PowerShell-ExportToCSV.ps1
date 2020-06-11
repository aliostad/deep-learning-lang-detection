#The API key you get from your settings page in Whetstone
$apiKey = "PASTE YOUR API KEY HERE"; 

#The base URL
$resource = "http://instance-name.whetstoneeducation.com";

#The API resource (this script gets the list of users using v2 of our API so it's /api/v2/users)
$endpoint = "/api/v2/users";

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

#Our $data object is multi-dimensional so we need to make a 2-dimensional collection for CSV

#Create an empty collection to hold our rows of CSV data
[System.Collections.ArrayList]$exportData = New-Object System.Collections.ArrayList($null)

#loop through user data
foreach($user in $data) {
  #create empty row
  $row = @{}

  #add data to row
  $row.name = $user.name;
  $row.email = $user.email;
  $row.school = $user.defaultInformation.school.name;
  
  #add row to $exportData collection
  $exportData.Add((New-Object PSObject -Property $row));  
}

#export collection to a CSV file in this directory with a timestamped filename
$exportData | Export-Csv -Path "Whetstone_Users_$((Get-Date).ToString('yyyy-MM-ddThh-mm-ss')).csv" -NoTypeInformation -Append
