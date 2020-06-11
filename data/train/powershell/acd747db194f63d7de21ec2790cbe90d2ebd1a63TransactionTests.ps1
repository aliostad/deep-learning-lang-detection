$transaction ='
{
  "portfolioName":"BambiPortfolio1", "ticker": "msft", "shares": 2, "date":"2015-02-09", "type":"Buy"
}
'
Invoke-RestMethod -Method Post -Uri http://localhost:24717/api/transactions -Body $transaction -ContentType "application/json" -Headers @{"Authorization"= "${token_type} ${access_token}"}

$transaction ='
{
  "portfolioName":"BambiPortfolio1", "ticker": "msft", "shares": 3, "date":"2015-02-10", "type":"Buy"
}
'
Invoke-RestMethod -Method Post -Uri http://localhost:24717/api/transactions -Body $transaction -ContentType "application/json" -Headers @{"Authorization"= "${token_type} ${access_token}"}

$transaction ='
{
  "portfolioName":"BambiPortfolio1", "ticker": "msft", "shares": 2, "date":"2015-02-11", "type":"Sell"
}
'
Invoke-RestMethod -Method Post -Uri http://localhost:24717/api/transactions -Body $transaction -ContentType "application/json" -Headers @{"Authorization"= "${token_type} ${access_token}"}

$transaction ='
{
  "portfolioName":"BambiPortfolio1", "ticker": "msft", "shares": 2, "date":"2015-02-12", "type":"Sell"
}
'
Invoke-RestMethod -Method Post -Uri http://localhost:24717/api/transactions -Body $transaction -ContentType "application/json" -Headers @{"Authorization"= "${token_type} ${access_token}"}
Invoke-RestMethod -Method Get -Uri http://localhost:24717/api/holdings/BambiPortfolio1 -Headers @{"Authorization"= "${token_type} ${access_token}"}
