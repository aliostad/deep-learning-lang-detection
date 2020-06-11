namespace Balgor.Data

open System
open Microsoft.FSharp.Collections //PSeq

open Balgor.Common
open Balgor.Common.Helpers
open Balgor.Data.Broker


module Collect =

    /// Data insert
    let savePrices fx1 fx2 interval prices =
        let txRetry = 10
        let txSeq = seq {
            for i in 1..txRetry do
                yield ForexData.insertPrices fx1 fx2 interval prices
                Threading.Thread.Sleep 5000 }
        let txRes = Seq.tryFind Option.isSome txSeq 
        match txRes with
        | Some nrows -> logfn "PriceData insert | %s/%s %s Rows inserted: %i\n" fx1 fx2 interval nrows.Value
        | None -> failwithf "Failed %d attempts to INSERT PriceData %s %s %s" txRetry fx1 fx2 interval

    /// Data insert
    let savePricesId (fx1, fx1Id) (fx2, fx2Id) (interval, intervalId) prices =
        let txRetry = 10
        let txSeq = seq {
            for i in 1..txRetry do
                yield ForexData.insertPriceRows fx1Id fx2Id intervalId prices
                Threading.Thread.Sleep 3000 }
        let txRes = Seq.tryFind Option.isSome txSeq 
        match txRes with
        | Some nrows -> logfn "PriceData insert | %s/%s %s Rows inserted: %i" fx1 fx2 interval nrows.Value
        | None -> failwithf "Failed %d attempts to INSERT PriceData %s %s %s" txRetry fx1 fx2 interval

    /// Data delete
    let deletePriceId (fx1,fx1Id) (fx2,fx2Id) (interval,intervalId) (date:DateTimeUtc) =
        logfn "PriceData DELETE | %s/%s %s %s" fx1 fx2 interval (dateUtcToStr date)
        ForexData.deletePriceId fx1Id fx2Id intervalId date false

    /// Data delete
    let deletePrice fx1 fx2 interval (date:DateTimeUtc) =
        logfn "PriceData DELETE | %s/%s %s %s" fx1 fx2 interval (dateUtcToStr date)
        ForexData.deletePrice fx1 fx2 interval date false |> ignore

    /// Data delete all duplicates i.e. delete butOne row
    let deleteDuplicatePriceId (fx1,fx1Id) (fx2,fx2Id) (interval,intervalId) (date:DateTimeUtc) =
        logfn "PriceData DELETE DUPLICATE | %s/%s %s %s" fx1 fx2 interval (dateUtcToStr date)
        ForexData.deletePriceId fx1Id fx2Id intervalId date true

    let collectData (currencyPairs : (string * string) array) (intervalSyms : string list) (minDate:DateTimeUtc) (maxDate:DateTimeUtc) =
        if (minDate > maxDate) then failwithf "Incorrect input dates: minDate={%s} maxDate={%s}" (dateUtcToStr minDate) (dateUtcToStr maxDate)

        let getIntervalId intervalSym = ForexData.getIntervalId intervalSym

        let currencySyms = CurrencyInstrument.AllCurrencySymbols() |> List.ofArray
        let getCurrId currSym = ForexData.getCurrencyId currSym
   
        let isWeekend (d1:DateTimeUtc) (d2:DateTimeUtc) =
            let fridayAfter (d:DateTimeUtc) = (d.DayOfWeek = DayOfWeek.Friday) && d.Hour >= 23
            let saturday (d:DateTimeUtc) = (d.DayOfWeek = DayOfWeek.Saturday)
            let sundayBefore (d:DateTimeUtc) = (d.DayOfWeek = DayOfWeek.Sunday) && d.Hour <= 23
            let offTime (d:DateTimeUtc) = fridayAfter d || saturday d || sundayBefore d
            offTime d1 && offTime d2

        let weekendHolidayGap (d1:DateTimeUtc) (d2:DateTimeUtc) =
            let weekend = isWeekend d1 d2
            let christmass = d1.Day = 24 && d1.Month = 12
            let silvester = d1.Day = 31 && d1.Month = 12 
            weekend || christmass || silvester

        let getAndSaveData c1sym c2sym intervalSym minDate maxDate =
            if not <| isWeekend minDate maxDate then
                let (c1Id, c2Id) = getCurrId c1sym, getCurrId c2sym
                let intervalId = getIntervalId intervalSym
                let prices = Broker.getPrices c1sym c2sym intervalSym minDate maxDate
                if Seq.isEmpty prices then ()
                else
                    async { savePricesId (c1sym, c1Id) (c2sym, c2Id) (intervalSym, intervalId) prices } |> Async.Start

        /// Updates the local DB saved price data with data from the broker.
        /// Goal is to reduce gaps between data. Ideal would be zero gaps.
        let updateSavedDataInterval c1sym c2sym intervalSym (dtSeq : DateTimeUtc seq) =
            let (c1Id, c2Id) = getCurrId c1sym, getCurrId c2sym
            let intervalId = getIntervalId intervalSym
            let dt = dtSeq |> Seq.toArray
            let mutable foundGapFlag = false
            let mutable dateFrom = dt.[0]
            let mutable dateTo = dateFrom
            let mutable tFrom = 0
            let mutable tTo = tFrom
            let mutable duplicateTimes = Seq.empty
            let mutable savePricesIdAsyncSeq = Seq.empty
            let trimStartEnd (s:'a seq) =
                let lenp = Seq.length s
                if lenp > 2 then
                    s |> Seq.tail  |> Seq.take (lenp - 2)
                else Seq.empty

            for t in 0..dt.Length - 2 do
                let isLast t =
                    t = dt.Length-2
                let tn = dt.[t]
                let tn1 = dt.[t+1]
                let intervalSpan = Interval.getTimeSpan intervalSym

                if tn + intervalSpan < tn1 && not <| weekendHolidayGap tn tn1 then
                    dateFrom <- tn
                    tFrom <- t
                    if not <| isLast t then // not at the end of time seq, proceed with checks normally
                        foundGapFlag <- true
                    else // tn1 is the last date checked i.e. we are missing new data as time goes on
                        dateTo <- tn1
                        logfn "%s/%s %s {%s to %s} | Downloading missing data" c1sym c2sym intervalSym (dateUtcToStr dateFrom) (dateUtcToStr dateTo)
                        let prices = Broker.getPrices c1sym c2sym intervalSym dateFrom dateTo
                        // Check that besides the 2 elements to be trimmed there will be smthg left to save
                        if Seq.length prices > 2 then
                            // remove the head and last value
                            let pricesTrimmed = trimStartEnd prices
                            savePricesIdAsyncSeq <- Seq.append savePricesIdAsyncSeq (seq { yield async {
                                savePricesId (c1sym, c1Id) (c2sym, c2Id) (intervalSym, intervalId) pricesTrimmed }})
                elif foundGapFlag && tn + intervalSpan = tn1 then // found a gap in dates - get and save missing data
                    foundGapFlag <- false
                    dateTo <- tn
                    tTo <- t
                    logfn "%s/%s %s {%s to %s} | Downloading missing data" c1sym c2sym intervalSym (dateUtcToStr dateFrom) (dateUtcToStr dateTo)
                    let prices = Broker.getPrices c1sym c2sym intervalSym dateFrom dateTo
                    // Check that besides the 2 (first and last) elements to be trimmed there will be smthg left to save
                    if Seq.length prices > 2 then
                        // remove the head and last value
                        let pricesTrimmed = trimStartEnd prices
                        // delete eventual datapoints between dateFrom and dateTo
                        let obsoletePrices = dt.[tFrom+1..tTo-1]
                        savePricesIdAsyncSeq <- Seq.append savePricesIdAsyncSeq (seq { yield async {
                            Array.iter (fun r -> deletePriceId (c1sym, c1Id) (c2sym, c2Id) (intervalSym, intervalId) r |> ignore) obsoletePrices
                            //savePrices c1sym c2sym intervalSym pricesTrimmed
                            savePricesId (c1sym, c1Id) (c2sym, c2Id) (intervalSym, intervalId) pricesTrimmed }})

                elif tn = tn1 then // found a duplicate => delete all but 1 duplicate
                        duplicateTimes <- Seq.append duplicateTimes (seq { yield tn })
            
            let deleteDuplicatesTask = async {
                let distinctDuplicates = duplicateTimes |> Seq.distinct
                distinctDuplicates |> PSeq.iter (fun time ->
                    deleteDuplicatePriceId (c1sym, c1Id) (c2sym, c2Id) (intervalSym, intervalId) time |> ignore ) }

            let savePriceIdsTask = async {
                for savePricesId in savePricesIdAsyncSeq do
                    do! savePricesId }

            //deleteDuplicatesTask |> Async.Start
            //savePriceIdsTask |> Async.Start
            [deleteDuplicatesTask; savePriceIdsTask ] |> Async.Parallel |> Async.Ignore |> Async.Start

        let loginResult = Broker.login ()
        if loginResult.isLeft then failwithf "%s" loginResult.LeftValue

        let minDateStr = dateUtcToStr minDate
        let maxDateStr = dateUtcToStr maxDate

        // Start with all intervals
        for intervalSym in intervalSyms do
            for (c1sym, c2sym) in currencyPairs do
                let (c1Id, c2Id) = getCurrId c1sym, getCurrId c2sym
                let intervalId = getIntervalId intervalSym
                logfn ""
                logfn "Collecting data for %s/%s %s" c1sym c2sym intervalSym
                let priceRecords = ForexData.getPriceDataRecords "datetime" c1Id c2Id intervalId None None
                if priceRecords.Length = 0 then // no previous data found - get them all in 1 data request
                    logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym minDateStr maxDateStr
                    logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym minDateStr maxDateStr
                    getAndSaveData c1sym c2sym intervalSym minDate maxDate
                else
                    // Interval intersection cases - 2 intervals, 6 possible cases. 2 of them have the same action of just getAndSaveData so 5 guards not 6
                    // the two intervals are the requested (dateMin, dateMax) and the local data based (dtRecordsMin, dtRecordsMax)
                    let dtRecords = priceRecords |> Seq.map (ForexData.convertToDateTime "datetime")
                    let dtRecordsMin = Seq.head dtRecords
                    let dtRecordsMax = Seq.last dtRecords

                    let dtRecordsMinStr = dateUtcToStr dtRecordsMin
                    let dtRecordsMaxStr = dateUtcToStr dtRecordsMax

                    match () with 
                    | _ when (minDate <= dtRecordsMin && maxDate <= dtRecordsMin) || (minDate >= dtRecordsMax && maxDate >= dtRecordsMax) ->
                        logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym minDateStr maxDateStr
                        logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym minDateStr maxDateStr
                        getAndSaveData c1sym c2sym intervalSym minDate maxDate
                    | _ when (minDate <= dtRecordsMin && maxDate >= dtRecordsMin && maxDate <= dtRecordsMax) ->
                        logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym minDateStr dtRecordsMinStr
                        logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym minDateStr dtRecordsMinStr
                        getAndSaveData c1sym c2sym intervalSym minDate dtRecordsMin
                        // Update existing data according to received data
                        let dt = Seq.takeWhile (fun v -> v <= maxDate) dtRecords
                        updateSavedDataInterval c1sym c2sym intervalSym dt
                    | _ when (minDate <= dtRecordsMin && maxDate >= dtRecordsMax) ->
                        logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym minDateStr dtRecordsMinStr
                        logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym minDateStr dtRecordsMinStr
                        getAndSaveData c1sym c2sym intervalSym minDate dtRecordsMin
                        logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym dtRecordsMaxStr maxDateStr
                        logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym dtRecordsMaxStr maxDateStr
                        getAndSaveData c1sym c2sym intervalSym dtRecordsMax maxDate
                        // Update existing data according to received data
                        let dt = dtRecords
                        updateSavedDataInterval c1sym c2sym intervalSym dt
                    | _ when (minDate >= dtRecordsMin && maxDate <= dtRecordsMax) ->
                        // Update existing data according to received data
                        let dt = dtRecords |> Seq.skipWhile (fun v -> v <= minDate) |> Seq.takeWhile (fun v -> v <= maxDate)
                        updateSavedDataInterval c1sym c2sym intervalSym dt 
                    | _ when (minDate >= dtRecordsMin && minDate <= dtRecordsMax && maxDate >= dtRecordsMax) ->
                        // Update existing data according to received data
                        let dt = dtRecords |> Seq.skipWhile (fun v -> v <= minDate)
                        updateSavedDataInterval c1sym c2sym intervalSym dt 
                        logfn "No local data found for %s/%s %s from %s to %s" c1sym c2sym intervalSym dtRecordsMaxStr maxDateStr
                        logfn "%s/%s %s {%s to %s} | Downloading data" c1sym c2sym intervalSym dtRecordsMaxStr maxDateStr
                        getAndSaveData c1sym c2sym intervalSym dtRecordsMax maxDate
                    | _ -> failwith "Error in matching guards logic - this should be impossible to match"
        
        Broker.logout ()

    let collectDataAllIntervals currencyPairs (minDate:DateTimeUtc) (maxDate:DateTimeUtc) =
        let intervalSyms = Interval.AllIntervalSymbols()
        // Start with all but the smallest symbols - those are too much data and not needed currently
        let intervalSymsReduced = List.filter (fun s -> s <> "m5" && s <> "m1" && s <> "m15") intervalSyms
        collectData currencyPairs intervalSymsReduced minDate maxDate

    let collectDataAll (minDate:DateTimeUtc) (maxDate:DateTimeUtc) =
        let currencyPairs = CurrencyInstrument.AllCurrencySymbolPairs()
        collectDataAllIntervals currencyPairs minDate maxDate
