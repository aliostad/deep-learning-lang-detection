module IntraDayTickRequest

open System
open System.Collections.Generic
open System.Linq
open System.Text

open BEmu //un-comment this line to use the Bloomberg API Emulator
//open Bloomberglp.Blpapi; //un-comment this line to use the actual Bloomberg API

let ProcessResponse (event : Event) (security : string) =
    //Note that the IntradayBarResponse does not include the name of the requested security anywhere
    printfn "%s" security
    
    event.GetMessages()
    |> Seq.iter (fun msg ->
        let elmTickDataArr = msg.["tickData"]
        let elmTickData = elmTickDataArr.["tickData"]
        for valueIndex in 0..elmTickData.NumValues-1 do
            let elmBarTickData = elmTickData.GetValueAsElement(valueIndex)

            let time = elmBarTickData.GetElementAsTime("time").ToSystemDateTime()
            let type' = elmBarTickData.GetElementAsString("type")
            let value = elmBarTickData.GetElementAsFloat64("value")
            let size = elmBarTickData.GetElementAsInt32("size")

            printfn "%s" (String.Format("{0:HH:mm:ss}: {1}, {2} @ {3}", time, type', size, value))
    )

let RunExample() =

    let uri = "//blp/refdata"
    let operationName = "IntradayTickRequest"
    let sessionOptions = new SessionOptions(ServerHost = "127.0.0.1", ServerPort = 8194)
    let session = new Session(sessionOptions)

    if session.Start() && session.OpenService(uri) then
        let refDataService = session.GetService(uri)
        let request = refDataService.CreateRequest(operationName)

        let security = "SPY US Equity"
        request.Set("security", security)

        request.Append("eventTypes", "TRADE") //One of TRADE (default), BID, ASK, BID_BEST, ASK_BEST, MID_PRICE, AT_TRADE, BEST_BID, BEST_ASK (see documentation A.2.6 for explanations)
        request.Append("eventTypes", "BID") //A request can have multiple eventTypes
        //refDataService.ToString() using the Bloomberg API indicates an additional eventType called "SETTLE".  This doesn't seem to produce any results.

        request.Set("startDateTime", new Datetime(DateTime.Today.AddHours(9.5).ToUniversalTime()))
        request.Set("endDateTime", new Datetime(DateTime.Today.AddHours(11.).ToUniversalTime())) //goes back at most 140 days (documentation section 7.2.3)

        //A comma delimited list of exchange condition codes associated with the event. Review QR<GO> for more information on each code returned.
        request.Set("includeConditionCodes", false) //Optional bool. Valid values are true and false (default = false)

        //Returns all ticks, including those with condition codes.
        request.Set("includeNonPlottableEvents", false) //Optional bool. Valid values are true and false (default = false)

        //The exchange code where this tick originated. Review QR<GO> for more information.
        request.Set("includeExchangeCodes", false) //Optional bool. Valid values are true and false (default = false)

        //Option on whether to return EIDs for the security.
        request.Set("returnEids", false) //Optional bool. Valid values are true and false (default = false)

        //The broker code for Canadian, Finnish, Mexican, Philippine, and Swedish equities only.
        //  The Market Maker Lookup screen, MMTK<GO>, displays further information on market makers and their corresponding codes.
        request.Set("includeBrokerCodes", false) //Optional bool. Valid values are true and false (default = false)

        //The Reporting Party Side. The following values appear:
        //  -B: A customer transaction where the dealer purchases securities from the customer.
        //  -S: A customer transaction where the dealer sells securities to the customer.
        //  -D: An inter-dealer transaction (always from the sell side).
        request.Set("includeRpsCodes", false) //Optional bool. Valid values are true and false (default = false)

        //The BIC, or Bank Identifier Code, as a 4-character unique identifier for each bank that executed and reported the OTC trade, as required by MiFID.
        //  BICs are assigned and maintained by SWIFT (Society for Worldwide Interbank Financial Telecommunication).
        //  The MIC is the Market Identifier Code, and this indicates the venue on which the trade was executed.
        request.Set("includeBicMicCodes", false) //Optional bool. Valid values are true and false (default = false)

        //refDataService.ToString() using the Bloomberg API specifies several boolean overrides that the API documentation doesn't (doc version 2.40).  These are:
        //   forcedDelay, includeSpreadPrice, includeYield, includeActionCodes, includeIndicatorCodes, includeTradeTime, and includeUpfrontPrice
        //These overrides are optional.  Their meanings may be obvious given their names, but I can't be sure.

        request.Set("forcedDelay", false) //Optional bool. Undocumented. default = ???
        request.Set("includeSpreadPrice", false) //Optional bool. Undocumented. default = ???
        request.Set("includeYield", false) //Optional bool. Undocumented. default = ???
        request.Set("includeActionCodes", false) //Optional bool. Undocumented. default = ???
        request.Set("includeIndicatorCodes", false) //Optional bool. Undocumented. default = ???
        request.Set("includeTradeTime", false) //Optional bool. Undocumented. default = ???
        request.Set("includeUpfrontPrice", true) //Optional bool. Undocumented. default = ???

        let corr = new CorrelationID(17L)

        session.SendRequest(request, corr) |> ignore

        let rec ReadResults() =
            let event = session.NextEvent()
            match event.Type with
            | Event.EventType.RESPONSE ->
                ProcessResponse event security
                ()
            | Event.EventType.PARTIAL_RESPONSE ->
                ProcessResponse event security
                ReadResults()
            | _ ->
                ReadResults() // C# version doesn't handle this case - F# pattern matching FTW.

        ReadResults()


    