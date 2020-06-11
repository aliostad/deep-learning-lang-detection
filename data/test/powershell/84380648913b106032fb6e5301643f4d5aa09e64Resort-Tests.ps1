
$url = "http://localhost:1337/api/resort"
$request = @{
    "Name" = "Cypress Mt"
    "Country" = "Canada"
    "Region" = "B.C."
}
$response = Invoke-WebRequest -Uri $url -Method Post -Body $request 
$response

# get resorts
$resortsResponse = Invoke-WebRequest -Uri "http://localhost:1337/api/resorts?format=json" -Method Get
$resortsResponse.Content | ConvertFrom-Json

# Get a resort
$resortRequest = "http://localhost:1337/api/resort?format=json"
$resortResponse = Invoke-WebRequest $resortRequest -Method GET -Body @{Name = "Cypress Mt"}
$resortResponse.Content | ConvertFrom-Json