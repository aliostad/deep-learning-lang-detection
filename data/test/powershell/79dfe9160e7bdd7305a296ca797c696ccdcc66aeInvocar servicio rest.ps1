$json = '{
  "Email": "maxneo4@gmail.com",
  "Password": "$Pass123",
  "ConfirmPassword": "$Pass123"
}'

$uri = 'http://localhost:59846/api/Account/Register'

Invoke-RestMethod -Method Post -Uri $uri -Body $json -ContentType 'text/json'

$body = @{
    Email = "maxneo4@gmail.com"
    Pasword = "pass123"
    ConfirmPassword = "pass123"
}

(ConvertTo-Json $body)

$uri = 'http://localhost:59846/api/values'
$uri ='http://test.ssgi.com.co/api/values'

$uri = 'http://maxneo4.azurewebsites.net/api/values'
$body = @{ NumberA = 2 
NumberB = 3 }

Invoke-RestMethod -Method Post -Uri $uri -Body (ConvertTo-Json $body) -ContentType 'text/json'