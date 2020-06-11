module SortPrintColumnNames

// what you will see from ths file is 
// 1. how to split and print the names (the output columns names)

let oqlColumnName =  "SettlementSystem, EnteredByActual, EntrySystemVersion, MarketIndicator, CounterpartyName, AccountLegalEntity, DestinationStatus, DestinationVersion, WashEnabled, AccountID, DestinationID, CounterpartyID, CounterpartyLegalEntity, AccountName, Trader, NumContracts, Updated, BookName, CallOrPut, EntrySystemId, EnteredBy, TicketClass, TradeSource, TraceEligible, TradeId, SecurityPDP, Ticker, ExecutionDateTime, SecurityMeigara, CurrentFactor, Currency, ValuationFunction, Perpetual, DestinationSystem, TradeVersion, Strike, SecurityName, BrokerageAmount, SecurityIDType, Comment, SecurityBBID, EventType, TicketSubType, SecurityID, PaymentMode, DoNotSendToDownStream, PriceTraded, TraceSpecialPrice, CounterpartyIDType, LegalEntity, TicketType, TracePriceOverride, MatchStatus, BrokerageCommissionOpenCloseOverride, EntryDateTime, SecurityBPKY, FuturesExchange, AssetClass, TradeStateVersion, BrokerGiveUp, ClusterTimestamp, TradeGroupId, RiskKey, TraderName, Created, BookIDType, TradeSettleDate, Broker, DataItemRegionPath, BuySell, TraceWeightedAvgPrice, Maturity, ReferenceDataStatus, DoNotReportToTrace, BookSTBK, TradeDate, EntrySystem, SourceSecurityID, Quantity, TicketCompletionStatus, SettlementFXRate, SecurityType, TradeOperation, PriceFormat, Location, BookRegion, Timestamp, SettlementCurrency, BookID, ApprovalStatus, AccountIDType, SourceSystem, BookFOBK"

// check the following link for how to create mutable array with [| |] syntax 
//   Arrays (F#): http://msdn.microsoft.com/en-us/library/dd233214.aspx
// for comparison, please check the following 
//   Lists (F#):  http://msdn.microsoft.com/en-us/library/vstudio/dd233224.aspx
let splitNames (s: string)  = 
    s.Split([|','|])  |> Seq.map (fun x -> x.Trim())

let sortSequence seq =
    Seq.sort seq

let sequence = splitNames oqlColumnName

let sortedSequence = sortSequence sequence

for column in sortedSequence do
    printfn "<i value=\"%s\"/>" column


for column in sortedSequence do
    printfn "%s" column


(* printt the oql columns column mapping *)
for column in sortedSequence do
    printfn "<i model=\"Sonic.Tabular.ColumnMapping:1\">"
    printfn "  <InputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnType type=\"type\" value=\"string\"/>"
    printfn "</i>"



let sqlColumnName = "MarketIndicator, CounterpartyName, AccountLegalEntity, DestinationStatus, AccountID, CounterpartyID, CounterpartyLegalEntity, AccountName, Trader, NumContracts, Updated, BookName, EntrySystemId, EnteredBy, TicketClass, TradeSource, TradeId, SecurityPDP, Ticker, ExecutionDateTime, SecurityMeigara, CurrentFactor, Currency, ValuationFunction, DestinationSystem, TradeVersion, SecurityName, SecurityIDType, SecurityBBID, EventType, TicketSubType, SecurityID, DoNotSendToDownStream, PriceTraded, TraceSpecialPrice, CounterpartyIDType, LegalEntity, TicketType, TracePriceOverride, MatchStatus, EntryDateTime, AssetClass, TradeStateVersion, ClusterTimestamp, TradeGroupId, RiskKey, TraderName, Created, BookIDType, TradeSettleDate, Broker, BuySell, TraceWeightedAvgPrice, Maturity, DoNotReportToTrace, BookSTBK, TradeDate, EntrySystem, SourceSecurityID, Quantity, TicketCompletionStatus, SettlementFXRate, SecurityType, TradeOperation, PriceFormat, Location, BookRegion, Timestamp, SettlementCurrency, BookID, ApprovalStatus, SourceSystem, BookFOBK, ExternalSystemId, SecurityBBPK, LastDeliveryDate, SecurityRIC, PriceType, CounterpartySubType, ExternalSystem, latest"

for column in sortSequence (splitNames sqlColumnName) do
    printfn "<i value=\"%s\"/>" column

for column in sortSequence (splitNames sqlColumnName) do
    printfn "%s" column

(* printt the sql columns column mapping *)
for column in sortSequence (splitNames sqlColumnName) do
    printfn "<i model=\"Sonic.Tabular.ColumnMapping:1\">"
    printfn "  <InputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnType type=\"type\" value=\"string\"/>"
    printfn "</i>"

let sortedSqlSequence = sortSequence (splitNames sqlColumnName)

// check more details on how to run the Set.intersect
//   Set.intersect<'T> function (F#)
let sharedSequence = Set.intersect (Set.ofSeq(sortedSequence)) (Set.ofSeq(sortedSqlSequence))

for column in sharedSequence do 
    printf "%s," column

for column in sharedSequence do 
    printfn "%s" column

for column in sharedSequence do 
    printfn "%s" column

(* print the column output column for union output *)
for column in sharedSequence do
    printfn "<i model=\"Sonic.Tabular.ColumnDefinition:1\">"
    printfn "  <Name value=\"%s\"/>" column
    printfn "  <Type type=\"type\" value=\"string\"/>"
    printfn "</i>"

let  utpCache = "ApprovalStatus, TradeDate, SecurityName, SecurityMeigara, BuySell, Quantity, Yield, BaseYield, PriceTraded, BasePrice, CallOrPut, Strike, OptionType, CounterpartyName, BookFOBK, TraderName, EventType, ExecutionDateTime, Maturity, Currency, Ticker, TradeOperation, TradeId, PackageID, Comment, ExternalOrderId, ValuationFunction, MarketIndicator, Broker, BrokerGiveUp, BrokerageCommissionOpen, BrokerageCommissionClose"
let tradeRespository = "ApprovalStatus, TradeDate, SecurityName, SecurityMeigara, BuySell, Quantity, Yield, BaseYield, PriceTraded, BasePrice, CallOrPut, Strike, OptionType, CounterpartyName, BookFOBK, TraderName, EventType, ExecutionDateTime, Maturity, Currency, Ticker, TradeOperation, TradeId, PackageId, Comment, ExternalOrderId, ValuationFunction, MarketIndicator, Broker, BrokerGiveUp, BrokerageCommissionOpen, BrokerageCommissionClose"

// OQL
for column in sortSequence (splitNames utpCache) do
    printfn "<i value=\"%s\"/>" column

for column in sortSequence (splitNames utpCache) do
    printfn "<i model=\"Sonic.Tabular.ColumnMapping:1\">"
    printfn "  <InputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnType type=\"type\" value=\"string\"/>"
    printfn "</i>"

for column in sortSequence (splitNames utpCache) do
    printfn "<i model=\"Sonic.Tabular.ColumnDefinition:1\">"
    printfn "  <Name value=\"%s\"/>" column
    printfn "  <Type type=\"type\" value=\"string\"/>"
    printfn "</i>"

// Respository (SQL) 
for column in sortSequence (splitNames tradeRespository) do
    printfn "<i value=\"%s\"/>" column

for column in sortSequence (splitNames utpCache) do
    printfn "<i model=\"Sonic.Tabular.ColumnMapping:1\">"
    printfn "  <InputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnName value=\"%s\"/>" column
    printfn "  <OutputColumnType type=\"type\" value=\"string\"/>"
    printfn "</i>"

for column in sortSequence (splitNames utpCache) do
    printfn "<i model=\"Sonic.Tabular.ColumnDefinition:1\">"
    printfn "  <Name value=\"%s\"/>" column
    printfn "  <Type type=\"type\" value=\"string\"/>"
    printfn "</i>"