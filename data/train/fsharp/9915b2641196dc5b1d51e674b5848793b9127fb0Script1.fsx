#load "Common.fs"
#load "Domain.fs"
open InvestoBank.Execution.Common
#load "Abstractions.fs"
#load "Broker.fs"
#load "TradingPlatform.fs"

open System;
open System.Collections.Generic

open InvestoBank.Execution.Broker
open InvestoBank.Execution.Domain;;
open InvestoBank.Execution.Abstractions;;
open InvestoBank.Execution.TradingPlatform;;

let order = { OpenOrderData.ClientId = ClientId "NH04058"; 
    OpenOrderData.OrderType = BUY; 
    OpenOrderData.Qty =10us; 
    OpenOrderData.WhenReceived = DateTime.UtcNow
    }

let broker1 = new Broker1() :> InvestoBank.Execution.Abstractions.IBrokerFacade
let broker2 = new Broker2() :> InvestoBank.Execution.Abstractions.IBrokerFacade

let dict = new Dictionary<string, IBrokerFacade>(StringComparer.InvariantCultureIgnoreCase)
[ "BROKER1", broker1; "BROKER2", broker2] |> Seq.iter( fun item -> dict.Add item)
dict.["Broker1"]


let service = new InvestoBank.Execution.TradingPlatform.TradingService(dict) :> ITradeService

let confirmation = service.ReceivedClientOrder("clientA", 100us, BUY)
printfn "%A" confirmation

