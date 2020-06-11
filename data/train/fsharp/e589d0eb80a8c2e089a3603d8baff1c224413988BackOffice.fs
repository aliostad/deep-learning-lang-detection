namespace AyinExcelAddIn.Backoffice

open Microsoft.FSharp.Linq
open Microsoft.FSharp.Reflection
open System
open System.Linq
open FSharpx
open FSharp.Data.Sql

open AyinExcelAddIn
open AyinExcelAddIn.Utils

//-------------------------------------------------------------------------------------
//                                       Security
//-------------------------------------------------------------------------------------
type Currency =
    | EUR
    | GBP
    | USD

    static member fromStr str =
        match str with
        | "USD" -> USD
        | "EUR" -> EUR
        | "GBP" -> GBP
        | _ -> failwith <| "Unknown currency: " + str

    override this.ToString() =
        let info, _ = FSharpValue.GetUnionFields(this, this.GetType())
        info.Name

//-------------------------------------------------------------------------------------
//                                       Security
//-------------------------------------------------------------------------------------
module public Security =
    ///
    type SecurityType =
        | EQUITY
        | CURRENCY
        | FUTURE
        | REPO
        | CDS
        | ABS
        | CONVERTIBLE
        | FX_FORWARD
        override this.ToString() =
            let info, _ = FSharpValue.GetUnionFields(this, this.GetType())
            info.Name

    ///
    type SecurityId =
        | CUSIP of string
        | ISIN of string
        | SEDOL of string

    ///
    type T =
        { id : int
          description : string option
          symbol : string
          cusip : string option
          isin : string option
          sedol : string option
          currency : string
          sectype : SecurityType
          issuer : string option }

    ///
    let secid s =
        List.pick id [ s.cusip
                       s.isin
                       s.sedol
                       Some s.symbol ]
    ///
    let private toSecurityType str =
        match str with
        | "FX Forward" -> FX_FORWARD
        | "Equity" -> EQUITY
        | "Currency" | "CCY" -> CURRENCY
        | "Repo" | "REPO" -> REPO
        | "CDS Index Swap" -> CDS
        | "Future" -> FUTURE
        | "ABS/MBS" | "ABS" -> ABS
        | "Bond Convertible" | "CONV" -> CONVERTIBLE
        | _ -> failwith <| "Unknown security type: " + str

    ///
    let create (s: Db.nyabsDbCon.dataContext.``backoffice.paladyne_securitiesEntity``) =
        let sectype = toSecurityType s.SecTypeName

        let symbolid =
            match sectype with
            | FUTURE -> s.Ticker
            | ABS | CONVERTIBLE -> s.Description
            | _ -> s.Symbol
        { id = s.Id
          description = s.Description.ToFSharpOption()
          symbol = symbolid
          cusip = s.Cusip.ToFSharpOption()
          isin = s.Isin.ToFSharpOption()
          sedol = s.Sedol.ToFSharpOption()
          currency = s.CurrencyCode
          sectype = sectype
          issuer = s.IssuerName.ToFSharpOption() }

    ///
    let public getSecurityById id =
        let db = Db.nyabsDbCon.GetDataContext()

        let s =
            query {
                for s in db.Backoffice.PaladyneSecurities do
                    where (s.Id = id)
                    select s
                    headOrDefault
            }
        
        match s with
        | null -> Left <| "Couldn't find security with id: " + id.ToString()
        | _ -> Right <| create s

    ///
    let public getSecurity str =
        let db = Db.nyabsDbCon.GetDataContext()

        let s =
            query {
                for s in db.Backoffice.PaladyneSecurities do
                    where
                        ((s.Cusip = str) || (s.Isin = str) || (s.Sedol = str) || (s.Symbol = str) || (s.Ticker = str)
                         || (s.Description = str))
                    select s
                    headOrDefault
            }
        match s with
        | null -> Left <| "Couldn't find security with symbol: " + str
        | _ -> Right <| create s

    ///
    let public allSecurities =
        let db = Db.nyabsDbCon.GetDataContext()
        query {
            for s in db.Backoffice.PaladyneSecurities do
                select s
        }
        |> Seq.map create
        |> Seq.toList


//-------------------------------------------------------------------------------------
//                                       Trade
//-------------------------------------------------------------------------------------
module public Trade =
    ///
    type TradeType =
        BUY | SELL

        override this.ToString() =
            let info, _ = FSharpValue.GetUnionFields(this, this.GetType())
            info.Name


    ///
    type T = {
        id : int;
        security : Security.T;
        tradeType : TradeType;
        tradeDate : DateTime;
        settleDate : DateTime;
        currency : Currency;
        quantity : decimal;
        price : decimal;
        commission : decimal;
        accrued : decimal;
        broker : string option;
        fund : string;
        notional : decimal;
        totalAmnt : decimal;
        factor : decimal;
    }

    ///
    let private toTradeType str =
        match str with
        | "Buy" -> BUY
        | "Sell" -> SELL
        | _ -> failwith <| "Unknown trade type: " + str

    ///
    let private createS (s: Security.T) (t: Db.nyabsDbCon.dataContext.``backoffice.paladyne_transactionsEntity``) =
        { id = t.Id;
          security = s;
          tradeType = toTradeType t.TransactionTypeName;
          tradeDate = t.TradeDate;
          settleDate = t.SettleDate;
          currency = Currency.fromStr t.TradeCurrency;
          quantity = t.Quantity;
          price = t.TradePrice;
          commission = t.TradeTotalCommission;
          accrued = t.AccruedLocal;
          broker = t.BrokerCode.ToFSharpOption();
          fund = t.FundCode;
          notional = t.TradeNotional;
          totalAmnt = t.TradeTotalConsideration;
          factor = t.CurrentFactor;
        }

    ///
    let private create (t:  Db.nyabsDbCon.dataContext.``backoffice.paladyne_transactionsEntity``) =
        createS (either (Security.getSecurityById t.SecurityId) failwith id) t

    ///
    let public getSecurityTrades str =
        match Security.getSecurity str with
        | Left _ -> List.Empty
        | Right security ->
            let db = Db.nyabsDbCon.GetDataContext()

            query {
                for t in db.Backoffice.PaladyneTransactions do
                join s in db.Backoffice.PaladyneSecurities on (t.SecurityId = s.Id)
                where ((s.Id = security.id)
                        && ((t.TransactionTypeName = "Buy") || (t.TransactionTypeName = "Sell")))
                sortBy t.TradeDate
                select t
            }
            |> Seq.filter (fun r -> not r.Canceled)
            |> Seq.map (createS security)
            |> Seq.toList

    ///
    let public getTradesByDate d1 d2 =
        let db = Db.nyabsDbCon.GetDataContext()

        query {
            for t in db.Backoffice.PaladyneTransactions do
            where ((t.TradeDate >= d1) && (t.TradeDate <= d2)
                    && ((t.TransactionTypeName = "Buy") || (t.TransactionTypeName = "Sell")))
            sortBy t.TradeDate
            select t
        }
        |> Seq.filter (fun r -> not r.Canceled)
        |> Seq.map create
        |> Seq.toList


//-------------------------------------------------------------------------------------
//                                       Position
//-------------------------------------------------------------------------------------
module public Position =
    ///
    type T =
        { id : int
          date : DateTime
          security : Security.T
          currency : Currency
          fund : string
          quantity : decimal
          unitCost : decimal 
          lastPrice : decimal
          marketVal : decimal
          rate : decimal 
          origFace : decimal
          collateral : string option }

    ///
    let getPositions date =
        let db = Db.nyabsDbCon.GetDataContext()
        try
            let lastDate =
                query {
                    for p in db.Backoffice.PaladynePositions do
                        where (p.Date <= date)
                        maxBy (p.Date)
                }

            let q1 =
                query {
                    for p in db.Backoffice.PaladynePositions do
                    join t in (!!) db.Intex.Tranches on (p.Cusip = t.Cusip)// into result1
                    //for t in result1.DefaultIfEmpty() do
                    join d in (!!) db.Intex.Deals on (t.DealId = d.Id)// into result2
                    where ((p.Date = lastDate) && (p.Cusip <> ""))
                    //for d in result2.DefaultIfEmpty() do
                    select (p, d.CollatType)
                }

            let q2 =
                query {
                    for p in db.Backoffice.PaladynePositions do
                        where ((p.Date = lastDate) && (p.Cusip = ""))
                        select (p, (null : string))
                }

            Seq.append q1 q2
            |> Seq.map (fun (p, c) ->
                   let s = either (Security.getSecurityById p.SecurityId) failwith id
                   { id = p.Id
                     date = p.Date
                     security = s
                     currency = Currency.fromStr p.CurrencyCode
                     fund = p.FundCode
                     quantity = p.Position
                     unitCost = p.UnitCostLocal
                     lastPrice = p.EndPrice
                     marketVal = p.MktValue
                     rate = p.Rate
                     origFace = p.Notional
                     collateral =
                         match (s.sectype, c) with
                         | (Security.ABS, null) -> Some "Other"
                         | (_, null) -> None
                         | _ -> Some c })
            |> Seq.toList
        with _ -> []

//-------------------------------------------------------------------------------------
//                                       Broker
//-------------------------------------------------------------------------------------
module public Broker =
    type T =
        { id : int
          name : string
          notes : string }

    // Creates a Broker type from a record in the brokers table.
    let internal create (br : Db.nyabsDbCon.dataContext.``backoffice.brokersEntity``) =
        { id = br.Id
          name = br.Name
          notes = br.Notes }

    let getBrokerByName name =
        let db = Db.nyabsDbCon.GetDataContext()

        let res =
            query {
                for br in db.Backoffice.Brokers do
                    where (br.Name = name)
                    select br
            }
            |> Seq.toList
        match res with
        | br :: _ -> Right <| create br
        | _ -> Left <| "No broker found with name: \"" + name + "\""

    ///
    let allBrokers =
        let db = Db.nyabsDbCon.GetDataContext()
        query {
            for b in db.Backoffice.Brokers do
                select b
        }
        |> Seq.map create
        |> Seq.toList

    ///
    let quotingBrokers (s : Security.T) =
        let db = Db.nyabsDbCon.GetDataContext()
        query {
            for qb in db.Backoffice.QuotingBrokers do
                join b in db.Backoffice.Brokers on (qb.BrokerId = b.Id)
                where (qb.SecurityId = s.id)
                select b
        }
        |> Seq.map create
        |> Seq.toList

//-------------------------------------------------------------------------------------
//                                       Quote
//-------------------------------------------------------------------------------------
module public Quote =
    type T =
        { id : int
          security : Security.T
          broker : Broker.T
          price : decimal
          date : DateTime
          currency : Currency
          challanged : bool }

    // Field accessor functions
    let id q = q.id
    let broker q = q.broker
    let price q = q.price
    let date q = q.date
    let currency q = q.currency

    let public getQuoteById id =
        let db = Db.nyabsDbCon.GetDataContext()

        let (q, b) =
            query {
                for q in db.Backoffice.Quotes do
                    join b in db.Backoffice.Brokers on (q.BrokerId = b.Id)
                    where (q.Id = id)
                    select (q, b)
                    headOrDefault
            }
        match (q, b) with
        | (null, _) -> failwith <| "Couldn't find quote with id: " + id.ToString()
        | _ ->
            let security = either (Security.getSecurityById q.SecurityId) failwith Operators.id
            { id = q.Id
              security = security
              broker = Broker.create b
              price = q.Quote
              date = q.Date
              currency = Currency.fromStr q.Currency
              challanged = q.Challanged }

    /// <summary>
    /// Returns the quotes for the security for the specified interval.
    /// </summary>
    let public quotes (d1 : DateTime) (d2 : DateTime) (s : Security.T) =
        let db = Db.nyabsDbCon.GetDataContext()
        query {
            for q in db.Backoffice.Quotes do
                join br in db.Backoffice.Brokers on (q.BrokerId = br.Id)
                where ((q.SecurityId = s.id) && (q.Date >= d1 && q.Date <= d2))
                sortByDescending q.Date
                select (br, q.Id, q.Quote, q.Date, q.Currency, q.Challanged)
        }
        |> Seq.map (fun (b, id, p, d, c, ch) ->
               { id = id
                 security = s
                 broker = Broker.create b
                 price = p
                 date = d
                 currency = Currency.fromStr c
                 challanged = ch })
        |> Seq.toList

    /// <summary>
    /// Returns the quotes for the security and broker for the specified interval.
    /// </summary>
    let public quotesByBroker (b : Broker.T) (sd : DateTime) (ed : DateTime) (s : Security.T) =
        let db = Db.nyabsDbCon.GetDataContext()
        query {
            for q in db.Backoffice.Quotes do
                where ((q.SecurityId = s.id) && (q.BrokerId = b.id) && (q.Date >= sd && q.Date <= ed))
                sortByDescending q.Date
                select (q.Id, q.Quote, q.Date, q.Currency, q.Challanged)
        }
        |> Seq.map (fun (id, p, d, c, ch) ->
               { id = id
                 security = s
                 broker = b
                 price = p
                 date = d
                 currency = Currency.fromStr c
                 challanged = ch })
        |> Seq.toList

    /// <summary>
    /// Returns the most quote for the security and broker that is on or before the specified date.
    /// </summary>
    let public mostRecentQuote (s : Security.T) (b : Broker.T) (sd : DateTime) (ed : DateTime) =
        let db = Db.nyabsDbCon.GetDataContext()
        try
            Some <| query {
                        for q in db.Backoffice.Quotes do
                            where ((q.SecurityId = s.id) && (q.BrokerId = b.id) && (q.Date >= sd && q.Date <= ed))
                            sortByDescending q.Date
                            select q.Quote
                            headOrDefault
                    }
        with _ -> None

