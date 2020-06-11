
open System;
open System.Collections.Generic
open Nessos.UnionArgParser
open InvestoBank.Execution.Broker
open InvestoBank.Execution.Domain
open InvestoBank.Execution.Abstractions
open InvestoBank.Execution.TradingPlatform
open InvestoBank.Execution.Service.CmdLine

let order = { OpenOrderData.ClientId = ClientId "NH04058"; 
    OpenOrderData.OrderType = BUY; 
    OpenOrderData.Qty =50us; 
    OpenOrderData.WhenReceived = DateTime.UtcNow
    }

let broker1 = new Broker1() :> InvestoBank.Execution.Abstractions.IBrokerFacade
let broker2 = new Broker2() :> InvestoBank.Execution.Abstractions.IBrokerFacade

let dict = new Dictionary<string, IBrokerFacade>(StringComparer.InvariantCultureIgnoreCase);
["BROKER1", broker1;  "BROKER2", broker2] |> Seq.iter( fun item -> dict.Add item)

let service = new InvestoBank.Execution.TradingPlatform.TradingService(dict) :> ITradeService



[<EntryPoint>]
let main argv = 
    let parser = UnionArgParser.Create<CLIArguments>()

//    printfn parser.Usage()

    let confirmation = service.ReceivedClientOrder("clientA", 100us, BUY)
    printfn "%A" confirmation
    0 // return an integer exit code

