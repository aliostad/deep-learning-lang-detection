namespace InvestoBank.Execution

open System.Collections.Generic
open InvestoBank.Execution
open InvestoBank.Execution.Abstractions
open InvestoBank.Execution.Domain

module TradingPlatform = 
    let get_quotes (brokers: IBrokerFacade seq) order =
        let quotes_results = brokers |> Seq.map( fun b -> b.QuoteOnOrder order)
        let successfully_quotes = onlySuccess quotes_results
        successfully_quotes   


    type TradingService (brokers: IDictionary<string,IBrokerFacade>) =
        let orders = new List<ClientOrder>();
        let GetQuoteFromBrokers (order:ClientOrder) : Result<seq<BrokerOrderQuote>, string> = 
            match order with
            | ExecutedOrder (openOrder, executions) -> sprintf "Cannot quote on executed order %O" openOrder |> Failure
            | QuotedOrder quoted -> get_quotes brokers.Values quoted.Order |> Success
            | OpenOrder openOrder -> get_quotes brokers.Values openOrder  |> Success


        interface ITradeService with
            member x.ReceivedClientOrder(clientId:string, qty:uint16, orderType:OrderType) = 
                let openOrderData = OpenOrderData.CreateOpenOrderData(clientId, qty, orderType)
                let quotes = GetQuoteFromBrokers (OpenOrder openOrderData)
                match quotes with
                | Failure msg -> Failure msg
                | Success good_quotes -> 
                      let cheapest_quote = good_quotes |> Seq.minBy(fun x -> x.Quote)
                      let (BrokerId id) = cheapest_quote.Id
                      let broker_executed_order = brokers.[id].ExecuteQuote(cheapest_quote)
                      let executedOrder = (openOrderData , { ExecutedOrderData.Execution = [broker_executed_order]}) |> ExecutedOrder
                      orders.Add(executedOrder)
                      Success executedOrder

        member x.ReceivedClientOrder = (x :> ITradeService).ReceivedClientOrder

        



                      

