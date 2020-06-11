namespace RyeBayData

open System
open System.IO
open System.Data
open System.Data.Linq
open Microsoft.FSharp.Data.TypeProviders
open Microsoft.FSharp.Linq
open FSharp.Data
open System.Data.Linq.SqlClient
open System.Linq
open FSharp.ExcelProvider
open HigherOrder.TimeSeries
open HigherOrder.Utils
open HigherOrder.TimeSeries.Utils
open Deedle.``F# Series extensions``


module Core = 
    
    module RiskSheetFlds =
        let sheetName = "IFS Portfolio"
        let securityId = "Bloomberg ID"
        let strategy = "Strategy"
        let date = "Report Date"
        let beta = "Beta"
        let indexPrice = "Index price"
        let baseNotional = "Base Notional"
        let indexPrice1 = "Index price - 1day"
        let indexName = "Index atribution"
        let marketCap = "USD Market Cap"
        let volume3mAvr = "VOLUME_AVG_3M"
        let volume6mAvr = "VOLUME_AVG_6M"
        let volume5dAvr = "VOLUME_AVG_5D"
        let indexRetGrossDiv = "Index Rtn Gross Div"
        let ryeBaySector = "Rye Bay Sector"
        let compositeTicker = "Ticker to use"
        let days5d = "5D Days"
        let days3m = "3M Days"
        let days6m = "6M Days"
        let indexSectorForBeta = "EQT_SECTOR"
        let sectorBeta = "EQT_BETA_SECTOR"
        let sectorPrice = "EQT_BETA_SECTOR_LAST_PRICE"
        let sectorPriceM3m = "EQT_BETA_SECTOR_PX_CLOSE_3M"
        let relIndex = "REL_INDEX"
        let currency = "CRNCY"
        let aimPrimeBroker = "AIM_PRIME_BROKER"
        let quantity = "Quantity"

    module NavSheetFlds =
        let sheetName = "NAV_DATA"
        let date = "Date"
        let totalGav = "Total GAV (EUR)"
        let totalNav = "Total NAV (EUR)"
        let portVar = "PORT VaR"
        let aifmdGssLvr = "AIFMD Gross Leverage"
        let aifmdCmtLvr = "AIFMD Commitment Leverage"

    module ClassSheetFlds =
        let sheetName = "Classes"
        let aum = "AUM"
        let nps = "NAV"
        let gps = "GAV"

    type ActionType = FxAttributionUpload = 0 | IfsDailyUpload = 1 | IfsMonthlyUpload = 2 | IfsDirtyDailyUpload = 3 | IfsFinalDailyUpload = 4 | IfsFinalMonthlyUpload = 5 | RiskSheetUpload = 6
                        | UIRunAttribution = 7 | NavSheetUpload = 8 | UIRunHistory = 9 | UIRunExposures = 10 | PurchaseAndSalesUpload = 11 | UIRunPurchaseSales = 12

    type AlertType = Error = 0 | Warning = 1 | Info = 2

    type FxType = Income = 0 | Directional = 1 | Portfolio = 2 | ShareClass = 3

    type Direction = Long = 0 | Short = 1

    type DateType = Mtd = 0 | Qtd = 1 | Ytd = 2 | LastMonth = 3 | LastQuarter = 4 | LastYear = 5 | InceptionToDate = 6 | InceptionToLastMonth = 7 | YearToLastMonth = 8

    type GroupBy = None = 0 | Security = 1 | Direction = 2 | Sector = 3 | Country = 4

    type IndexReturnType = Normal = 0| DivReinvested = 1

    type PerfAttrStats = {
        FundSharpe: double;
        FundVol: double;
        IndexVol: double; 
        IndexSharpe: double;
        IndexCorrelation: double}

    type PerfAttr = { Ticker: string; 
                      Name: string; 
                      Sector: string; 
                      Country: string; 
                      Strategy: string; 
                      Direction: Direction; 
                      TotalBase: decimal; 
                      Attribution: double; 
                      Id: Option<int64>; 
                      ParentId: Option<int64>;
                      Weight: double;
                      Roce: double;
                      Alpha: double;
                      MktRet: double;
                      DaysHeld: int;
                      MktCap: decimal;
                      LiqDays: float; }

     type ExposureDaily2 = {IndustrySector: string
                            IndustryGroup: string
                            GicsIndustryName: string
                            GicsIndustryGroup: string
                            GicsSubIndustryName: string
                            CompositeTicker: string
                            Volume5dAvr: decimal option
                            Days5d: int option
                            Volume3mAvr: decimal option
                            Days3m: int option
                            Volume6mAvr: decimal option
                            Days6m: int option
                            MarketCap: decimal
                            IndexForBeta: string
                            IndexBeta: float
                            IndexSectorForBeta: string
                            SectorBeta: float
                            SectorPrice: decimal
                            SectorPriceM3m: decimal
                            RyeBaySector: string
                            RelIndex: string
                            Currency: string
                            AimPrimeBroker: string
                            IndexRtnGrossDiv: float; }

    type PerfDaily = { Date: DateTime;
                       TotalPnl: decimal;
                       AlphaPnl: decimal;
                       BetaPnl: decimal;
                       Notional: decimal;
                       IndexPrice: decimal;
                       IndexPriceM1: decimal;
                       MktRet: double;
                       MktBeta: double; }

    type ExposureDaily = { Date: DateTime;
                         Id: int64;
                         Ticker: string;
                         Name: string;
                         Sector: string;
                         Country: string;
                         Strategy: string;
                         Direction: Direction;
                         Notional: decimal;
                         Exposure: double;
                         Beta: double;
                         BetaAdj: double;
                         MoreFields: ExposureDaily2 option }

    type ShareClassDesc = { Name: string;
                            HasGav: bool;
                            HasNav: bool; 
                            Id: int64 }

    type StrategyDesc = { Name: string;
                          HasLongs: bool;
                          HasShorts: bool;
                          Id: int64 }

    type ShareClassDaily = { Aum: decimal option;
                             Gav: decimal option;
                             Nav: decimal option }

    type StrategyDaily = { LongNotional: decimal option;
                           LongNotPerc: double option;
                           ShortNotional: decimal option;
                           ShortNotPerc: double option;
                           LongBeta: double option;
                           LongBetaAdj: double option;
                           ShortBeta: double option;
                           ShortBetaAdj: double option }

    type HistoryDaily = { Date: DateTime;
                          Performance: double;
                          Gav: decimal;
                          Nav: decimal;
                          Gross: decimal;
                          GrossPerc: double;
                          Net: decimal;
                          NetPerc: double; 
                          LongNotional: decimal;
                          LongNotPerc: double;
                          ShortNotional: decimal;
                          ShortNotPerc: double; 
                          Beta: double;
                          LongBeta: double;
                          ShortBeta: double;
                          GrossBetaAdj: double;
                          NetBetaAdj: double;
                          LongBetaAdj: double;
                          ShortBetaAdj: double;
                          Vol63: double option;
                          Vol63Ann: double option;
                          IndexVol63: double option;
                          IndexVol63Ann: double option;
                          Vol126: double option;
                          Vol126Ann: double option;
                          IndexVol126: double option;
                          IndexVol126Ann: double option;
                          Vol252: double option;
                          Vol252Ann: double option;
                          IndexVol252: double option;
                          IndexVol252Ann: double option;
                          SharpeRatio: double option;
                          ShareClassEntries: ShareClassDaily array;
                          StrategyEntries: StrategyDaily array;
                          PortfolioVaR: double option;
                          AifmdGrossLeverage: double option;
                          AifmdCommitmentLeverage: double option; }
//                          IndexAttribution: string;
//                          IndexPrice: decimal;
//                          IndexRtnGrossDiv: float; }

    type History = { ShareClasses: ShareClassDesc array;
                     Strategies: StrategyDesc array;
                     Entries: HistoryDaily array; 
                     NetReturn: double;
                     IndexReturn: double;
                     IndexRtnDivReinv: double;
                     FundVol: double;
                     IndexVol: double; 
                     FundSharpe: double;
                     FundSortino: double;
                     Drawdown: double option;
                     DrawdownStart: System.DateTime option;
                     DrawdownEnd: System.DateTime option;
                     GrossPerc: double;
                     NetPerc: double;
                     LongPerc: double;
                     ShortPerc: double; 
                     GrossBetaAdj: double;
                     NetBetaAdj: double;
                     LongBetaAdj: double;
                     ShortBetaAdj: double; }

    type private Pid = PSecurity of int64 * Direction * int64 | PFx of FxType * string * Direction | PFxIncome of int64 * string * Direction * int64

    // Rye Bay Db
    type RyeBaySchema = SqlDataConnection<"Data Source=localhost\SQLEXPRESS;Initial Catalog=RyeBay;Integrated Security=SSPI;">

    type PnlEntry = RyeBaySchema.ServiceTypes.PnlEntry
    type SecurityMaster = RyeBaySchema.ServiceTypes.SecurityMaster
    type FundEntry = RyeBaySchema.ServiceTypes.FundEntry
    type Alert = RyeBaySchema.ServiceTypes.Alert
    type Strategy = RyeBaySchema.ServiceTypes.Strategy
    type FxIncomeEntry = RyeBaySchema.ServiceTypes.FxIncomeEntry
    type Action = RyeBaySchema.ServiceTypes.Action
    type SecurityDaily = RyeBaySchema.ServiceTypes.SecurityDaily
    type ShareClassEntry = RyeBaySchema.ServiceTypes.ShareClassEntry
    type FundDailyEntry = RyeBaySchema.ServiceTypes.FundDailyEntry
    type ShareClass = RyeBaySchema.ServiceTypes.ShareClass
    type PurchaseAndSales = RyeBaySchema.ServiceTypes.PurchaseAndSales
    type SecurityLink = RyeBaySchema.ServiceTypes.SecurityLink

    type DataContext = RyeBaySchema.ServiceTypes.SimpleDataContextTypes.RyeBay

    exception AlertException of Alert

    // IFS File
    type IfsFile = CsvProvider<"C:/AppDev/RyeBay/BBTest/bin/Debug/ifsFile.csv">

    // Risk Sheet File
    type RiskSheetFile = ExcelFile<"C:/AppDev/RyeBay/BBTest/bin/Debug/Database.xlsx", "RBP_Value">

    // Fx Income Sheet
    type FxIncomeFile = ExcelFile<"C:/AppDev/RyeBay/BBTest/bin/Debug/Income_attribution.xlsx", "Upload">

    // Purchase and Sales File
    type PurchaseAndSalesFile = CsvProvider<"C:/AppDev/RyeBay/BBTest/bin/Debug/PS.csv">

    let getDb () = RyeBaySchema.GetDataContext()

    let fxTypes = [FxType.Income, "INCHED"; FxType.Directional, "DIRHED"; FxType.ShareClass, "SSCHED"; FxType.Portfolio, "PORTHD"]

    let getFxType bn = if String.length bn < 6 then None else match fxTypes |> Seq.tryFind (fun (_, s) -> bn.Substring(bn.Length - 6) = s) with
                                                                Some (f, _) -> Some f
                                                              | _ -> None 

    let createError title text action = Alert(Title = title, Text = text, Type = byte AlertType.Error, Date = DateTime.Now, Action = action)

    let createWarning title text action = Alert(Title = title, Text = text, Type = byte AlertType.Warning, Date = DateTime.Now, Action = action)

    let createInfo title text action = Alert(Title = title, Text = text, Type = byte AlertType.Info, Date = DateTime.Now, Action = action)

    type RyeBaySchema.ServiceTypes.PnlEntry with
        member x.BaseTotalCalc with 
            get() = 
                match 1 with
                | _ when x.FxType.HasValue && x.FxType.Value = byte(FxType.Income) -> x.BaseTotal
                | _ -> x.BaseUnrealised + x.BaseRealised + x.BaseIncome 
            and set(v) = 
                    match 1 with
                    | _ when x.FxType.HasValue && x.FxType.Value = byte(FxType.Income) -> x.BaseTotal <- v
                    | _ ->
                        x.BaseRealised <- v
                        x.BaseUnrealised <- 0M
                        x.BaseIncome <- 0M

    let findOrErr err action key msg map =
        match map |> Map.tryFind key with
        | Some value -> value
        | None -> AlertException(createError err msg action) |> raise

    let ignoreWarning (id:string) =
        match id with
        | _ when id.Length > 18 && id.Substring(0, 18) = "CFD RESET INTEREST" -> true
        | _ when id.Length > 4 && id.Substring(4) = "CFD INTEREST" -> true
        | _ when id.Length > 14 && id.Substring(0, 14) = "STOCK LOAN FEE" -> true
        | "INTEREST" -> true
        | "TICKET CHARGES" -> true
        | "SWAP COMMISSION" -> true
        | "British Pound Sterling" -> true
        | "Chinese Yuan Renminbi" -> true
        | "Danish Krone" -> true
        | "Euro" -> true
        | "Norwegian Krone" -> true
        | "Swedish Krona" -> true
        | "U S Dollars" -> true
        | _ -> false

    // queries
    let fetchAllFundEntries (db:DataContext) =
        query { for f in db.FundEntry do
                sortByDescending f.Date
                select f }

    let fetchAllSecurityLinks (db:DataContext) =
        query { for s in db.SecurityLink do
                sortBy s.NewTicker
                select s }

    let fetchSecurityLinks date (db:DataContext) =
        query { for s in db.SecurityLink do
                where (s.Date <= date)
                select s }

    let fetchNetRtn scid sd ed (db:DataContext) =
        let snps = 
            query { for s in db.ShareClassEntry  do
                    where (s.Date < sd && s.ShareClassId = scid)
                    sortByDescending s.Date
                    take 1
                    select s.Nps
                    exactlyOneOrDefault }
        let enps =
            query { for s in db.ShareClassEntry do
                    where (s.Date <= ed && s.ShareClassId = scid)
                    sortByDescending s.Date
                    take 1
                    select s.Nps
                    exactlyOneOrDefault }
        match snps, enps with
          _, 0M -> None
        | 0M, _ -> 
            let startingNav = 
                query { for s in db.ShareClass do
                        where (s.Id = scid)
                        select s.StartingNav
                        exactlyOne }
            Some ((float enps / float startingNav) - 1.0)
        | _ -> Some ((float enps / float snps) - 1.0)

    let fetchSxxp sd ed (db:DataContext) = 
        let s = query { for s in db.SecurityDaily do
                        where (s.Date >= sd && s.Index = "SXXP")
                        sortBy s.Date
                        take 1
                        select s.IndexPriceM1
                        exactlyOneOrDefault }
        let e = query { for s in db.SecurityDaily do
                        where (s.Date <= ed && s.Index = "SXXP")
                        sortByDescending s.Date
                        take 1
                        select s.IndexPrice
                        exactlyOneOrDefault }
        float (e / s) - 1.0

    let fetchSxxpDivreinvRtns sd ed (db:DataContext) = 
        query { for s in db.SecurityDaily do
                where (s.Date <= ed && s.Index = "SXXP")
                sortBy s.Date
                select (s.Date, s.IndexReturnGrossDiv)
                distinct }
        |> Seq.groupBy fst
        |> Seq.map(fun (d, vs) -> vs |> Seq.head)

    let fetchSxxpDivreinv sd ed (db:DataContext) =
        let rtns = db |> fetchSxxpDivreinvRtns sd ed
        (rtns |> Seq.filter (fun (d, _) -> d <= ed && d >= sd) |> Seq.map snd |> Seq.fold (fun cr r -> cr * (1.0 + r)) 1.0) - 1.0

    let fetchSxxpDailies sd ed (db:DataContext) =
        query { for s in db.SecurityDaily do
                where (s.Date <= ed && s.Index = "SXXP")
                sortBy s.Date
                select (s.Date, s.IndexPrice, s.IndexPriceM1)
                distinct }
        |> Seq.groupBy(fun (d, _, _) -> d)
        |> Seq.map(fun (d, vs) -> vs |> Seq.head)

    let fetchSecurities (db:DataContext) =
        query { for s in db.SecurityMaster do
                select s }

    let fetchSecurityDailies sd ed (db:DataContext) = 
        query { for s in db.SecurityDaily do
                where (s.Date >= sd && s.Date <= ed)
                sortBy s.Date
                select s }

    let fetchSecDailiesForSec sd ed id (db:DataContext) = 
        query { for s in db.SecurityDaily do
                where (s.Date >= sd && s.Date <= ed && s.SecurityMasterId = id) 
                sortBy s.Date
                select s }

    let fetchSecurityDaily id date (db:DataContext) = 
        query { for sd in db.SecurityDaily do
                where (sd.Date = date && sd.SecurityMasterId = id)
                select sd
                exactlyOneOrDefault }

    let fetchPurchaseSales sd ed (db:DataContext) =
        query {
            for p in db.PurchaseAndSales do
            where (p.TradeDate >= sd && p.TradeDate <= ed)
            sortBy p.Id
            select p }

    let fetchFundDailyEntry date (db:DataContext) = 
        query { for fd in db.FundDailyEntry do
                where (fd.Date = date)
                select fd
                exactlyOneOrDefault }

    let fetchFundDailyEntries sd ed (db:DataContext) = 
        query { for fd in db.FundDailyEntry do
                where (fd.Date >= sd && fd.Date <= ed)
                select fd }

    let fetchShareClass name (db:DataContext) = 
        query { for sc in db.ShareClass do
                where (sc.Name = name)
                select sc
                exactlyOneOrDefault }

    let fetchShareClasses (db:DataContext) = 
        query { for sc in db.ShareClass do
                select sc }

    let fetchStartingNav scid sd (db:DataContext) = 
        query { for sc in db.ShareClassEntry do
                where (sc.ShareClassId = scid && sc.Date < sd)
                sortByDescending sc.Date
                take 1
                exactlyOneOrDefault }

    let fetchShareClassEntry scid date (db:DataContext) = 
        query { for se in db.ShareClassEntry do
                where (se.Date = date && se.ShareClassId = scid)
                select se
                exactlyOneOrDefault }

    let fetchShareClassEntries sd ed (db:DataContext) = 
        query { for se in db.ShareClassEntry do
                where (se.Date >= sd && se.Date <= ed) 
                select se }

    let fetchShareClassEntriesForClass scid sd ed (db:DataContext) = 
        query { for se in db.ShareClassEntry do
                where (se.Date >= sd && se.Date <= ed && se.ShareClassId = scid)
                select se }

    let fetchAlertsForAction id (db:DataContext) = 
        query { for alert in db.Alert do
                where (alert.ActionId = id)
                select alert }

    let fetchLatestActions (db:DataContext) = 
        let info = byte AlertType.Info
        let warning = byte AlertType.Warning
        let error = byte AlertType.Error
        query { for action in db.Action do
                sortByDescending action.Date
                select (action, query { for a in action.Alert do 
                                        where (a.Type = info) 
                                        select a 
                                        count },
                                query { for a in action.Alert do 
                                        where (a.Type = warning) 
                                        select a 
                                        count },
                                query { for a in action.Alert do 
                                        where (a.Type = error) 
                                        select a 
                                        count })
                take 50 }

    let latestFxIncomeDate (db:DataContext) = query { for entry in db.FxIncomeEntry do
                                                      maxBy entry.Date }

    let fetchFxIncomeEntries (sd :DateTime) (ed :DateTime) (db:DataContext) = 
        let sd = query { for entry in db.FxIncomeEntry do
                         where (entry.Date <= sd)
                         maxBy entry.Date }
        query { for entry in db.FxIncomeEntry do
                where (entry.Date >= sd && entry.Date <= ed)
                sortBy entry.Date
                select entry }

    let fetchFxIncomeForDate (d :DateTime) (db:DataContext) = 
        query { for entry in db.FxIncomeEntry do
                where (entry.Date = d)
                select entry }

    let latestPnlEntryDate (db:DataContext) = 
        query { for entry in db.PnlEntry do
                maxBy entry.Date }

    let containsUnreadAlerts (db:DataContext) = 
        query { for alert in db.Alert do
                select alert.Seen
                contains false }

    let fetchUnreadAlerts (db:DataContext) = 
        query { for alert in db.Alert do
                where (not alert.Seen)
                sortBy alert.Type
                thenByDescending alert.Date
                select alert }

    let fetchStrategies (db:DataContext) = 
        query { for st in db.Strategy do
                select st }

    let fetchSecExists (tickers:string[]) (db:DataContext) = 
        query { for sec in db.SecurityMaster do
                where (tickers.Contains(sec.Ticker))
                select sec.Ticker }

    let fetchStrategyByName name (db:DataContext) = 
        query { for strat in db.Strategy do
                where (strat.Name = name)
                select strat
                exactlyOneOrDefault }

    let fetchSecurityById id (db:DataContext) = 
        query { for sec in db.SecurityMaster do
                where (sec.Id = id)
                select sec
                exactlyOneOrDefault }

    let fetchSecurityByTicker ticker (db:DataContext) = 
        query { for sec in db.SecurityMaster do
                where (sec.Ticker = ticker)
                select sec
                exactlyOneOrDefault }

    let fetchSecuritiesByIds (ids:int64[]) (db:DataContext) = 
        query { for sec in db.SecurityMaster do
                where (ids.Contains(sec.Id))
                select sec }

    let fetchSecuritiesByTickers (tickers:string[]) (db:DataContext) = 
        query { for sec in db.SecurityMaster do
                where (tickers.Contains(sec.Ticker))
                select sec }

    let fetchFundEntry (db:DataContext) = 
        query { for entry in db.FundEntry do
                sortByDescending entry.Date
                select entry
                take 1 } 
                                  
    let fetchFundEntries (sd:DateTime) (ed:DateTime) (db:DataContext) = 
        let q1 = 
            query { for entry in db.FundEntry do
                    where (entry.Date <= sd)
                    sortByDescending entry.Date
                    select entry
                    take 1 }
        let q2 = 
            query { for entry in db.FundEntry do
                    where (entry.Date > sd && entry.Date <= ed)
                    sortBy entry.Date
                    select entry }
        q1.Union q2

    let fetchPnlEntries (sd:DateTime) (ed:DateTime) (me:bool) (db:DataContext) = 
        query { for entry in db.PnlEntry do
                where (entry.Date >= sd && entry.Date <= ed && entry.IsMonthEnd = me) //&& entry.BaseTotal <> 0M)
                sortBy entry.Date
                select entry }

    let fetchPnlEntriesForSec (sd:DateTime) (ed:DateTime) (id:int64) (db:DataContext) = 
        query { for entry in db.PnlEntry do
                where (entry.Date >= sd && entry.Date <= ed && entry.IsMonthEnd = false && entry.SecurityId.HasValue && entry.SecurityId.Value = id)
                sortBy entry.Date
                select entry }

    let getPnlEntries (sd:DateTime) (ed:DateTime) (db:DataContext) = db |> fetchPnlEntries sd ed false

    let getCurrencyPair (name:string) = let split = name.Split ' '
                                        split.[1] + split.[3]

    let addOrUpdateSecurityLink (slink :SecurityLink) =
        use db = getDb ()
        let sl = 
            query { for sl in db.SecurityLink do
                    where (sl.Id = slink.Id)
                    select sl
                    exactlyOneOrDefault }
        if sl = null then
            slink |> db.SecurityLink.InsertOnSubmit
        else
            sl.Date <- slink.Date
            sl.OldTicker <- slink.OldTicker
            sl.NewTicker <- slink.NewTicker
            sl.ErrorOnOverlap <- slink.ErrorOnOverlap
        db.DataContext.SubmitChanges()

    let addOrUpdateFundEntry date assets =
        use db = getDb ()
        let fe =
            query { for fe in db.FundEntry do
                    where (fe.Date = date)
                    select fe
                    exactlyOneOrDefault }
        if fe = null then
            FundEntry(Date = date, OpeningAssets = assets) |> db.FundEntry.InsertOnSubmit
        else
            fe.OpeningAssets <- assets
        db.DataContext.SubmitChanges()

    let getDates (dateType :DateType) = 
        let today = System.DateTime.Now.Date
        match dateType with
          DateType.Mtd -> System.DateTime(today.Year, today.Month, 1), today
        | DateType.Qtd -> 
            match today.Month with
              _ when today.Month >= 10 -> System.DateTime(today.Year, 10, 1), today
            | _ when today.Month >= 7 -> System.DateTime(today.Year, 7, 1), today
            | _ when today.Month >= 4 -> System.DateTime(today.Year, 4, 1), today
            | _ -> System.DateTime(today.Year, 1, 1), today
        | DateType.Ytd -> System.DateTime(today.Year, 1, 1), today
        | DateType.LastMonth -> 
            let pm = today.AddMonths(-1)
            System.DateTime(pm.Year, pm.Month, 1), System.DateTime(pm.Year, pm.Month, DateTime.DaysInMonth(pm.Year, pm.Month))
        | DateType.LastQuarter -> 
            match today.Month with
              _ when today.Month >= 10 -> System.DateTime(today.Year, 7, 1), System.DateTime(today.Year, 9, 30)
            | _ when today.Month >= 7 -> System.DateTime(today.Year, 4, 1), System.DateTime(today.Year, 6, 30)
            | _ when today.Month >= 4 -> System.DateTime(today.Year, 1, 1), System.DateTime(today.Year, 3, 31)
            | _ -> System.DateTime(today.Year - 1, 10, 1), System.DateTime(today.Year - 1, 12, 31)
        | DateType.LastYear -> System.DateTime(today.Year - 1, 1, 1), System.DateTime(today.Year - 1, 12, 31)
        | DateType.YearToLastMonth -> 
            let pm = today.AddMonths(-1)
            System.DateTime(today.Year, 1, 1), System.DateTime(pm.Year, pm.Month, DateTime.DaysInMonth(pm.Year, pm.Month))
        | DateType.InceptionToDate -> Config.inceptionDate, today
        | DateType.InceptionToLastMonth -> 
            let pm = today.AddMonths(-1)
            Config.inceptionDate, System.DateTime(pm.Year, pm.Month, DateTime.DaysInMonth(pm.Year, pm.Month))
        | _ -> failwith "DateType not supported"

    let getPerfDailies (sd:DateTime) (ed:DateTime) (id:int64) (db:DataContext) = 
        let secs = db |> fetchSecurities |> Seq.toList
        let secMap = secs |> Seq.map(fun s -> s.Id, s) |> Map.ofSeq
        // do the mapping
        let secIdByTicker = secs |> List.map (fun s -> s.Ticker.ToUpper(), s.Id) |> Map.ofList
        let slinks = db |> fetchSecurityLinks ed |> Seq.toList
        let slinkmap = slinks |> List.choose (fun s ->
            match secIdByTicker |> Map.tryFind s.OldTicker, secIdByTicker |> Map.tryFind s.NewTicker with
            | Some oid, Some nid -> Some (oid, nid)
            | _ -> None) |> Map.ofList
        let slinkoverlap = 
            slinks |> List.choose (fun s ->
                match secIdByTicker |> Map.tryFind s.NewTicker with
                | Some nid -> Some (nid, (s.ErrorOnOverlap, s.Date))
                | _ -> None) |> Map.ofList

        let allids = id::(slinkmap |> Map.toList |> List.choose (fun (oid, nid) -> if oid = id then Some nid else if nid = id then Some oid else None)) |> Seq.distinct |> Seq.toList
        
        let sds = allids |> List.collect(fun id -> db |> fetchSecDailiesForSec sd ed id |> Seq.toList) |> List.sortBy (fun s -> s.Date)
        let sds = sds |> Seq.map(fun se -> (se.Date, se.SecurityMasterId), se)
                      |> Map.ofSeq
        let pes = allids |> List.collect(fun id -> db |> fetchPnlEntriesForSec sd ed id |> Seq.toList) |> List.sortBy (fun s -> s.Date)
        let pes = pes |> Seq.groupBy (fun p -> p.Date, p.SecurityId)
                      |> Seq.collect (fun (_, ps) ->
                        let psnz = ps |> Seq.filter (fun p -> p.BaseTotalCalc <> 0M) |> Seq.toList
                        let psz = ps |> Seq.filter (fun p -> p.BaseTotalCalc = 0M) |> Seq.toList
                        match psz with
                        | [] -> psnz
                        | psz::pszs -> psz::psnz)
                      |> Seq.sortBy (fun p -> p.Date)
                      |> Seq.toList
        pes |> Seq.map(fun pe -> 
            let se = sds |> Map.tryFind (pe.Date, pe.SecurityId.Value)
            match se with
              Some se ->  
                    let mr = float se.IndexPrice / float se.IndexPriceM1 - 1.0
                    let er = float (se.BaseNotional - pe.BaseTotalCalc) * mr * se.Beta
                    let alpha = pe.BaseTotalCalc - decimal er
                    { Date = pe.Date;
                        TotalPnl = pe.BaseTotalCalc;
                        AlphaPnl = alpha;
                        BetaPnl = decimal er;
                        Notional = se.BaseNotional;
                        IndexPrice = se.IndexPrice;
                        IndexPriceM1 = se.IndexPriceM1;
                        MktRet = mr;
                        MktBeta = se.Beta }
            | None -> { Date = pe.Date;
                        TotalPnl = pe.BaseTotalCalc;
                        AlphaPnl = pe.BaseTotalCalc;
                        BetaPnl = 0M;
                        Notional = 0M;
                        IndexPrice = 0M;
                        IndexPriceM1 = 0M;
                        MktRet = Double.NaN;
                        MktBeta = Double.NaN }) |> Seq.toArray

    let getExposures (sd:DateTime) (ed:DateTime) (detailed: bool) = 
        let action = Action(ActionType = byte ActionType.UIRunExposures, Date = System.DateTime.Now)
        use db = RyeBaySchema.GetDataContext()
        try
            let secs = db |> fetchSecurities |> Seq.toList
            let secMap = secs |> Seq.map(fun s -> s.Id, s) |> Map.ofSeq
            let fes = db |> fetchFundDailyEntries sd ed |> Seq.toList
            let pes = db |> fetchPnlEntries sd ed false |> Seq.toList
            let sds = db |> fetchSecurityDailies sd ed |> Seq.toList
            // do the mapping
            let secIdByTicker = secs |> List.map (fun s -> s.Ticker.ToUpper(), s.Id) |> Map.ofList
            let slinks = db |> fetchSecurityLinks ed |> Seq.toList
            let slinkmap = slinks |> List.choose (fun s ->
                match secIdByTicker |> Map.tryFind s.OldTicker, secIdByTicker |> Map.tryFind s.NewTicker with
                | Some oid, Some nid -> Some (oid, nid)
                | _ -> None) |> Map.ofList
            let slinkoverlap = 
                slinks |> List.choose (fun s ->
                    match secIdByTicker |> Map.tryFind s.NewTicker with
                    | Some nid -> Some (nid, (s.ErrorOnOverlap, s.Date))
                    | _ -> None) |> Map.ofList

            let pes = pes |> List.map (fun p -> 
                if p.SecurityId.HasValue then
                    match slinkmap |> Map.tryFind p.SecurityId.Value with
                    | Some nid -> 
                        new PnlEntry (SecurityId = System.Nullable<int64>(nid), Date = p.Date, Direction = p.Direction, StrategyId = p.StrategyId, BaseTotalCalc = p.BaseTotalCalc, FxType = p.FxType, Name = p.Name, Quantity = p.Quantity)
                    | None -> p
                else p)
            let sds = sds |> List.map (fun s ->
                match slinkmap |> Map.tryFind s.SecurityMasterId with
                | Some nid -> 
                    new SecurityDaily (SecurityMasterId = nid, Date = s.Date, BaseNotional = s.BaseNotional, Beta = s.Beta, CompositeTicker = s.CompositeTicker, Currency = s.Currency, Days3m = s.Days3m, Days5d = s.Days5d, Days6m = s.Days6m, Index = s.Index, IndexPrice = s.IndexPrice, IndexPriceM1 = s.IndexPriceM1, IndexReturnGrossDiv = s.IndexReturnGrossDiv, IndexSectorForBeta = s.IndexSectorForBeta, RelIndex = s.RelIndex, MarketCap = s.MarketCap, Quantity = s.Quantity, RyeBaySector = s.RyeBaySector, SectorBeta = s.SectorBeta, SectorPrice = s.SectorPrice, SectorPriceM3m = s.SectorPriceM3m, Volume3mAvr = s.Volume3mAvr, Volume5dAvr = s.Volume5dAvr, Volume6mAvr = s.Volume6mAvr)
                | None -> s)
            let sds = sds |> Seq.groupBy (fun s -> s.Date, s.SecurityMasterId)
                            |> Seq.map (fun ((d, sid), ss) ->
                                match ss |> Seq.toList with
                                | [s] -> s
                                | s::st ->
                                    let bn = ss |> Seq.sumBy (fun s -> s.BaseNotional)
                                    let ip = (ss |> Seq.find (fun s -> s.IndexPrice <> 0M)).IndexPrice
                                    let ipm1 = (ss |> Seq.find (fun s -> s.IndexPriceM1 <> 0M)).IndexPriceM1
                                    let beta = (ss |> Seq.find (fun s -> s.Beta <> 0.0)).Beta
                                    new SecurityDaily (SecurityMasterId = sid, Date = d, BaseNotional = bn, IndexPrice = ip, IndexPriceM1 = ipm1, Beta = beta))
                
            let pes = pes |> Seq.groupBy (fun p -> p.Date, p.SecurityId)
                            |> Seq.collect (fun ((pd, sid), ps) ->
                                if not sid.HasValue then ps else
                                    match ps |> Seq.toList with
                                    | [p] -> [p] |> List.toSeq
                                    | ps -> 
                                        match slinkoverlap |> Map.tryFind sid.Value with
                                        | Some (true, date) when not (date = pd) && ps |> List.filter(fun p -> p.BaseTotalCalc <> 0M) |> List.length > 1 -> 
                                            let p = ps |> List.head
                                            failwith (sprintf "both securities found and overlap not valid (%s) (%s)" p.Name (p.Date.ToShortDateString()))
                                        | Some _ ->
                                            let p = ps |> List.head
                                            p.BaseTotalCalc <- ps |> List.sumBy (fun p -> p.BaseTotalCalc)
                                            [p] |> List.toSeq
                                        | None -> [ps |> List.head] |> List.toSeq)
                            |> Seq.toList

            let sts = db |> fetchStrategies |> Seq.toList
            let stMap = sts |> Seq.map(fun s -> s.Id, s)
                            |> Map.ofSeq
            let feMap = fes |> Seq.map(fun fe -> fe.Date, fe) |> Map.ofSeq
            let peMap = pes |> Seq.filter(fun p -> p.SecurityId.HasValue && p.StrategyId.HasValue) |> Seq.map(fun p -> (p.Date, p.SecurityId.Value), p) |> Map.ofSeq
            let peMap = sds |> Seq.groupBy(fun sd -> sd.SecurityMasterId)
                            |> Seq.map(fun (sid, sds) -> 
                                let sds = sds |> Seq.map(fun s -> 
                                    s.Date, match peMap |> Map.tryFind (s.Date, sid) with
                                              Some pe -> Some pe
                                            | None -> None)
                                                |> Seq.sortBy fst
                                                |> Seq.scan (fun (ps, _, _) (d, st) -> match st with Some st -> st, d, st | None -> ps, d, ps) (null, DateTime.MinValue, null)
                                                |> Seq.map (fun (_, d, st) -> (d, sid), st)
                                sds)
                            |> Seq.concat
                            |> Map.ofSeq
            let sids = sds |> Seq.map(fun p -> p.SecurityMasterId) |> Seq.distinct |> Seq.toArray
            let ed = (fes |> Seq.maxBy (fun f -> f.Date)).Date
            let cs = db.DataContext.GetChangeSet()
            db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
            sds |> Seq.filter(fun s -> s.Date <= ed && (peMap |> Map.find (s.Date, s.SecurityMasterId)) <> null)
                |> Seq.map(fun s -> let fe = feMap |> Map.find s.Date
                                    let gav = fe.TotalGav
                                    let sec = secMap |> Map.find s.SecurityMasterId
                                    let pe = peMap |> Map.find (s.Date, s.SecurityMasterId)
                                    let st = stMap |> Map.find (pe.StrategyId.Value)
                                    {   Date = s.Date;
                                        Ticker = sec.Ticker;
                                        Id = s.SecurityMasterId;
                                        Name = sec.Name;
                                        Sector = sec.Sector3;
                                        Strategy = st.Name;
                                        Country = sec.Country;
                                        Direction = if pe.Direction = byte Direction.Long then Direction.Long else Direction.Short;
                                        Notional = s.BaseNotional;
                                        Exposure = double (s.BaseNotional / gav);
                                        Beta = s.Beta;
                                        BetaAdj = double (s.BaseNotional / gav) * s.Beta;
                                        MoreFields =
                                            if detailed then
                                                { CompositeTicker = s.CompositeTicker
                                                  IndustrySector = sec.Sector1
                                                  IndustryGroup = sec.Sector2
                                                  GicsIndustryName = sec.Sector5
                                                  GicsIndustryGroup = sec.Sector4
                                                  GicsSubIndustryName = sec.Sector6
                                                  Volume5dAvr = s.Volume5dAvr |> nullableToOption
                                                  Days5d = s.Days5d |> nullableToOption
                                                  Volume3mAvr = s.Volume3mAvr |> nullableToOption
                                                  Days3m = s.Days3m |> nullableToOption
                                                  Volume6mAvr = s.Volume6mAvr |> nullableToOption
                                                  Days6m = s.Days6m |> nullableToOption
                                                  MarketCap = s.MarketCap
                                                  IndexForBeta = s.Index
                                                  IndexBeta = s.Beta
                                                  IndexSectorForBeta = s.IndexSectorForBeta
                                                  SectorBeta = s.SectorBeta
                                                  SectorPrice = s.SectorPrice
                                                  SectorPriceM3m = s.SectorPriceM3m
                                                  RyeBaySector = s.RyeBaySector
                                                  Currency = s.Currency
                                                  AimPrimeBroker = s.AimPrimeBroker
                                                  IndexRtnGrossDiv = s.IndexReturnGrossDiv
                                                  RelIndex = s.RelIndex  } |> Some
                                            else None
                                    })
                |> Seq.toArray
        with
        | AlertException a -> 
            let cs = db.DataContext.GetChangeSet()
            db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
            a |> db.Alert.InsertOnSubmit
            db.DataContext.SubmitChanges()
            [||]
        | _ as e -> 
            let cs = db.DataContext.GetChangeSet()
            db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
            createError "Web UI Error" (e.Message) action |> db.Alert.InsertOnSubmit
            db.DataContext.SubmitChanges()
            [||]

    let getHistory (sd:DateTime) (ed:DateTime) = 
        let action = Action(ActionType = byte ActionType.UIRunHistory, Date = System.DateTime.Now)
        use db = RyeBaySchema.GetDataContext()
        try
            let fes = db |> fetchFundDailyEntries sd ed |> Seq.toList
            let sces = db |> fetchShareClassEntries sd ed |> Seq.toList
            let scs = db |> fetchShareClasses |> Seq.toList
            let pes = db |> fetchPnlEntries sd ed false |> Seq.toList
            let pend = pes |> Seq.map (fun p -> p.Date) |> Seq.max
            let sxxps = 
                let raw = db |> fetchSxxpDailies (sd.AddDays -252.0) pend |> Seq.toList |> List.sortBy (fun (d, _, _) -> d)
                let (d, _, first) = raw |> List.head
                let raw = ((d.AddDays -1.0, first) :: (raw |> List.map (fun (d, p, _) -> d, p))) |> Seq.pairwise |> Seq.toList
                raw |> List.map (fun ((_, t1), (d, t)) -> d, t, t1)
            let sxxpsdr = db |> fetchSxxpDivreinvRtns (sd.AddDays -252.0) pend |> Seq.toList
            let sds = db |> fetchSecurityDailies sd ed |> Seq.toList
            let sts = db |> fetchStrategies |> Seq.toList
            let mainSc = scs |> Seq.filter(fun sc -> sc.IsMain) |> Seq.exactlyOne
            let feMap = fes |> Seq.map(fun fe -> fe.Date, fe) |> Map.ofSeq
            let scMap = sces |> Seq.map(fun sc -> (sc.ShareClassId, sc.Date), sc) |> Map.ofSeq
            let peMap = pes |> Seq.filter(fun p -> p.SecurityId.HasValue) |> Seq.map(fun p -> (p.Date, p.SecurityId.Value), p) |> Map.ofSeq
            let peSt = sds |> Seq.groupBy(fun sd -> sd.SecurityMasterId)
                           |> Seq.map(fun (sid, sds) -> 
                                let sds = sds |> Seq.map(fun s -> 
                                    s.Date, match peMap |> Map.tryFind (s.Date, sid) with
                                              Some pe -> Some pe.StrategyId.Value
                                            | None -> None)
                                              |> Seq.sortBy fst
                                              |> Seq.scan (fun (ps, _, _) (d, st) -> match st with Some st -> st, d, st | None -> ps, d, ps) (0L, DateTime.MinValue, 0L)
                                              |> Seq.map (fun (_, d, st) -> (d, sid), st)
                                sds)
                           |> Seq.concat
                           |> Map.ofSeq
            let stMap = sds |> Seq.groupBy(fun sd -> peSt |> Map.find (sd.Date, sd.SecurityMasterId), sd.Date)
                            |> Map.ofSeq
            let sNav = db |> fetchStartingNav mainSc.Id sd
            let sNav = if sNav = null then mainSc.StartingNav else sNav.Nps
            let dailyNavs = db |> fetchShareClassEntriesForClass mainSc.Id (sd.AddDays -252.0) ed |> Seq.map(fun e -> e.Date, double e.Nps)
            let dailyNavs = if sd = Config.inceptionDate then dailyNavs |> Seq.append ((DateTime.MinValue, double sNav) |> Seq.singleton) else dailyNavs
            let dailyPerfSeq = dailyNavs |> Seq.sortBy(fun (d, _) -> d)
                                            |> Seq.pairwise
                                            |> Seq.map(fun ((_, e1), (d, e2)) -> d, (e2 / e1) - 1.0)
            let dailyPerfs = dailyPerfSeq |> Map.ofSeq
            let sxxpPerfSeq = sxxps |> Seq.map (fun (d, t, t1) -> (d, (double t / double t1) - 1.0))
            let sxxpPerfs = sxxpPerfSeq |> Map.ofSeq
            let sxxpDrPerfSeq = sxxpsdr
            let fundExps = sds |> Seq.groupBy(fun s -> s.Date)
                               |> Seq.map(fun (d, sds) -> d, (sds |> Seq.sumBy (fun s -> abs s.BaseNotional), sds |> Seq.sumBy(fun s -> s.BaseNotional)))                                                                                                                           
                               |> Map.ofSeq
            let fundNots = sds |> Seq.groupBy(fun s -> s.Date)
                               |> Seq.map(fun (d, sds) -> d, (sds |> Seq.sumBy (fun s -> if s.BaseNotional > 0M then s.BaseNotional else 0M),
                                                              sds |> Seq.sumBy (fun s -> if s.BaseNotional < 0M then s.BaseNotional else 0M)))
                               |> Map.ofSeq
            let fundBetas = sds |> Seq.groupBy(fun s -> s.Date)
                                |> Seq.filter(fun (d, _) -> feMap |> Map.containsKey d)
                                |> Seq.map(fun (d, sds) -> let _, net = fundExps |> Map.find d
                                                           let long, short = fundNots |> Map.find d
                                                           d, (sds |> Seq.sumBy(fun s -> s.Beta * (double (s.BaseNotional / net))),
                                                                sds |> Seq.sumBy(fun s -> if s.BaseNotional > 0M then s.Beta * (double (s.BaseNotional / long)) else 0.0),
                                                                sds |> Seq.sumBy(fun s -> if s.BaseNotional < 0M then s.Beta * (double (s.BaseNotional / short)) else 0.0)))
                                |> Map.ofSeq
            let getVols period seq = seq |> series |> Deedle.Stats.movingStdDev period |> Deedle.Series.observations |> Map.ofSeq
//            let getVols period seq = seq |> Seq.windowed (period - 1)
//                                          |> Seq.map (fun perfs -> let mn = perfs |> Seq.averageBy (double << snd)
//                                                                   let fn x = (x - mn) * (x - mn)
//                                                                   let vol = sqrt (perfs |> Seq.averageBy (fn << double << snd))
//                                                                   fst (Array.last perfs), vol)
//                                         |> Map.ofSeq
            let fundVol63s = dailyPerfSeq |> getVols 62
            let indexVol63s = sxxpPerfSeq |> getVols 62
            let fundVol126s = dailyPerfSeq |> getVols 126
            let indexVol126s = sxxpPerfSeq |> getVols 126
            let fundVol252s = dailyPerfSeq |> getVols 252
            let indexVol252s = sxxpPerfSeq |> getVols 252
            let strExps = sts |> Seq.map(fun s -> 
                let sdsl = sds |> List.filter(fun sde -> 
                    let pe = peMap |> Map.find (sde.Date, sde.SecurityMasterId)
                    s.Id = pe.StrategyId.Value && pe.Direction = byte Direction.Long)
                let sdss = sds |> List.filter(fun sde -> 
                    let pe = peMap |> Map.find (sde.Date, sde.SecurityMasterId)
                    s.Id = pe.StrategyId.Value && pe.Direction = byte Direction.Short)
                let getExp sds dir = sdsl |> Seq.groupBy (fun sde -> sde.Date)
                                          |> Seq.map(fun (d, sds) -> d, dir * (sds |> Seq.sumBy (fun s -> s.BaseNotional)))
                                          |> Map.ofSeq
                                          |> Some
                s, (if s.HasLongs then getExp sdsl 1.0M else None), if s.HasShorts then getExp sdss 1.0M else None)
            let dates = fes |> List.map (fun p -> p.Date) |> List.sort
            let excessReturns = dates |> List.choose(fun d -> match dailyPerfs |> Map.tryFind d with
                                                                Some f -> Some (d, f)
                                                              | _ -> None)
            let sharpe63s = excessReturns |> Seq.windowed 62
                                         |> Seq.map (fun ers -> let mn = ers |> Seq.averageBy (snd >> double)
                                                                let fn x = (x - mn) * (x - mn)
                                                                let vol = sqrt (ers |> Seq.averageBy (snd >> double >> fn))
                                                                fst (ers.[ers.Length - 1]), mn / vol)
                                          |> Map.ofSeq
            let scds = scs |> Seq.map(fun s -> { Name = s.Name; HasNav = s.HasNav; HasGav = s.HasGav; Id = s.Id }) |> Seq.sortBy (fun s -> s.Name) |> Seq.toArray
            let stds = sts |> Seq.map(fun s -> { Name = s.Name; HasLongs = s.HasLongs; HasShorts = s.HasShorts; Id = s.Id }) |> Seq.sortBy (fun s -> s.Name) |> Seq.toArray
            let des = dates |> Seq.toArray |> Array.map(fun d -> 
                let fe = feMap |> Map.find d
                let sces = scds |> Array.map (fun sc -> 
                    match scMap |> Map.tryFind (sc.Id, d) with
                      Some sce -> let gav = if sc.HasGav then Some (sce.Gps.Value) else None
                                  let nav = if sc.HasNav then Some (sce.Nps) else None
                                  let aum = Some (sce.TotalAssets)
                                  { Aum = aum; Gav = gav; Nav = nav }
                    | None -> { Aum = None; Gav = None; Nav = None })
                let stes = stds |> Array.map (fun s -> 
                    match stMap |> Map.tryFind (s.Id, d) with
                        Some sds -> 
                            let ln = if s.HasLongs then 
                                     sds |> Seq.sumBy (fun sd -> if sd.BaseNotional > 0M then sd.BaseNotional else 0M) |> Some
                                     else None
                            let lnp = match ln with Some ln -> Some (double (ln / fe.TotalGav)) | None -> None
                            let sn = if s.HasShorts then
                                     sds |> Seq.sumBy (fun sd -> if sd.BaseNotional < 0M then sd.BaseNotional else 0M) |> Some
                                     else None
                            let snp = match sn with Some sn -> Some (double (sn / fe.TotalGav)) | None -> None
                            let lb = match ln with
                                        Some ln -> Some (sds |> Seq.sumBy (fun sd -> if sd.BaseNotional > 0M then double (sd.BaseNotional / ln) * sd.Beta else 0.0))
                                        | None -> None
                            let lba = match lb, lnp with Some(lb), Some(lnp) -> Some(lb * lnp) | _ -> None 
                            let sb = match sn with
                                        Some sn -> Some (sds |> Seq.sumBy (fun sd -> if sd.BaseNotional < 0M then double (sd.BaseNotional / sn) * sd.Beta else 0.0))
                                        | None -> None
                            let sba = match sb, snp with Some(sb), Some(snp) -> Some(sb * snp) | _ -> None
                            { StrategyDaily.LongNotional = ln; LongNotPerc = lnp; ShortNotional = sn; ShortNotPerc = snp;
                                LongBeta = lb; LongBetaAdj = lba; ShortBeta = sb; ShortBetaAdj = sba })
                let perf = match (dailyPerfs |> Map.tryFind d) with Some p -> double p | None -> Double.NaN
                let gross, net = fundExps |> Map.find d
                let long, short = fundNots |> Map.find d
                let beta, lbeta, sbeta = fundBetas |> Map.find d
                let vol63 = fundVol63s |> Map.tryFind d
                let indexVol63 = indexVol63s |> Map.tryFind d
                let vol126 = fundVol126s |> Map.tryFind d
                let indexVol126 = indexVol126s |> Map.tryFind d
                let vol252 = fundVol252s |> Map.tryFind d
                let indexVol252 = indexVol252s |> Map.tryFind d
                let sharpe63 = sharpe63s |> Map.tryFind d
                {   Date = d;
                    Performance = perf;
                    Gav = fe.TotalGav;
                    Nav = fe.TotalNav;
                    Gross = gross;
                    Net = net;
                    GrossPerc = double (gross / fe.TotalGav);
                    NetPerc = double (net / fe.TotalGav);
                    LongNotional = long;
                    LongNotPerc = double (long / fe.TotalGav);
                    ShortNotional = short;
                    ShortNotPerc = double (short / fe.TotalGav);
                    Beta = beta;
                    LongBeta = lbeta;
                    ShortBeta = sbeta;
                    GrossBetaAdj = beta * double (gross / fe.TotalGav);
                    NetBetaAdj = beta * double (net / fe.TotalGav);
                    LongBetaAdj = lbeta * double (long / fe.TotalGav);
                    ShortBetaAdj = sbeta * double (short / fe.TotalGav);
                    Vol63 = vol63;
                    Vol126 = vol126;
                    Vol252 = vol252;
                    IndexVol63 = indexVol63;
                    IndexVol126 = indexVol126;
                    IndexVol252 = indexVol252;
                    ShareClassEntries = sces;
                    StrategyEntries = stes;
                    SharpeRatio = sharpe63;
                    Vol63Ann = match vol63 with Some v -> Some (v * sqrt 62.0) | None -> None;
                    IndexVol63Ann = match indexVol63 with Some v -> Some (v * sqrt 62.0) | None -> None;
                    Vol126Ann = match vol126 with Some v -> Some (v * sqrt 126.0) | None -> None;
                    IndexVol126Ann = match indexVol126 with Some v -> Some (v * sqrt 126.0) | None -> None;
                    Vol252Ann = match vol252 with Some v -> Some (v * sqrt 252.0) | None -> None;
                    IndexVol252Ann = match indexVol252 with Some v -> Some (v * sqrt 252.0) | None -> None;
                    PortfolioVaR = fe.PortVar |> nullableToOption;
                    AifmdGrossLeverage = fe.AifmdGrossLev |> nullableToOption;
                    AifmdCommitmentLeverage = fe.AifmdCommitLev |> nullableToOption;
                })          
            // calculate values over whole period
            let netrtn = db |> fetchNetRtn mainSc.Id sd ed
            let sxxpPerfSeq = sxxpPerfSeq |> Seq.filter(fun (d, _) -> d >= sd && d <= ed) |> Seq.sortBy fst
            let sxxprtn = sxxpPerfSeq |> Seq.map snd |> Seq.cumRet
            let sxxpdrrtn = sxxpDrPerfSeq |> Seq.filter(fun (d, _) -> d >= sd && d <= ed) |> Seq.map snd |> Seq.cumRet
            let fundVol = dailyPerfSeq |> Seq.filter(fun (d, _) -> d >= sd && d <= ed) |> Series.ofObservations |> Deedle.Stats.stdDev
            let sxxpVol = sxxpPerfSeq |> Series.ofObservations |> Deedle.Stats.stdDev
            let excessReturns = excessReturns |> Seq.filter(fun (d, _) -> d >= sd && d <= ed)
            let dailyNavs = dailyNavs |> Seq.filter (fun (d, _) -> d >= sd && d <= ed)
            let meanExcess = excessReturns |> Series.ofObservations |> Deedle.Stats.mean    
            let fundSharpe = meanExcess / (excessReturns |> Series.ofObservations |> Deedle.Stats.stdDev)
            let fundSortino = meanExcess / (excessReturns |> Seq.map (fun (d, r) -> d, if r > 0.0 then 0.0 else r) |> Series.ofObservations |> Deedle.Stats.stdDev)
            let drawDowns = dailyNavs |> Seq.scan (fun (h, l) (d, n) -> match h, l with
                                                                       | Some (_, h), _ when n > h -> Some (d, n), None
                                                                       | Some (_, h) as h', None when n <= h -> h', Some (d, n)
                                                                       | Some (_, h) as h', Some (_, l) when n < l -> h', Some (d, n)
                                                                       | Some h, Some l -> Some h, Some l
                                                                       | None, None -> Some (d, n), Some (d, n)) (None, None)
                                     |> Seq.choose (fun (h, l) -> match h, l with
                                                                  | Some h, Some l -> Some (h, l)
                                                                  | _, _ -> None)
            let ((drawDownStart, ddh), (drawDownEnd, ddl)) = 
                if drawDowns |> Seq.isEmpty then ((None, None), (None, None))
                else let ((s, h), (e, l)) = drawDowns |> Seq.maxBy (fun ((_, h),(_, l)) -> double ((h - l) / h))
                     ((Some s, Some h), (Some e, Some l))
            let drawDown = match ddh, ddl with
                           | Some ddh, Some ddl -> Some (double ((ddh - ddl) / -ddh))
                           | _ -> None
            let grossPerc = des |> Array.averageBy (fun h -> h.GrossPerc)
            let netPerc = des |> Array.averageBy (fun h -> h.NetPerc)
            let longPerc = des |> Array.averageBy (fun h -> h.LongNotPerc)
            let shortPerc = des |> Array.averageBy (fun  h -> h.ShortNotPerc)
            let grossBetaAdj = des |> Array.averageBy (fun h -> h.GrossBetaAdj)
            let netBetaAdj = des |> Array.averageBy (fun h -> h.NetBetaAdj)
            let longBetaAdj = des |> Array.averageBy (fun h -> h.LongBetaAdj)
            let shortBetaAdj = des |> Array.averageBy (fun h -> h.ShortBetaAdj)
            Some ({ ShareClasses = scds; 
                    Strategies = stds; 
                    Entries = des; 
                    NetReturn = netrtn.Value;
                    IndexReturn = sxxprtn;
                    IndexRtnDivReinv = sxxpdrrtn;
                    FundVol = fundVol * sqrt 252.0;
                    IndexVol = sxxpVol * sqrt 252.0;
                    FundSharpe = fundSharpe * sqrt 252.0;
                    GrossPerc = grossPerc;
                    NetPerc = netPerc;
                    LongPerc = longPerc;
                    ShortPerc = shortPerc;
                    FundSortino = fundSortino * sqrt 252.0;
                    Drawdown = drawDown;
                    DrawdownStart = drawDownStart;
                    DrawdownEnd = drawDownEnd;
                    GrossBetaAdj = grossBetaAdj;
                    NetBetaAdj = netBetaAdj;
                    LongBetaAdj = longBetaAdj;
                    ShortBetaAdj = shortBetaAdj })
        with
            | AlertException a -> a |> db.Alert.InsertOnSubmit
                                  db.DataContext.SubmitChanges()
                                  None
            | _ as e -> createError "Web UI Error" (e.Message) action |> db.Alert.InsertOnSubmit
                        db.DataContext.SubmitChanges()
                        None

    let getPurchaseSales (sd:DateTime) (ed:DateTime) =
        let action = Action(ActionType = byte ActionType.UIRunPurchaseSales, Date = System.DateTime.Now)
        use db = RyeBaySchema.GetDataContext()
        try
            let ps = db |> fetchPurchaseSales sd ed |> Seq.toArray
            ps
        with
            | AlertException a -> a |> db.Alert.InsertOnSubmit
                                  db.DataContext.SubmitChanges()
                                  [||]
            | _ as e -> createError "Web UI Error" (e.Message) action |> db.Alert.InsertOnSubmit
                        db.DataContext.SubmitChanges()
                        [||]
                                        
    let getPerfAttr (sd:DateTime) (ed:DateTime) (redistFx :bool) (irt :IndexReturnType) = 
        let action = Action(ActionType = byte ActionType.UIRunAttribution, Date = System.DateTime.Now)
        let findOrErr = findOrErr "UI Performance Attribution Error" action
        use db = RyeBaySchema.GetDataContext()
        try
            let pes = db |> getPnlEntries sd ed |> Seq.filter(fun p -> 
                not p.FxType.HasValue || (p.FxType.Value <> byte FxType.Portfolio && p.FxType.Value <> byte FxType.ShareClass)) 
                    |> Seq.filter (fun p -> (p.SecurityId.HasValue && p.StrategyId.HasValue) || (not p.SecurityId.HasValue)) |> Seq.toList
            if pes |> List.isEmpty then // no data
                [||], Unchecked.defaultof<System.DateTime>, Unchecked.defaultof<System.DateTime>, 0, None
            else
                let sd = (pes |> List.minBy (fun p -> p.Date)).Date
                let ed = (pes |> List.maxBy (fun p -> p.Date)).Date
                
                let secs = db |> fetchSecurities |> Seq.map (fun sec -> sec.Id, sec) |> Map.ofSeq
                let sds = db |> fetchSecurityDailies sd ed |> Seq.toList

                // latest strategies
                let strategies = db |> fetchStrategies |> Seq.map(fun s -> s.Id, s) |> Map.ofSeq
                let secSt = pes |> Seq.filter (fun p -> p.SecurityId.HasValue) 
                                |> Seq.groupBy (fun p -> p.SecurityId.Value)
                                |> Seq.map(fun (sid, ps) -> sid, (ps |> Seq.maxBy (fun p -> p.Date)).StrategyId.Value)
                                |> Map.ofSeq

                // do the mapping
                let secIdByTicker = secs |> Map.toList |> List.map (fun (_, s) -> s.Ticker.ToUpper(), s.Id) |> Map.ofList
                let slinks = db |> fetchSecurityLinks ed |> Seq.toList
                let slinkmap = slinks |> List.choose (fun s ->
                    match secIdByTicker |> Map.tryFind s.OldTicker, secIdByTicker |> Map.tryFind s.NewTicker with
                    | Some oid, Some nid -> Some (oid, nid)
                    | _ -> None) |> Map.ofList
                let secSt = slinkmap |> Map.toList |> List.fold (fun ss (oid, nid) -> 
                    match ss |> Map.tryFind oid with
                    | Some osid -> ss |> Map.add nid osid
                    | None -> ss) secSt
                let slinkoverlap = 
                    slinks |> List.choose (fun s ->
                        match secIdByTicker |> Map.tryFind s.NewTicker with
                        | Some nid -> Some (nid, (s.ErrorOnOverlap, s.Date))
                        | _ -> None) |> Map.ofList

                let pes = pes |> List.map (fun p -> 
                    if p.SecurityId.HasValue then
                        match slinkmap |> Map.tryFind p.SecurityId.Value with
                        | Some nid -> 
                            new PnlEntry (SecurityId = System.Nullable<int64>(nid), Date = p.Date, Direction = p.Direction, StrategyId = p.StrategyId, BaseTotalCalc = p.BaseTotalCalc, FxType = p.FxType, Name = p.Name, Quantity = p.Quantity)
                        | None -> p
                    else p)
                let sds = sds |> List.map (fun s ->
                    match slinkmap |> Map.tryFind s.SecurityMasterId with
                    | Some nid -> 
                        new SecurityDaily (SecurityMasterId = nid, Date = s.Date, BaseNotional = s.BaseNotional, Beta = s.Beta, CompositeTicker = s.CompositeTicker, Currency = s.Currency, Days3m = s.Days3m, Days5d = s.Days5d, Days6m = s.Days6m, Index = s.Index, IndexPrice = s.IndexPrice, IndexPriceM1 = s.IndexPriceM1, IndexReturnGrossDiv = s.IndexReturnGrossDiv, IndexSectorForBeta = s.IndexSectorForBeta, RelIndex = s.RelIndex, MarketCap = s.MarketCap, Quantity = s.Quantity, RyeBaySector = s.RyeBaySector, SectorBeta = s.SectorBeta, SectorPrice = s.SectorPrice, SectorPriceM3m = s.SectorPriceM3m, Volume3mAvr = s.Volume3mAvr, Volume5dAvr = s.Volume5dAvr, Volume6mAvr = s.Volume6mAvr)
                    | None -> s)
                let sds = sds |> Seq.groupBy (fun s -> s.Date, s.SecurityMasterId)
                              |> Seq.map (fun ((d, sid), ss) ->
                                    match ss |> Seq.toList with
                                    | [s] -> s
                                    | s::st ->
                                        let bn = ss |> Seq.sumBy (fun s -> s.BaseNotional)
                                        let ip = (ss |> Seq.find (fun s -> s.IndexPrice <> 0M)).IndexPrice
                                        let ipm1 = (ss |> Seq.find (fun s -> s.IndexPriceM1 <> 0M)).IndexPriceM1
                                        let s = ss |> Seq.find (fun s -> s.Beta <> 0.0)
                                        let beta = s.Beta
                                        new SecurityDaily (SecurityMasterId = sid, Date = d, BaseNotional = bn, IndexPrice = ip, IndexPriceM1 = ipm1, Beta = beta, CompositeTicker = s.CompositeTicker, Currency = s.Currency, Days3m = s.Days3m, Days5d = s.Days5d, Days6m = s.Days6m, Index = s.Index, IndexReturnGrossDiv = s.IndexReturnGrossDiv, IndexSectorForBeta = s.IndexSectorForBeta, RelIndex = s.RelIndex, MarketCap = s.MarketCap, Quantity = s.Quantity, RyeBaySector = s.RyeBaySector, SectorBeta = s.SectorBeta, SectorPrice = s.SectorPrice, SectorPriceM3m = s.SectorPriceM3m, Volume3mAvr = s.Volume3mAvr, Volume5dAvr = s.Volume5dAvr, Volume6mAvr = s.Volume6mAvr))
                
                let pes = pes |> Seq.groupBy (fun p -> p.Date, p.SecurityId)
                              |> Seq.collect (fun ((pd, sid), ps) ->
                                    if not sid.HasValue then ps else
                                        match ps |> Seq.toList with
                                        | [p] -> [p] |> List.toSeq
                                        | ps -> 
                                            match slinkoverlap |> Map.tryFind sid.Value with
                                            | Some (true, date) when not (date = pd) && ps |> List.filter(fun p -> p.BaseTotalCalc <> 0M) |> List.length > 1 -> 
                                                let p = ps |> List.head
                                                failwith (sprintf "both securities found and overlap not valid (%s) (%s)" p.Name (p.Date.ToShortDateString()))
                                            | Some _ ->
                                                let p = ps |> List.head
                                                p.BaseTotalCalc <- ps |> List.sumBy (fun p -> p.BaseTotalCalc)
                                                [p] |> List.toSeq
                                            | None -> [ps |> List.head] |> List.toSeq)
                              |> Seq.toList

                // market betas and market returns
                let brs = sds   |> Seq.groupBy(fun s -> s.SecurityMasterId)
                                |> Seq.map(fun (sid, ss) -> sid, ss |> Seq.map(fun se -> 
                                    let mktRet = match irt with
                                                   IndexReturnType.Normal -> float se.IndexPrice / float se.IndexPriceM1 - 1.0
                                                 | IndexReturnType.DivReinvested -> se.IndexReturnGrossDiv
                                    se.Date, mktRet, se.Beta, se.BaseNotional))
                // total market returns when capital was employed
//                let bns = sds |> Seq.map (fun s -> (s.SecurityMasterId, s.Date), s.BaseNotional) |> Map.ofSeq
//                let bns = 
//                    pes |> Seq.filter (fun p -> p.SecurityId.HasValue)
//                        |> Seq.sortBy (fun p -> p.Date)
//                        |> Seq.groupBy (fun p -> p.SecurityId.Value)
//                        |> Seq.collect (fun (sid, pes) -> 
//                            pes |> Seq.sortBy (fun p -> p.Date) |> Seq.scan (fun (d, n, pnl) p ->
//                                match bns |> Map.tryFind (p.SecurityId.Value, p.Date) with
//                                | Some bn when (abs bn) <> 0M -> (p.Date, (abs bn) - p.BaseTotal, p.BaseTotal)
//                                | _ when n <> 0M -> (p.Date, n + pnl, p.BaseTotal)
//                                | _ -> (p.Date, 0M, 0M)) (DateTime.MinValue, 0M, 0M)
//                                |> Seq.map (fun (d, n, _) -> (sid, d), n))
//                        |> Map.ofSeq
                let mkts = brs |> Seq.map(fun (sid, ss) -> sid, ss |> Seq.filter (fth4 >> notEqual 0M) |> Seq.sortBy fst4 |> Seq.cumRetBy snd4) |> Map.ofSeq
                let brs = brs  |> Seq.map(fun (sid, ss) -> ss |> Seq.map(fun (d, r, b, s) -> (sid, d), (r, b, s))) |> Seq.concat |> Map.ofSeq
                // average capital employed
                let avc = sds |> Seq.groupBy(fun s -> s.SecurityMasterId)
                              |> Seq.map(fun (sid, ss) -> 
                                    sid, 
                                        let notZero = ss |> Seq.filter(fun se -> se.BaseNotional <> 0M) 
                                        if notZero |> Seq.isEmpty then 0M else notZero |> Seq.averageBy(fun se -> se.BaseNotional))
                              |> Map.ofSeq
                // average market caps
                let mktcaps = sds |> Seq.groupBy(fun s -> s.SecurityMasterId)
                                  |> Seq.map(fun (sid, ss) -> sid, ss |> Seq.averageBy(fun se -> se.MarketCap))
                                  |> Map.ofSeq
                let liqdays = sds |> Seq.groupBy(fun s -> s.SecurityMasterId)
                                  |> Seq.map(fun (sid, ss) -> 
                                        let vol (se:SecurityDaily) = 
                                            match se.Volume3mAvr.HasValue, se.Volume5dAvr.HasValue with
                                              true, _ -> float se.Volume3mAvr.Value
                                            | false, true -> float se.Volume5dAvr.Value
                                            | _ -> Double.NaN
                                        let ssv = ss |> Seq.filter(vol >> Double.IsNaN >> not)
                                        sid, if (ssv |> Seq.isEmpty) then Double.NaN else ssv |> Seq.averageBy (fun se -> let vol = vol se in float ((abs (float se.Quantity)) / (0.25 * vol))))
                                  |> Map.ofSeq
                // fund entries - opening assets
                let fentries = db |> fetchFundEntries sd ed |> Seq.toArray
                let fes = 
                    fentries 
                       |> Seq.groupBy(fun fe -> getMonth fe.Date)
                       |> Seq.map (fun (m, fes) -> m, fes |> Seq.last)
                       |> Map.ofSeq
                // opening assets by date
                let oas = fentries |> Seq.map(fun f -> f.Date, f.OpeningAssets) |> Map.ofSeq
                let numDays = pes |> Seq.distinctBy (fun p -> p.Date) |> Seq.length
                let sids = pes |> Seq.filter (fun pe -> pe.SecurityId.HasValue) |> Seq.map (fun pe -> pe.SecurityId.Value) |> Seq.distinct |> Array.ofSeq
                // daily pnls
                let des = pes |> Seq.groupBy(fun pe -> pe.Date)
                              |> Seq.map(fun (d, pes) -> d, pes |> Seq.sumBy (fun p -> p.BaseTotalCalc))
//                let cretBySec = 
//                    pes |> Seq.filter(fun pe -> pe.SecurityId.HasValue)
//                        |> Seq.groupBy (fun pe -> pe.SecurityId.Value)
//                        |> Seq.map (fun (sid, pes) ->
//                            let crs = 
//                                pes |> Seq.sortBy (fun p -> p.Date)
//                                    |> Seq.map (fun p -> 
//                                    let baseNotional = bns |> Map.find (sid, p.Date)
//                                    match baseNotional with
//                                    | 0M -> 0.0
//                                    | bn ->
//                                        (p.BaseTotal / abs bn) |> double)
//                                    |> Seq.cumRet
//                            sid, crs)
//                        |> Map.ofSeq
//                let dailyReturns =
//                    des |> Seq.sortBy fst
//                        |> Seq.cumTotSeriesBy snd
//                        |> Seq.map (fun ((d, _), t) -> d, t + fentries.[0].OpeningAssets)
//                        |> Seq.pairwise
//                        |> Seq.map (fun ((_, a1), (d, a2)) -> d, double a2 / double a1 - 1.0) |> Seq.toArray
                // daily assets
                let das = des |> Seq.groupBy(fun (d, _) -> getMonth d)
                              |> Seq.map(fun (m, des) -> 
                                    des |> Seq.sortBy fst
                                        |> Seq.cumTotSeriesBy snd
                                        |> Seq.map(fun ((d, _), t) -> 
                                            match oas |> Map.tryFind d with
                                            | Some a -> d, a
                                            | None ->
                                                let oa = match (fes |> Map.tryFind (prevMonth m)) with
                                                            Some oa -> oa.OpeningAssets
                                                          | _ -> raise (AlertException(createError "Fund Entry Not Found" (sprintf "Fund Entry not found. Need opening assets for %s" (d.ToShortDateString())) action))
                                                d, oa + t))
                              |> Seq.concat
                              |> Map.ofSeq
                // daily returns
                let dailyReturns =
                    des |> Seq.groupBy (fun (d, _) -> getMonth d)
                        |> Seq.collect (fun (m, des) ->
                            let oa = 
                                match (fes |> Map.tryFind (prevMonth m)) with
                                | Some oa -> oa.OpeningAssets
                                | _ -> raise (AlertException(createError "Fund Entry Not Found" (sprintf "Fund Entry not found. Need opening assets") action))
                            des |> Seq.scan (fun (_, t, _) (d, dt) ->
                                let r = dt / (t + oa)
                                d, dt + t, r) (DateTime.MinValue, 0M, 0M)
                                |> Seq.map (fun (d, _, r) -> d, double r))
                        |> Seq.toArray
                
                // daily returns
                //let dailyReturns = das |> Map.toSeq |> Seq.sortBy fst |> Seq.pairwise |> Seq.map (fun ((_, a1), (d, a2)) -> d, double a2 / double a1 - 1.0) |> Seq.toArray
                // sxxp returns
                let rtnDates = dailyReturns |> Seq.map fst |> Set.ofSeq
                let sxxps = 
                    let raw = db |> fetchSxxpDailies (sd.AddDays -252.0) ed |> Seq.toList |> List.sortBy (fun (d, _, _) -> d)
                    let (d, _, first) = raw |> List.head
                    let raw = ((d.AddDays -1.0, first) :: (raw |> List.map (fun (d, p, _) -> d, p))) |> Seq.pairwise |> Seq.toList
                    raw |> List.map (fun ((_, t1), (d, t)) -> d, t, t1)
                let sxxps = sxxps |> Seq.filter (fun (d, _, _) -> rtnDates |> Set.contains d)
                let sxxpReturns = sxxps |> Seq.map (fun (d, t, t1) -> d, double t / double t1 - 1.0) |> Seq.toArray
                let sxxpDates = sxxpReturns |> Seq.map fst |> Set.ofSeq
                // average weightings
                let avw = sds |> Seq.groupBy(fun s -> s.SecurityMasterId)
                              |> Seq.map(fun (sid, ss) -> 
                                sid, 
                                    let notZero = ss |> Seq.filter(fun se -> se.BaseNotional <> 0M)
                                    if notZero |> Seq.isEmpty then Double.NaN else notZero |> Seq.averageBy(fun se -> se.BaseNotional / Map.find se.Date das |> float))
                              |> Map.ofSeq
                // days held
                let dh = sds |> Seq.groupBy(fun s -> s.SecurityMasterId)
                             |> Seq.map(fun (sid, ss) -> sid, ss |> Seq.filter(fun se -> se.BaseNotional <> 0M) |> Seq.length)
                             |> Map.ofSeq
                // fx etc
                let ipes = pes |> Seq.filter (fun p -> p.FxType.HasValue && p.FxType.Value = byte FxType.Income)
                let pes = if redistFx then pes |> List.filter (fun p -> not p.FxType.HasValue || p.FxType.Value <> byte FxType.Income) else pes // filter out fx income if redist
                let pes = if redistFx 
                          then let fx = db |> fetchFxIncomeEntries sd ed |> Seq.toList
                               fx |> List.iter (fun f ->
                                    match slinkmap |> Map.tryFind f.SecurityId with
                                    | Some nid ->
                                        f.SecurityId <- nid
                                    | None -> ())
                               let fx = fx |> Seq.groupBy(fun f -> f.FxPair)
                                           |> Seq.map (fun (k, f) -> 
                                                let ts = C5.TreeDictionary()
                                                f |> Seq.groupBy(fun f -> f.Date) |> Seq.map(fun (k, f) -> C5.KeyValuePair(k, f)) |> ts.AddAll
                                                k, ts)
                                           |> Map.ofSeq
                               let pfxinc = ipes |> Seq.map(fun p -> 
                                    let cp = getCurrencyPair p.Name
                                    match (fx |> Map.tryFind cp) with
                                      Some ts -> 
                                        let wp = (ts.WeakPredecessor p.Date).Value
                                        wp |> Seq.filter (fun f -> f.Attribution <> 0.0)
                                           |> Seq.map(fun f -> 
                                                let sec = secs |> Map.find f.SecurityId
                                                PnlEntry(FxType = Nullable(byte FxType.Income),
                                                         Direction = p.Direction,
                                                         Date = p.Date,
                                                         Name = f.FxPair + ": Fx Income",
                                                         SecurityId = System.Nullable<int64>(f.SecurityId), 
                                                         BaseTotal = decimal (f.Attribution * float p.BaseTotalCalc)))                                                                     
                                    | None -> Seq.empty)
                                                |> Seq.concat
                                                |> Seq.toList
                               let fxTotals = pfxinc |> Seq.groupBy (fun s -> s.Name)
                                                     |> Seq.map (fun (k, s) -> k, s |> Seq.sumBy(fun s1 -> s1.BaseTotalCalc))
                                                     |> Map.ofSeq
                               List.append pes pfxinc
                          else pes
                let pesg = pes |> Seq.groupBy(fun pe -> 
                                    if pe.SecurityId.HasValue
                                    then if pe.FxType.HasValue then PFxIncome (pe.SecurityId.Value, pe.Name, enum (int pe.Direction), 14L)
                                         else PSecurity (pe.SecurityId.Value, enum (int pe.Direction), secSt |> Map.find (pe.SecurityId.Value))
                                    else PFx (enum (int pe.FxType.Value), pe.Name, enum (int pe.Direction)))
                               |> Seq.map(fun (pid, pes) -> 
                                    pid, pes |> Seq.groupBy(fun fe -> getMonth fe.Date)
                                             |> Seq.map(fun (m, pes) -> 
                                                    let monthTotal = pes |> Seq.sumBy (fun pe -> pe.BaseTotalCalc)
                                                    let monthAlpha = match pid with 
                                                                       PSecurity (id, _, _) -> 
                                                                            pes |> Seq.sumBy (fun pe -> 
                                                                                    if pe.BaseTotalCalc = 0M then 0M
                                                                                    else if brs |> Map.containsKey (pe.SecurityId.Value, pe.Date) then
                                                                                            let mr, mb, size = brs |> Map.find (pe.SecurityId.Value, pe.Date)
                                                                                            let er = float (size - pe.BaseTotalCalc) * mr * mb
                                                                                            pe.BaseTotalCalc - decimal er
                                                                                         else 0M)
                                                                     | _ -> 0M
                                                    m, monthTotal, monthAlpha))
                let per = pesg |> Seq.map(fun (pid, pnls) -> pid, pnls |> Seq.map(fun (m, pnl, apnl) -> let oa = match fes |> Map.tryFind (prevMonth m) with
                                                                                                                    Some fe -> fe.OpeningAssets
                                                                                                                  | _ -> let date = DateTime.Now
                                                                                                                         raise (AlertException(createError "Fund Entry Not Found" (sprintf "Fund Entry not found. Need opening assets for %s" (date.ToShortDateString())) action))
                                                                                                        m, pnl, double pnl / double oa, double apnl / double oa))
                let mr = per |> Seq.map snd |> Seq.concat |> Seq.groupBy (fun (m, _, _, _) -> m) |> Seq.map (fun (m, p) -> m, p |> Seq.sumBy (fun (_, p, _, _) -> p))
                                |> Seq.map (fun (m, p) -> let oa = fes |> Map.find (prevMonth m)
                                                          m, p, double p / double oa.OpeningAssets)
                let totalReturn = (mr |> Seq.sortBy (fun (m, _, _) -> m) |> Seq.fold (fun a (m, _, r) -> a * (1.0 + r)) 1.0) - 1.0
                let totalSxxpReturn = sxxpReturns |> Seq.sortBy fst |> Seq.fold (fun a (_, r) -> a * (1.0 + r)) 1.0
                let k = (log (1.0 + totalReturn)) / totalReturn
                let kts = mr |> Seq.map(fun (m, _, r) -> m, (log (1.0 + r)) / r) |> Map.ofSeq
                let fundVol = (dailyReturns |> Series.ofObservations |> Deedle.Stats.stdDev) * sqrt 252.0
                let sxxpVol = (sxxpReturns |> Series.ofObservations |> Deedle.Stats.stdDev) * sqrt 252.0
                let meanRtn = (((totalReturn + 1.0) ** (1.0 / double numDays)) - 1.0) * 252.0
                let meanSxxpRtn = ((totalSxxpReturn ** (1.0 / double numDays)) - 1.0) * 252.0
                let dailyReturns = dailyReturns |> Seq.filter (fun (d, _) -> sxxpDates |> Set.contains d)
                let indexCor = MathNet.Numerics.Statistics.Correlation.Pearson(dailyReturns |> Seq.map snd, sxxpReturns |> Seq.map snd)
                let fundSharpe = meanRtn / fundVol
                let sxxpSharpe = meanSxxpRtn / sxxpVol
                let cs = db.DataContext.GetChangeSet()
                db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
                per |> Seq.map (fun (pid, pes) -> 
                        let name, dir, st, id, ptid = 
                            match pid with
                               PSecurity (id, dir, st) -> 
                                  let s = (secs |> Map.find id)
                                  (if String.IsNullOrEmpty(s.Name) then "" else s.Name.ToLower()), dir, (strategies |> Map.find st).Name, Some (s.Id), if s.ParentId.HasValue then Some s.ParentId.Value else None
                             | PFx (fx, name, dir) -> name, dir, "FX (" + fx.ToString() + ")", None, None
                             | PFxIncome (id, name, dir, st) -> 
                                let s = (secs |> Map.find id)
                                name, dir, "", None, Some id
                        let ticker, sector, country = 
                            match pid with
                               PSecurity (id, _, _) -> let s = (secs |> Map.find id) in s.Ticker, s.Sector3, s.Country
                             | _ -> String.Empty, String.Empty, String.Empty
                        let tb = pes |> Seq.sumBy (fun (_, t, _, _) -> t)
                        let at = pes |> Seq.sumBy (fun (m, _, r, _) -> r * ((kts |> Map.find m) / k))
                        let ata = pes |> Seq.sumBy (fun (m, _, _, r) -> r * ((kts |> Map.find m) / k))
//                        let roce = match id with
//                                     Some id when dir = Direction.Long && avc |> Map.containsKey id && (avc |> Map.find id) <> 0M -> tb / (avc |> Map.find id)
//                                   | Some id when dir = Direction.Short && avc |> Map.containsKey id && (avc |> Map.find id) <> 0M -> -tb / (avc |> Map.find id)
//                                   | _ -> 0M 
//                        let roce = 
//                            match id with
//                            | Some id when cretBySec |> Map.containsKey id ->
//                                cretBySec |> Map.find id
//                            | _ -> Double.NaN
                        let mktret = match id with
                                       Some id when mkts |> Map.containsKey id -> mkts |> Map.find id
                                     | _ -> Double.NaN
                        let w = match id with
                                  Some id when avw |> Map.containsKey id -> avw |> Map.find id
                                | _ -> Double.NaN
                        let dh = match id with
                                  Some id when dh |> Map.containsKey id -> dh |> Map.find id
                                | _ -> 0
                        let mktcap = match id with
                                       Some id when mktcaps |> Map.containsKey id -> mktcaps |> Map.find id
                                     | _ -> 0M     
                        let liqdays = match id with
                                       Some id when liqdays |> Map.containsKey id -> liqdays |> Map.find id
                                     | _ -> Double.NaN         
                        let roce = at / (abs w)                       
                        { Ticker = ticker; 
                        Name = name; 
                        Direction = dir; 
                        Sector = sector; 
                        Country = country; 
                        TotalBase = tb; 
                        Attribution = at; 
                        Strategy = st; 
                        Id = id; 
                        ParentId = ptid;
                        Weight = w;
                        Roce = float roce;
                        Alpha = ata;
                        MktRet = mktret;
                        DaysHeld = dh;
                        MktCap = mktcap;
                        LiqDays = liqdays })
                    |> Seq.toArray, sd, ed, numDays, Some({ PerfAttrStats.FundVol = fundVol; FundSharpe = fundSharpe; IndexVol = sxxpVol; IndexSharpe = sxxpSharpe; IndexCorrelation = indexCor })
        with
            | AlertException a -> let cs = db.DataContext.GetChangeSet()
                                  db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
                                  a |> db.Alert.InsertOnSubmit
                                  db.DataContext.SubmitChanges()
                                  [||], Unchecked.defaultof<System.DateTime>, Unchecked.defaultof<System.DateTime>, 0, None
            | _ as e -> let cs = db.DataContext.GetChangeSet()
                        db.DataContext.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates)
                        createError "Web UI Error" (e.Message) action |> db.Alert.InsertOnSubmit
                        db.DataContext.SubmitChanges()
                        [||], Unchecked.defaultof<System.DateTime>, Unchecked.defaultof<System.DateTime>, 0, None

    let fxIncomeFileAdded (fileName: string)
                          (date: System.DateTime)
                          (back: bool)
                                             = use pkg = new OfficeOpenXml.ExcelPackage(System.IO.FileInfo(fileName))
                                               use db = RyeBaySchema.GetDataContext()
                                               let ws = pkg.Workbook.Worksheets.First()
                                               let pairs = seq { 5..(ws.Cells.Columns) } |> Seq.map(fun c -> c, ws.GetValue<string>(1, c)) |> Seq.filter (fun (_, s) -> not (String.IsNullOrEmpty(s)) && not (s = "Grand Total")) |> Seq.toList
                                               let action = Action(Date = System.DateTime.Now, ActionType = byte ActionType.FxAttributionUpload)
                                               action |> db.Action.InsertOnSubmit
                                               try
                                                 let old = db |> fetchFxIncomeForDate date
                                                 let ldate = db |> latestFxIncomeDate 
                                                 //if ldate >= date && not back then
                                                    //createError "Fx Income File Error" "Cannot upload for a date on or before a previous upload." action |> AlertException |> raise
                                                 let tickers = seq { 2..(ws.Cells.Rows) } |> Seq.map (fun r -> ws.GetValue<string>(r, 3)) |> Seq.filter (fun s -> not (String.IsNullOrEmpty(s)) && s.Contains("Equity")) |> Seq.map (fun s -> s.ToUpper()) |> Seq.distinct |> Seq.toArray
                                                 let secs = db |> fetchSecuritiesByTickers tickers |> Seq.map (fun s -> s.Ticker, s) |> Map.ofSeq
                                                 seq { 2..(ws.Cells.Rows) } 
                                                           |> Seq.filter (fun r -> not (String.IsNullOrEmpty(ws.GetValue<string>(r, 3))) && ws.GetValue<string>(r, 3).Contains("Equity"))
                                                           |> Seq.iter (fun r -> let sec = let id = ws.GetValue<string>(r, 3).ToUpper()
                                                                                           if secs |> Map.containsKey id
                                                                                           then
                                                                                            secs |> Map.find id
                                                                                           else let s = SecurityMaster(Ticker = id)
                                                                                                s |> db.SecurityMaster.InsertOnSubmit
                                                                                                s
                                                                                 let fies = pairs |> Seq.map(fun (i, p) -> FxIncomeEntry(SecurityMaster = sec, Date = date, FxPair = p, Attribution = ws.GetValue<float>(r, i)))
                                                                                 fies |> db.FxIncomeEntry.InsertAllOnSubmit)
                                                 createInfo "Fx Income File Uploaded" "Success" action |> db.Alert.InsertOnSubmit
                                                 old |> db.FxIncomeEntry.DeleteAllOnSubmit
                                                 db.DataContext.SubmitChanges()
                                                 true
                                               with
                                                 | AlertException a -> a |> db.Alert.InsertOnSubmit 
                                                                       db.DataContext.SubmitChanges()
                                                                       false
                                                 | _ as e -> createError "Fx Income File Error" (e.Message) action |> db.Alert.InsertOnSubmit
                                                             db.DataContext.SubmitChanges()
                                                             false

    let nsFileAdded (fileName: string) = use pkg = new OfficeOpenXml.ExcelPackage(System.IO.FileInfo(fileName))
                                         use db = RyeBaySchema.GetDataContext()
                                         let ws = pkg.Workbook.Worksheets.[NavSheetFlds.sheetName]
                                         let wsc = pkg.Workbook.Worksheets.[ClassSheetFlds.sheetName]
                                         let cols = seq { 1..(ws.Cells.Columns) } |> Seq.map(fun c -> ws.GetValue<string>(2, c), c) |> Seq.filter(fun (s, _) -> not (String.IsNullOrEmpty(s))) |> Map.ofSeq
                                         let colsc = seq { 1..(wsc.Cells.Columns) } |> Seq.map(fun c -> wsc.GetValue<string>(1, c), c) |> Seq.filter(fun (s, _) -> not (String.IsNullOrEmpty(s))) |> Map.ofSeq
                                         let action = Action(Date = System.DateTime.Now, ActionType = byte ActionType.NavSheetUpload)
                                         let classes = seq { 2 .. (wsc.Cells.Rows) }
                                                            |> Seq.filter (fun r -> not <| String.IsNullOrEmpty(wsc.GetValue<string>(r, colsc |> Map.find ClassSheetFlds.aum)))
                                                            |> Seq.map(fun r -> let aum = wsc.GetValue<string>(r, colsc |> Map.find ClassSheetFlds.aum)
                                                                                let nps = wsc.GetValue<string>(r, colsc |> Map.find ClassSheetFlds.nps)
                                                                                let gps = wsc.GetValue<string>(r, colsc |> Map.find ClassSheetFlds.gps)
                                                                                aum, nps, gps)
                                         try
                                            let cles = classes |> Seq.map (fun (c, n, g) -> let sc = db |> fetchShareClass c
                                                                                            if sc = null then
                                                                                                let sc = ShareClass(Name = c, HasGav = (not <| String.IsNullOrEmpty(g)), HasNav = (not <| String.IsNullOrEmpty(n)))
                                                                                                db.ShareClass.InsertOnSubmit sc
                                                                                                c, sc
                                                                                            else c, sc) |> Map.ofSeq
                                            seq { 3..(ws.Cells.Rows) }
                                                |> Seq.filter (fun r -> not <| String.IsNullOrEmpty(ws.GetValue<string>(r, cols |> Map.find NavSheetFlds.totalGav)))
                                                |> Seq.iter (fun r ->
                                                    let getNullable col =
                                                        let str = ws.GetValue<string>(r, cols |> Map.find col)
                                                        match Double.TryParse(str) with
                                                            (true, v) -> System.Nullable<double>(v)
                                                            | _ -> System.Nullable()
                                                    let date = ws.GetValue<System.DateTime>(r, cols |> Map.find NavSheetFlds.date)
                                                    let tgav = ws.GetValue<decimal>(r, cols |> Map.find NavSheetFlds.totalGav)
                                                    let tnav = ws.GetValue<decimal>(r, cols |> Map.find NavSheetFlds.totalNav)
                                                    let fde = db |> fetchFundDailyEntry date
                                                    let fde = if fde = null then let f = FundDailyEntry(Date = date) 
                                                                                 f |> db.FundDailyEntry.InsertOnSubmit
                                                                                 f
                                                                            else fde
                                                    let pvar = getNullable NavSheetFlds.portVar
                                                    let glvr = getNullable NavSheetFlds.aifmdGssLvr
                                                    let clvr = getNullable NavSheetFlds.aifmdCmtLvr
                                                    fde.TotalGav <- tgav
                                                    fde.TotalNav <- tnav
                                                    fde.PortVar <- pvar
                                                    fde.AifmdGrossLev <- glvr
                                                    fde.AifmdCommitLev <- clvr
                                                    classes |> Seq.filter(fun (aum, _, _) -> not <| String.IsNullOrEmpty(ws.GetValue<string>(r, cols |> Map.find aum)))
                                                        |> Seq.iter (fun (aum, nps, gps) ->
                                                            let sc = cles |> Map.find aum
                                                            let se = if sc.Id = 0L then null else db |> fetchShareClassEntry sc.Id date
                                                            let se = if se = null then let s = ShareClassEntry(Date = date, ShareClass = sc)
                                                                                       s |> db.ShareClassEntry.InsertOnSubmit
                                                                                       s
                                                                                  else se
                                                            let total = ws.GetValue<decimal>(r, cols |> Map.find aum)
                                                            if (not (String.IsNullOrEmpty(gps))) then
                                                                se.Gps <- System.Nullable<decimal>(ws.GetValue<decimal>(r, cols |> Map.find gps))
                                                            if (not (String.IsNullOrEmpty(nps))) then
                                                                se.Nps <- ws.GetValue<decimal>(r, cols |> Map.find nps)
                                                            se.TotalAssets <- total
                                                            ())
                                                )
                                            createInfo "Nav Sheet File Uploaded" "Success" action |> db.Alert.InsertOnSubmit
                                            db.DataContext.SubmitChanges()
                                            true
                                         with
                                            | AlertException a -> a |> db.Alert.InsertOnSubmit
                                                                  db.DataContext.SubmitChanges()
                                                                  false
                                            | _ as e -> createError "Nav Sheet File Error" (e.Message) action |> db.Alert.InsertOnSubmit
                                                        db.DataContext.SubmitChanges()
                                                        false

    let rsFileAdded (fileName: string) = use pkg = new OfficeOpenXml.ExcelPackage(System.IO.FileInfo(fileName))
                                         use db = RyeBaySchema.GetDataContext()
                                         let ws = pkg.Workbook.Worksheets.[RiskSheetFlds.sheetName]
                                         let cols = seq { 1..(ws.Cells.Columns) } |> Seq.map(fun c -> ws.GetValue<string>(1, c), c) |> Seq.filter(fun (s, _) -> not (String.IsNullOrEmpty(s))) |> Map.ofSeq
                                         let action = Action(Date = System.DateTime.Now, ActionType = byte ActionType.RiskSheetUpload)
                                         try
                                            let tickers = seq { 3..(ws.Cells.Rows) } |> Seq.filter (fun r -> let s = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.strategy) in 
                                                                                                             s <> "FX" && not (String.IsNullOrEmpty(s))) |> Seq.map (fun r -> ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.securityId)) |> Seq.distinct |> Seq.toArray
                                            let secs = db |> fetchSecuritiesByTickers tickers |> Seq.map (fun s -> s.Ticker, s) |> Map.ofSeq
                                            let getValue r f = ws.GetValue<string>(r, cols |> Map.find f)
                                            seq { 3..(ws.Cells.Rows) }
                                                      |> Seq.filter (fun r -> let strategy = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.strategy)
                                                                              let sid = if String.IsNullOrEmpty(strategy) then "" else ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.securityId)
                                                                              (not (String.IsNullOrEmpty(strategy))) && (not (String.IsNullOrEmpty(sid))) && strategy <> "#N/A" &&
                                                                              sid <> "N/A EQUITY")
                                                      |> Seq.groupBy (fun r -> ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.securityId).ToUpper().Trim())
                                                      |> Seq.map (fun (id, rs) ->
                                                            if secs |> Map.containsKey id
                                                            then 
                                                                secs |> Map.find id, rs
                                                            else 
                                                                let s = SecurityMaster(Ticker = id)
                                                                s |> db.SecurityMaster.InsertOnSubmit
                                                                s, rs)
                                                      |> Seq.iter (fun (sec, rs) -> // security changes
                                                                            let r = rs |> Seq.last
                                                                            let changes = System.Collections.Generic.List<string>()
                                                                            let rv = getValue r "COUNTRY_FULL_NAME"
                                                                            if (sec.Id > 0L && sec.Country <> rv) then
                                                                                "COUNTRY_FULL_NAME" |> changes.Add
                                                                            if not (String.IsNullOrEmpty (rv)) then
                                                                                sec.Country <- rv
                                                                            let rv = getValue r "DS199"
                                                                            if (sec.Id > 0L && sec.Sector1 <> rv) then
                                                                                "DS199" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector1 <- rv
                                                                            let rv = getValue r "DS201"
                                                                            if (sec.Id > 0L && sec.Sector2 <> rv) then
                                                                                "DS201" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector2 <- rv
                                                                            let rv = getValue r "DX202"
                                                                            if (sec.Id > 0L && sec.Sector3 <> rv) then
                                                                                "DX202" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector3 <- rv
                                                                            let rv = getValue r "DX204"
                                                                            if (sec.Id > 0L && sec.Sector4 <> rv) then
                                                                                "DX204" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector4 <- rv
                                                                            let rv = getValue r "DX206"
                                                                            if (sec.Id > 0L && sec.Sector5 <> rv) then
                                                                                "DX206" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector5 <- rv
                                                                            let rv = getValue r "DX208"
                                                                            if (sec.Id > 0L && sec.Sector6 <> rv) then
                                                                                "DX208" |> changes.Add
                                                                            if not (String.IsNullOrEmpty(rv)) then
                                                                                sec.Sector6 <- rv
                                                                            sec.Name <- getValue r "Security Name"
                                                                            if (changes.Count > 0) then
                                                                                let text = sprintf "The following data was changed for security %s: \n %s" sec.Ticker (String.Join("\n", changes.ToArray()))
                                                                                createWarning "Risk Sheet Overwrite" text action |> db.Alert.InsertOnSubmit
                                                                            // security daily values
                                                                            rs |> Seq.iter (fun r ->
                                                                                    try
                                                                                        let dstr = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.date).TrimEnd([|'0'; ':'|])
                                                                                        let date = DateTime.Parse dstr
                                                                                        let sd = db |> fetchSecurityDaily sec.Id date
                                                                                        let sd = if sd = null then let s = SecurityDaily(SecurityMaster = sec, Date = date) 
                                                                                                                   s |> db.SecurityDaily.InsertOnSubmit
                                                                                                                   s
                                                                                                              else sd
                                                                                        let beta = ws.GetValue<float>(r, cols |> Map.find RiskSheetFlds.beta)
                                                                                        let indexPrice = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.indexPrice)
                                                                                        if indexPrice = 0M then
                                                                                            raise <| AlertException(createError "Risk Sheet File Error" (sprintf "index price is invalid on line %i" r) action)
                                                                                        let bn = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.baseNotional)
                                                                                        let indexPrice1 = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.indexPrice1)
                                                                                        if indexPrice = 0M then
                                                                                            raise <| AlertException(createError "Risk Sheet File Error" (sprintf "index price t-1 is invalid on line %i" r) action)
                                                                                        let indexName = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.indexName)
                                                                                        let mktCap = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.marketCap)
                                                                                        let getNullable col =
                                                                                            let str = ws.GetValue<string>(r, cols |> Map.find col)
                                                                                            match Decimal.TryParse(str) with
                                                                                                (true, v) -> System.Nullable<decimal>(v)
                                                                                              | _ -> System.Nullable()
                                                                                        let getNullableInt col =
                                                                                            let str = ws.GetValue<string>(r, cols |> Map.find col)
                                                                                            match Int32.TryParse(str) with
                                                                                                (true, v) -> System.Nullable<int>(v)
                                                                                              | _ -> System.Nullable()
                                                                                        let vlm3m = getNullable RiskSheetFlds.volume3mAvr
                                                                                        let vlm6m = getNullable RiskSheetFlds.volume6mAvr
                                                                                        let vlm5d = getNullable RiskSheetFlds.volume5dAvr
                                                                                        let indexRtnGssDiv = ws.GetValue<float>(r, cols |> Map.find RiskSheetFlds.indexRetGrossDiv)
                                                                                        let rbs = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.ryeBaySector)
                                                                                        let cticker = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.compositeTicker)
                                                                                        let days5d = getNullableInt RiskSheetFlds.days5d
                                                                                        let days3m = getNullableInt RiskSheetFlds.days3m
                                                                                        let days6m = getNullableInt RiskSheetFlds.days6m
                                                                                        let isfb = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.indexSectorForBeta)
                                                                                        let crncy = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.currency)
                                                                                        let relIndex = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.relIndex)
                                                                                        let apb = ws.GetValue<string>(r, cols |> Map.find RiskSheetFlds.aimPrimeBroker)
                                                                                        let sbeta = ws.GetValue<float>(r, cols |> Map.find RiskSheetFlds.sectorBeta)
                                                                                        let sprice = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.sectorPrice)
                                                                                        let sprice3m = ws.GetValue<decimal>(r, cols |> Map.find RiskSheetFlds.sectorPriceM3m)
                                                                                        let quantity = ws.GetValue<int>(r, cols |> Map.find RiskSheetFlds.quantity)
                                                                                        sd.SectorPriceM3m <- sprice3m
                                                                                        sd.SectorBeta <- sbeta
                                                                                        sd.SectorPrice <- sprice
                                                                                        sd.Currency <- crncy
                                                                                        sd.RelIndex <- relIndex
                                                                                        sd.AimPrimeBroker <- apb
                                                                                        sd.IndexSectorForBeta <- isfb
                                                                                        sd.CompositeTicker <- cticker
                                                                                        sd.RyeBaySector <- rbs
                                                                                        sd.Beta <- beta
                                                                                        sd.IndexPrice <- indexPrice
                                                                                        sd.BaseNotional <- bn
                                                                                        sd.IndexPriceM1 <- indexPrice1
                                                                                        sd.Index <- indexName.Substring(0, indexName.LastIndexOf("Index")).Trim()
                                                                                        sd.IndexReturnGrossDiv <- indexRtnGssDiv
                                                                                        sd.MarketCap <- mktCap
                                                                                        sd.Volume3mAvr <- vlm3m
                                                                                        sd.Volume6mAvr <- vlm6m
                                                                                        sd.Volume5dAvr <- vlm5d
                                                                                        sd.Days5d <- days5d
                                                                                        sd.Days3m <- days3m
                                                                                        sd.Days6m <- days6m
                                                                                        sd.Quantity <- quantity
                                                                                    with
                                                                                        | _ as e -> 
                                                                                            let msg = sprintf "An error occurred on line %i" r
                                                                                            raise <| AlertException(createError "Risk Sheet File Error" msg action)
                                                                            ))
                                            createInfo "Risk Sheet File Uploaded" "Success" action |> db.Alert.InsertOnSubmit
                                            db.DataContext.SubmitChanges()
                                            true
                                         with
                                            | AlertException a -> a |> db.Alert.InsertOnSubmit
                                                                  db.DataContext.SubmitChanges()
                                                                  false
                                            | _ as e -> createError "Risk Sheet File Error" (e.Message) action |> db.Alert.InsertOnSubmit
                                                        db.DataContext.SubmitChanges()
                                                        false

    let pnsFileAdded (fileName: string) = 
        let action = Action(Date = System.DateTime.Now, ActionType = byte (ActionType.PurchaseAndSalesUpload))
        use db = RyeBaySchema.GetDataContext()
        try
            use sr = new StreamReader(fileName)
            let file = PurchaseAndSalesFile.Load sr
            let mutable c = 0
            for (i, row) in file.Rows |> Seq.mapi (fun i r -> r, r) do
                let ps = new PurchaseAndSales()
                ps.AccountNumber <- row.``Account Number``
                ps.BaseAccrInt <- row.``Base Accr Int Purch/Sold``
                ps.BaseCommission <- row.``Base Commission``
                ps.BaseCost <- row.``Base Cost``
                ps.BaseExecutionFee <- row.``Base Execution Fee``
                ps.BaseFeeAmount <- row.``Base Fee Amount``
                ps.BaseRealFxPL <- row.``Base Real FX PL``
                ps.BaseRealPL <- row.``Base Real PL``
                ps.Bloomberg <- row.Bloomberg
                ps.BrokerId <- row.``Broker ID``
                ps.BrokerName <- row.``Broker Name``
                ps.ClientSeqNo <- row.``Client Seq No``
                ps.CountryCode <- row.``Country Code``
                ps.Cusip <- row.Cusip
                ps.CusipUnderlier <- row.``Cusip of Underlier``
                ps.ExecBroker <- row.``Exec Broker``
                ps.FundCode <- row.``Fund Code``
                ps.FxRateTrade <- row.``FX Rate Trade``
                ps.Isin <- row.ISIN
                ps.LocalAccrInt <- row.``Local Accr Int Purch/Sold``
                ps.LocalCommission <- row.``Local Commission``
                ps.LocalCost <- row.``Local Cost``
                ps.LocalCostPrice <- row.``Local Cost Price``
                ps.LocalExecutionFee <- row.``Local Execution Fee``
                ps.LocalFeeAmount <- row.``Local Fee Amount``
                ps.LocalRealPL <- row.``Local Real PL``
                ps.Name <- row.``Broker Name``
                ps.ProductType <- row.``Product Type``
                ps.Quantity <- row.Quantity |> int
                ps.RicCode <- row.RICCode
                ps.Secid <- row.Secid.ToString()
                ps.Sedol <- row.Sedol
                ps.SettleDate <- row.``Settle Date``
                ps.SettlementCurrency <- row.``Settlement Currency``
                ps.TradeDate <- row.``Trade Date``
                ps.TranId <- row.``Tran ID``
                ps.TransCode <- row.``Tran Code``
                c <- c + 1
                ps |> db.PurchaseAndSales.InsertOnSubmit
            createInfo "Purchase and Sales File Uploaded" "Success" action |> db.Alert.InsertOnSubmit
            db.DataContext.SubmitChanges()
            true
        with
            | AlertException a -> 
                a |> db.Alert.InsertOnSubmit
                db.DataContext.SubmitChanges()
                false
            | _ as e -> 
                createError "Purchase and Sales File Error" (e.Message) action |> db.Alert.InsertOnSubmit
                db.DataContext.SubmitChanges()
                false

    let ifsFileAdded (fileName: string) 
                     (isDirty: bool)
                     (isFinal: bool)      
                     (isMtd: bool)       =       
                                                   let action = Action(Date = System.DateTime.Now, ActionType = byte (match isMtd, isFinal, isDirty with
                                                                                                                          false, false, false -> ActionType.IfsDailyUpload
                                                                                                                        | true, false, false -> ActionType.IfsMonthlyUpload
                                                                                                                        | false, true, false -> ActionType.IfsFinalDailyUpload
                                                                                                                        | true, true, false -> ActionType.IfsFinalMonthlyUpload
                                                                                                                        | false, false, true -> ActionType.IfsDirtyDailyUpload))  
                                                   use db = RyeBaySchema.GetDataContext()
                                                   try
                                                        use sr = new StreamReader(fileName)
                                                        let file = IfsFile.Load sr
                                                        let date = System.DateTime.Now.Date
                                                        let datem1 = date.AddDays -1.0
                                                        let scache = System.Collections.Generic.Dictionary<string, SecurityMaster>()
                                                        let minDate = (file.Rows |> Seq.minBy (fun r -> r.``To Date``)).``To Date``
                                                        let maxDate = (file.Rows |> Seq.maxBy (fun r -> r.``To Date``)).``To Date``
                                                        let old = db |> fetchPnlEntries minDate maxDate isMtd |> Seq.toList
                                                        let mutable c = 0
                                                        for (i, row) in file.Rows |> Seq.mapi (fun i r -> i, r) do
//                                                            if not isDirty && (row.``To Date``.Month <> date.Month || row.``To Date``.Year <> date.Year || row.``To Date`` > date) then    // not for current month or year so raise an alert
//                                                                raise (AlertException(createError "Wrong Date In File" (sprintf "The current IFS file contains the wrong date on line %d (%s)" (i + 2) (row.``Security Name``))))
//                                                            else if isDirty && (row.``To Date`` <> datem1) then
//                                                                raise (AlertException(createError "Wrong Date In File" (sprintf "The curreny IFS dirty daily file contains the wrong date on line %d (%s)" (i + 1) (row.``Security Name``))))
//                                                            else
                                                                let fxType = getFxType row.``Broker Name``
                                                                if fxType.IsNone && (row.``Bloomberg ID`` |> String.IsNullOrEmpty || row.Strategy |> String.IsNullOrEmpty) && (not <| ignoreWarning row.``Bloomberg ID``) then
                                                                    createWarning "Invalid ID" (sprintf "The current IFS file contains an invalid ID on line %d (%s)" (i + 2) (row.``Security Name``)) action |> db.Alert.InsertOnSubmit
                                                                else if row.``Long/Short`` <> "L" && row.``Long/Short`` <> "S" then
                                                                    createWarning "Invalid Long/Short" (sprintf "The current IFS file contains an invalid Long/Short value on line %d" (i + 2)) action |> db.Alert.InsertOnSubmit
                                                                else
                                                                    let strategy = db |> fetchStrategyByName (row.Strategy)
                                                                    let id = row.``Bloomberg ID``.Trim()
                                                                    let security = if fxType.IsNone then let (c, s) = scache.TryGetValue id
                                                                                                         if c then s else null
                                                                                                    else null
                                                                    let security = if fxType.IsNone && security = null then
                                                                                        let s = db |> fetchSecurityByTicker id
                                                                                        if s <> null then scache.Add (s.Ticker, s)
                                                                                        s
                                                                                   else 
                                                                                        security
                                                                    let security = if fxType.IsNone && security = null then 
                                                                                        let s = SecurityMaster(Ticker = id) 
                                                                                        scache.Add (s.Ticker, s)
                                                                                        s
                                                                                   else security
                                                                    let entry = PnlEntry(
                                                                                    SecurityMaster = security,
                                                                                    FxType = (match fxType with Some f -> new System.Nullable<byte>(byte f) | None -> new System.Nullable<byte>()),
                                                                                    Direction = (if row.``Long/Short`` = "L" then byte Direction.Long else byte Direction.Short),
                                                                                    BaseUnrealised = row.``Base Unreal PL``,
                                                                                    BaseUnrealisedFx = row.``Base Unreal FX PL``,
                                                                                    BaseRealised = row.``Base Real PL``,
                                                                                    BaseRealisedFx = row.``Base Real FX PL``,
                                                                                    BaseIncome = row.``Base Income PL``,
                                                                                    BaseTotal = row.``Base Total PL``,
                                                                                    Date = row.``To Date``,
                                                                                    Name = row.``Security Name``,
                                                                                    Quantity = int row.Quantity,
                                                                                    LocalMarketPrice = row.``Local Market Price``,
                                                                                    LocalTotal = row.``Local Total PL``,
                                                                                    Strategy = strategy,
                                                                                    IsMonthEnd = isMtd)
                                                                    entry |> db.PnlEntry.InsertOnSubmit
                                                                    c <- c + 1
                                                        old |> db.PnlEntry.DeleteAllOnSubmit
                                                        createInfo "IFS File Uploaded" "Success" action |> db.Alert.InsertOnSubmit
                                                        db.DataContext.SubmitChanges()
                                                        true
                                                   with
                                                        | AlertException a -> a |> db.Alert.InsertOnSubmit
                                                                              db.DataContext.SubmitChanges()
                                                                              false
                                                        | _ as e -> createError "IFS File Error" (e.Message) action |> db.Alert.InsertOnSubmit
                                                                    db.DataContext.SubmitChanges()
                                                                    false