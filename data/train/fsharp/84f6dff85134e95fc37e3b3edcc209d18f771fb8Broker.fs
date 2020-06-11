namespace InvestoBank.Execution

open System
open System.Linq
open InvestoBank.Execution.Domain
open InvestoBank.Execution.Abstractions

module Broker = 
    
    let inline (|MULTIPLE10|NON10|) qty =
        if (qty%10us = 0us) then MULTIPLE10 else NON10

    let contains x =  Seq.exists((=)x)
    let createQuote (openOrder:OpenOrderData, brokerId:string, quote:float) ={ 
        BrokerOrderQuote.Id = BrokerId brokerId; 
        BrokerOrderQuote.OrderType = openOrder.OrderType;
        BrokerOrderQuote.Qty = openOrder.Qty;
        BrokerOrderQuote.WhenQuoted = DateTime.UtcNow
        BrokerOrderQuote.Quote = quote
        }

    let createBrokerExecutedOrder (quote:BrokerOrderQuote) = { 
        BrokerExecutedOrder.Id = quote.Id;
        BrokerExecutedOrder.Amount = quote.Quote;
        BrokerExecutedOrder.OrderType = quote.OrderType;
        BrokerExecutedOrder.Qty = quote.Qty;
        BrokerExecutedOrder.WhenExecuted = DateTime.UtcNow
        }

    type Broker1 () =
        let PRICE = 1.49
        let COMMISION = 1.05

        interface IBrokerFacade with 
            member x.QuoteOnOrder order = 
                let { OpenOrderData.Qty = qty} = order
                match qty with
                | NON10 -> Failure ( sprintf "Multiples of 10 allowed. You've order :%O" qty)
                | MULTIPLE10 -> 
                    let quote = PRICE * COMMISION * (float qty)
                    createQuote(order, "BROKER1", quote ) |> Success

            member x.ExecuteQuote order = createBrokerExecutedOrder order

        member x.QuoteOnOrder = (x:> IBrokerFacade).QuoteOnOrder
        member x.ExecuteQuote = (x:> IBrokerFacade).ExecuteQuote


    type Broker2 () =
        let PRICE = 1.52
        let COMMISSIONS = [ 
            [10us..10us..40us] , 1.03; 
            [50us..10us..80us] , 1.025
            [90us..10us..100us] , 1.02;
           ]

        let calculate_quote order =
            let { OpenOrderData.Qty = qty} = order
            let commission = COMMISSIONS |> Seq.find(fun (r, c)-> contains qty r) |> fun (r, c)-> c
            let quote = PRICE * commission * (float qty)
            createQuote(order, "BROKER2", quote) |> Success

        interface IBrokerFacade with 
            member x.QuoteOnOrder order = 
                let { OpenOrderData.Qty = qty} = order
                match qty with
                | NON10 -> Failure ( sprintf "Multiples of 10 allowed. You've order :%O" qty)
                | MULTIPLE10 -> calculate_quote order

            member x.ExecuteQuote order = createBrokerExecutedOrder order
        
        member x.QuoteOnOrder = (x:> IBrokerFacade).QuoteOnOrder
        member x.ExecuteQuote = (x:> IBrokerFacade).ExecuteQuote
    