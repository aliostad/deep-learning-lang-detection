namespace InvestoBank.Execution

module Domain =
    open System
    open System.Runtime.Serialization
  
   
    type ClientId = ClientId of string
    type BrokerId = BrokerId of string
     
    type OrderType = 
        | BUY | SELL | SUM

    type OpenOrderData = {
        OrderType : OrderType;
        ClientId: ClientId;
        Qty:  uint16;
        WhenReceived: DateTime;
    } 
   
    type BrokerOrderQuote= {
        Id: BrokerId;
        OrderType: OrderType;
        WhenQuoted: DateTime;
        Qty: uint16;
        Quote: float;
    }    

    type BrokerExecutedOrder ={
        Id: BrokerId;
        OrderType: OrderType;
        WhenExecuted: DateTime;
        Qty: uint16
        Amount: float;
    }

    type QuotedOrderData = { 
        Order: OpenOrderData;
        Quotes: BrokerOrderQuote seq
    }
    
    type ExecutedOrderData = {
        Execution: BrokerExecutedOrder seq
    }

    type ClientOrder = 
    | OpenOrder of OpenOrderData
    | QuotedOrder of QuotedOrderData
    | ExecutedOrder of OpenOrderData * ExecutedOrderData

    /// ---Type Extensions
    type OpenOrderData with
        static member CreateOpenOrderData (id:string, qty:uint16, orderType:OrderType) =
           { OpenOrderData.ClientId = ClientId id; OrderType = orderType; Qty = qty; WhenReceived = DateTime.UtcNow }

   