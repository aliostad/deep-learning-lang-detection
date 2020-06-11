function Get-BitcoinPrices {
    $exchanges = @()
    
    $exchanges += getBtc-ePrices
    $exchanges += getCampBxPrices
    $exchanges += getCoinbasePrices

    $exchanges
}

function getBtc-ePrices() {
    $response = Invoke-RestMethod -Uri https://btc-e.com/api/2/btc_usd/ticker
    new-object psobject -property  @{BuyPrice = $response.ticker.buy; SellPrice = $response.ticker.sell; Exchange = "BTC-E"}
}

function getCampBxPrices() {
    $response = Invoke-RestMethod -Uri http://campbx.com/api/xticker.php
    new-object psobject -property  @{BuyPrice = $response."Best Ask"; SellPrice =  $response."Best Bid"; Exchange = "Camp BX"}
}

function getCoinbasePrices() {
    $buy = Invoke-RestMethod -Uri https://coinbase.com/api/v1/prices/buy
    $sell = Invoke-RestMethod -Uri https://coinbase.com/api/v1/prices/sell
    new-object psobject -property  @{BuyPrice = $buy.total.amount; SellPrice = $sell.total.amount; Exchange = "Coinbase"}
}

Export-ModuleMember Get-BitcoinPrices
