(*
    Copyright (C) 2013  Matthew Mcveigh

    This file is part of F# Unaffiliated BTC-E Trading Framework.

    F# Unaffiliated BTC-E Trading Framework is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    F# Unaffiliated BTC-E Trading Framework is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with F# Unaffiliated BTC-E Trading Framework. If not, see <http://www.gnu.org/licenses/>.
*)

namespace BtceApiFramework

module PrivateBtceApi =

    open System.Net
    open System
    open HttpRequestHandler
    open Newtonsoft.Json

    open Currency

    type OrderBy =
        | Ascending
        | Descending

    type TradeType =
        | Buy
        | Sell

    type Parameter =
        | From      of int
        | Count     of int
        | FromId    of int
        | EndId     of int
        | Order     of OrderBy
        | Since     of int64
        | End       of int64
        | Pair      of (Currency * Currency)
        | Type      of TradeType
        | Rate      of Decimal
        | Amount    of Decimal
        | OrderId   of int
        | Active    of bool

    let parameterValueToString (parameter: Parameter) : string =
        match parameter with
            | Order(Ascending)  -> "ASC"
            | Order(Descending) -> "DESC"
            | Pair(pair)        -> currencyPairToString(pair)
            | From(x)           -> x.ToString()
            | Count(x)          -> x.ToString()
            | FromId(x)         -> x.ToString()
            | EndId(x)          -> x.ToString()
            | Since(x)          -> x.ToString()
            | End(x)            -> x.ToString()
            | Type(Buy)         -> "buy"
            | Type(Sell)        -> "sell"
            | Rate(x)           -> x.ToString()
            | Amount(x)         -> x.ToString()
            | OrderId(x)        -> x.ToString()
            | Active(x)         -> if x then "1" else "0"

    let parameterToString (parameter: Parameter) : string =
        match parameter with
            | Order(_)      -> "order"
            | Pair(_)       -> "pair"
            | From(_)       -> "from"
            | Count(_)      -> "count"
            | FromId(_)     -> "from_id"
            | EndId(_)      -> "end_id"
            | Since(_)      -> "since"
            | End(_)        -> "end"
            | Type(_)       -> "type"
            | Rate(_)       -> "rate"
            | Amount(_)     -> "amount"
            | OrderId(_)    -> "order_id"
            | Active(_)     -> "active"

    type ExpectedParameter = {
        required: bool;
        parameterName: string
    }

    type ValidationResult = 
        | Success
        | Failure of string

    let getDuplicatedItems<'T> (items: 'T list) : 'T list =
        let existingItems = new System.Collections.Generic.List<'T>()

        let duplicates = fun(i) -> 
            if existingItems.Contains(i) then 
                true 
            else 
                existingItems.Add(i)
                false

        List.filter duplicates items

    let getMissingRequiredParameters (expectedItems: ExpectedParameter list) (items: string list) : string list =
        let missingRequiredParameter = fun(expected: ExpectedParameter) -> 
            if expected.required && not (List.exists (fun item -> expected.parameterName = item) items) then
                true
            else
                false

        let missingRequiredParameters = List.filter missingRequiredParameter expectedItems

        List.map (fun x -> x.parameterName) missingRequiredParameters

    let getUnexpectedParameters (expectedItems: ExpectedParameter list) (items: string list) : string list =
        let unexpected = fun(item) -> 
            if not (List.exists (fun expected -> expected.parameterName = item) expectedItems) then
                true
            else
                false

        List.filter unexpected items

    let validateParameters (expectedParameters: ExpectedParameter list) (parameters: Parameter list) : ValidationResult = 
        let parameterStrings = List.map (fun(p) -> parameterToString(p)) parameters

        let duplicatedStrings = getDuplicatedItems parameterStrings
        match duplicatedStrings.IsEmpty with
            | true -> 
                let missingRequiredParameters = getMissingRequiredParameters expectedParameters parameterStrings
                match missingRequiredParameters.IsEmpty with
                    | true -> 
                        let unexpectedParameters = getUnexpectedParameters expectedParameters parameterStrings
                        match unexpectedParameters.IsEmpty with
                            | true -> Success

                            | false -> Failure("Unexpected parameters: " + unexpectedParameters.ToString())

                    | false -> Failure("Missing required parameters: " + missingRequiredParameters.ToString())

            | false -> Failure("Duplicate parameters found: " + List.reduce (fun x y -> x + ", " + y) duplicatedStrings)

    type Response<'T> =
        | Success of 'T
        | Error of string

    let apiUrl: string = "https://btc-e.com/tapi"

    type Funds = {
        usd: Decimal;
        btc: Decimal;
        ltc: Decimal;
        nmc: Decimal;
        rur: Decimal;
        eur: Decimal;
        nvc: Decimal;
        trc: Decimal;
        ppc: Decimal;
        ftc: Decimal;
        cnc: Decimal
    }

    type Rights = { 
        info: int;
        trade: int;
        withdraw: int 
    }

    type AccountInformation = {
        funds: Funds;
        rights: Rights;
        [<field: JsonProperty(PropertyName="transaction_count")>] 
        transactionCount: int;
        [<field: JsonProperty(PropertyName="open_orders")>] 
        openOrders: int;
        [<field: JsonProperty(PropertyName="server_time")>] 
        serverTime: int64
    }

    type Transaction = {
        [<field: JsonProperty(PropertyName="type")>] 
        transactionType: int;
        amount: Decimal;
        currency: string; // Currency
        desc: string;
        status: int;
        timestamp: int64
    }

    type TransactionHistory = {
        transactions: (int * Transaction) list
    }

    type PastTrade = {
        pair: string; // Currency * Currency
        [<field: JsonProperty(PropertyName="type")>] 
        tradeType: string; // TradeType
        amount: Decimal;
        rate: Decimal;
        [<field: JsonProperty(PropertyName="order_id")>] 
        orderId: int;
        [<field: JsonProperty(PropertyName="is_your_order")>] 
        isYourOrder: int; // bool
        timestamp: int64
    }

    type TradeHistory = {
        trades: (int * PastTrade) list
    }

    type Order = {
        pair: string;
        [<field: JsonProperty(PropertyName="type")>] 
        orderType: string;
        amount: Decimal;
        rate: Decimal;
        [<field: JsonProperty(PropertyName="timestamp_created")>] 
        timestampCreated: int64;
        status: int
    }

    type OrderList = {
        orders: (int * Order) list
    }

    type Trade = {
        received: Decimal;
        remains: Decimal;
        [<field: JsonProperty(PropertyName="order_id")>] 
        orderId: int;
        funds: Funds
    }

    type CancelledOrder = {
        [<field: JsonProperty(PropertyName="order_id")>] 
        orderId: int;
        funds: Funds
    }

    let parseRights (jsonObject : Linq.JToken) : Rights =
        JsonConvert.DeserializeObject<Rights>(jsonObject.ToString())

    let parseFunds (jsonObject : Linq.JToken) : Funds =
        JsonConvert.DeserializeObject<Funds>(jsonObject.ToString())

    let parseInfo (jsonObject : Linq.JObject) : AccountInformation =
        JsonConvert.DeserializeObject<AccountInformation>(jsonObject.["return"].ToString())

    let parseTransaction (jsonObject : Linq.JToken) : Transaction =
        JsonConvert.DeserializeObject<Transaction>(jsonObject.ToString())
    
    let parseIdList<'T> (jsonRootObject: Linq.JToken) (parser: Linq.JToken -> 'T) : (int * 'T) list =
        [ for child in jsonRootObject.["return"]
            do 
                let childProperty: Linq.JProperty = child :?> Linq.JProperty
                yield ((int)childProperty.Name, parser(jsonRootObject.["return"].[childProperty.Name.ToString()])) ]

    let parseTransactionHistory (jsonRootObject : Linq.JObject) : TransactionHistory =
        {
            transactions = parseIdList jsonRootObject parseTransaction
        }

    let parsePastTrade (jsonObject : Linq.JToken) : PastTrade =
        JsonConvert.DeserializeObject<PastTrade>(jsonObject.ToString())

    let parseTradeHistory (jsonRootObject: Linq.JObject) : TradeHistory =
        {
            trades = parseIdList jsonRootObject parsePastTrade
        }

    let parseOrder (jsonObject : Linq.JToken) : Order =
        JsonConvert.DeserializeObject<Order>(jsonObject.ToString())

    let parseOrderList (jsonRootObject : Linq.JObject) : OrderList =
        {
            orders = parseIdList jsonRootObject parseOrder
        }

    let parseTrade (jsonRootObject : Linq.JObject) : Trade =
        JsonConvert.DeserializeObject<Trade>(jsonRootObject.["return"].ToString())

    let parseCancelledOrder (jsonRootObject : Linq.JObject) : CancelledOrder =
        JsonConvert.DeserializeObject<CancelledOrder>(jsonRootObject.["return"].ToString())

    let parseResponse<'T> (response: string) (successParser: Linq.JObject -> 'T) : Response<'T> =
        let jsonRootObject = Linq.JObject.Parse(response)

        match ((int)jsonRootObject.["success"]) with
            | 1 -> Success(successParser(jsonRootObject))
            | _ -> Error(jsonRootObject.["error"].ToString())


    let getAccountInformationWithCustomRequestHandler requestHandler (key: string) (secret: string) : Response<AccountInformation> =
        let response = requestHandler apiUrl key secret [("method", "getInfo")]
        parseResponse response parseInfo

    let getAccountInformation = getAccountInformationWithCustomRequestHandler httpRequestHandler

    let getStringParameterList (expectedParameters: ExpectedParameter list) (parameters: Parameter list) : (string * string) list =
        match validateParameters expectedParameters parameters with
            | ValidationResult.Success -> ()
            | ValidationResult.Failure(message) -> failwith message 
        |> ignore

        List.map (fun p -> (parameterToString(p), parameterValueToString(p))) parameters

    let getTransactionHistoryWithCustomRequestHandler requestHandler (key: string) (secret: string) (parameters: Parameter list) : Response<TransactionHistory> =
        let expectedParameters = [
            { required = false; parameterName = "from" };
            { required = false; parameterName = "count" };
            { required = false; parameterName = "from_id" };
            { required = false; parameterName = "end_id" };
            { required = false; parameterName = "order" };
            { required = false; parameterName = "since" };
            { required = false; parameterName = "end" }
        ]

        let parameters = ("method", "TransHistory") :: getStringParameterList expectedParameters parameters
    
        let response = requestHandler apiUrl key secret parameters
        parseResponse response parseTransactionHistory

    let getTransactionHistory = getTransactionHistoryWithCustomRequestHandler httpRequestHandler


    let getTradeHistoryWithCustomRequestHandler requestHandler (key: string) (secret: string) (parameters: Parameter list) : Response<TradeHistory> =
        let expectedParameters = [
            { required = false; parameterName = "from" };
            { required = false; parameterName = "count" };
            { required = false; parameterName = "from_id" };
            { required = false; parameterName = "end_id" };
            { required = false; parameterName = "order" };
            { required = false; parameterName = "since" };
            { required = false; parameterName = "end" };
            { required = false; parameterName = "pair" }
        ]

        let parameters = ("method", "TradeHistory") :: getStringParameterList expectedParameters parameters
    
        let response = requestHandler apiUrl key secret parameters
        parseResponse response parseTradeHistory

    let getTradeHistory = getTradeHistoryWithCustomRequestHandler httpRequestHandler


    let getOrderListWithCustomRequestHandler requestHandler (key: string) (secret: string) (parameters: Parameter list) : Response<OrderList> =
        let expectedParameters = [
            { required = false; parameterName = "from" };
            { required = false; parameterName = "count" };
            { required = false; parameterName = "from_id" };
            { required = false; parameterName = "end_id" };
            { required = false; parameterName = "order" };
            { required = false; parameterName = "since" };
            { required = false; parameterName = "end" };
            { required = false; parameterName = "pair" };
            { required = false; parameterName = "active" }
        ]

        let parameters = ("method", "OrderList") :: getStringParameterList expectedParameters parameters
    
        let response = requestHandler apiUrl key secret parameters
        parseResponse response parseOrderList

    let getOrderList = getOrderListWithCustomRequestHandler httpRequestHandler


    let tradeWithCustomRequestHandler requestHandler (key: string) (secret: string) (parameters: Parameter list) : Response<Trade> =
        let expectedParameters = [
            { required = true; parameterName = "pair" };
            { required = true; parameterName = "type" };
            { required = true; parameterName = "rate" };
            { required = true; parameterName = "amount" }
        ]

        let parameters = ("method", "Trade") :: getStringParameterList expectedParameters parameters
    
        let response = requestHandler apiUrl key secret parameters
        parseResponse response parseTrade

    let trade = tradeWithCustomRequestHandler httpRequestHandler


    let cancelOrderWithCustomRequestHandler requestHandler (key: string) (secret: string) (parameters: Parameter list) : Response<CancelledOrder> =
        let expectedParameters = [
            { required = true; parameterName = "order_id" }
        ]

        let parameters = ("method", "CancelOrder") :: getStringParameterList expectedParameters parameters
    
        let response = requestHandler apiUrl key secret parameters
        parseResponse response parseCancelledOrder

    let cancelOrder = cancelOrderWithCustomRequestHandler httpRequestHandler