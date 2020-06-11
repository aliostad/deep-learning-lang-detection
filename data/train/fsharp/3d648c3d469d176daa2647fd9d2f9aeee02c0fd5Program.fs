namespace InvestoBank.Execution
 
open System;
open System.Collections.Generic

open InvestoBank.Execution.Broker
open InvestoBank.Execution.Domain;;
open InvestoBank.Execution.Abstractions;;
open InvestoBank.Execution.TradingPlatform;;



module Program =

    [<EntryPoint>]
    let main argv = 
        printfn "Ah! entering point to the main!"
        let order = { OpenOrderData.ClientId = ClientId "NH04058"; 
            OpenOrderData.OrderType = BUY; 
            OpenOrderData.Qty =50us; 
            OpenOrderData.WhenReceived = DateTime.UtcNow
            }

        let broker1 = new Broker1() :> InvestoBank.Execution.Abstractions.IBrokerFacade
        let broker2 = new Broker2() :> InvestoBank.Execution.Abstractions.IBrokerFacade

        let dict = new Dictionary<BrokerId, IBrokerFacade>();
        [BrokerId "BROKER1", broker1; BrokerId "BROKER2", broker2] |> Seq.iter( fun item -> dict.Add item)

        let service = new InvestoBank.Execution.TradingPlatform.TradingService(dict) :> ITradeService

        let confirmation = service.ReceivedClientOrder("clientA", 100us, BUY)
        System.Console.ReadKey() |> ignore
        0 // return an integer exit code