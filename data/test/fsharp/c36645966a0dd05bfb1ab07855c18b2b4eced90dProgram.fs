open System.Net.Http
open System
open FSharp.Control.Tasks
open System.IO
open Client.TradingApi


[<EntryPoint>]
let main argv = 
    let keys = File.ReadAllLines(@"..\..\Keys.txt")
    let apiKey, secret = keys.[0], keys.[1]
    let tradingClient = Client.TradingApi.Client(apiKey, secret)
    let publicClient = Client.PublicApi.Client()

    let tradeOrder = tradingClient.TransferBalance("XMR", 0.05m, Margin, Lending).Result
    let tradeBalance = tradingClient.ReturnTradableBalances().Result.Result()
    //let buyResult = tradingClient.Buy(BTC_XMR, 0.02300001m, 0.1m).Result.Result()
    //let sellResult = tradingClient.Sell("BTC_XMR", 0.02602027m, 0.00461178m).Result.Result()
    //let cancelResult = tradingClient.CancelOrder(openOrderInfo.orderNumber).Result
    //printfn "%s" (cancelResult.Content.ReadAsStringAsync().Result)
    //Console.ReadKey() |> ignore
    //ignore (Console.ReadKey())
    0