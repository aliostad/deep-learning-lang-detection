[<AutoOpen>]
module XTract.Dynamic.CustomSingleDynamicScraper

open System.Collections.Concurrent
open System.Collections.Generic
open System
open Newtonsoft.Json
open Microsoft.FSharp.Reflection
open System.IO
open CsvHelper
open SpreadSharp
open SpreadSharp.Collections
open XTract
open OpenQA.Selenium.Chrome
open Settings
open Helpers
open Crawler
open OpenQA.Selenium.PhantomJS
open OpenQA.Selenium.Remote

type CustomSingleDynamicScraper<'T when 'T : equality>(?Options:ChromeOptions) =
//    let browser = defaultArg Browser Phantom
    let options = defaultArg Options (ChromeOptions())
    let driver = new ChromeDriver(XTractSettings.chromeDriverDirectory, options)
//        match browser with
//            | Chrome -> new ChromeDriver(XTractSettings.chromeDriverDirectory) :> RemoteWebDriver
//            | Phantom -> new PhantomJSDriver(XTractSettings.phantomDriverDirectory) :> RemoteWebDriver
//    do driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds 10.) |> ignore
//    do driver.Manage().Timeouts().SetPageLoadTimeout(TimeSpan.FromSeconds 10.) |> ignore

    let rec waitComplete() =
        let state = driver.ExecuteScript("return document.readyState;").ToString()
        match state with
        | "complete" -> ()
        | _ -> waitComplete()  
          
    let load (url:string) =
        try
            driver.Navigate().GoToUrl url
            waitComplete()
            Some driver.PageSource
        with _ -> None

    let dataStore = HashSet<'T>()
//    let failedRequests = ConcurrentQueue<string>()
    let log = ConcurrentQueue<string>()
    let mutable loggingEnabled = true
    let mutable pipelineFunc = (fun (record:'T) -> record)

    let pipeline =
        MailboxProcessor<'T>.Start(fun inbox ->
            let rec loop() =
                async {
                    let! msg = inbox.Receive()
                    pipelineFunc msg
                    |> dataStore.Add
                    |> ignore
                    return! loop()
                }
            loop()
        )

    let logger =
        MailboxProcessor.Start(fun inbox ->
            let rec loop() =
                async {
                    let! msg = inbox.Receive()
                    let time = DateTime.Now.ToString()
                    let msg' = time + " - " + msg
                    log.Enqueue msg'
                    match loggingEnabled with
                    | false -> ()
                    | true -> printfn "%s" msg'
                    return! loop()
                }
            loop()
        )
    
    member __.WithImplicitlyWait timespan =
        driver.Manage().Timeouts().ImplicitlyWait(timespan) |> ignore

    member __.WithPageLoadTimeout timespan =
        driver.Manage().Timeouts().SetPageLoadTimeout(timespan) |> ignore

    member __.Driver = driver

    member __.ExecuteJs js =
        driver.ExecuteScript js |> ignore
        waitComplete()

    member __.ExecuteJsAsync js =
        driver.ExecuteAsyncScript js |> ignore
        waitComplete()

    member __.Maximize() = driver.Manage().Window.Maximize()


    member __.WithPipeline f = pipelineFunc <- f

    /// Loads the specified URL.
    member __.Get (url:string) = load url

    /// Selects an element and types the specified text into it.
    member __.SendKeysCss cssSelector text =
        let elem = driver.FindElementByCssSelector cssSelector
//        printfn "%A" elem.Displayed
        elem.SendKeys(text)

    /// Selects an element and types the specified text into it.
    member __.SendKeysXpath xpath text =
        let elem = driver.FindElementByXPath xpath
//        printfn "%A" elem.Displayed
        elem.SendKeys(text)

    /// Selects an element and clicks it.
    member __.ClickCss cssSelector =
        driver.FindElementByCssSelector(cssSelector).Click()
        waitComplete()

    member __.CssSelect cssSelector =
        Html.loadRoot driver.PageSource
        |> fun x -> Html.cssSelect cssSelector x

    member __.CssSelectAll cssSelector =
        Html.loadRoot driver.PageSource
        |> fun x -> Html.cssSelectAll cssSelector x

    member __.XpathSelect xpath =
        Html.loadRoot driver.PageSource
        |> fun x -> Html.xpathSelect xpath x

    member __.XpathSelectAll xpath =
        Html.loadRoot driver.PageSource
        |> fun x -> Html.xpathSelectAll xpath x

    member __.PageSource = driver.PageSource

    /// Selects an element and clicks it.
    member __.ClickXpath xpath =
        driver.FindElementByXPath(xpath).Click()
        waitComplete()

    /// Closes the browser drived by the scraper.
    member __.Quit() = driver.Quit()

    /// Posts a new log message to the scraper's logging agent.
    member __.Log msg = logger.Post msg

    /// Returns the scraper's log.
    member __.LogData = log.ToArray()

    /// Enables or disables printing log messages.
    member __.WithLogging enabled = loggingEnabled <- enabled

    /// Scrapes a single data item from the specified URL or HTML code.
    member __.Scrape(scrapeFunc) =
        let url = driver.Url
        logger.Post <| "Scraping data from " + url
        let html = driver.PageSource
        let record = scrapeFunc html url
        match record with
        | None -> None
        | Some x ->
            pipeline.Post x
            record

    member __.Scrape(url, scrapeFunc) =
        logger.Post <| "Scraping data from " + url
        try
            let html = load url |> Option.get
            let record = scrapeFunc html url
            match record with
            | None -> None
            | Some x ->
                pipeline.Post x
                record
        with _ ->
            logger.Post <| "Failed to scrape " + url
            None

    member __.Scrape(urls, scrapeFunc) =
        for url in urls do
            try
                logger.Post <| "Scraping " + url
                let html = load url |> Option.get
                let record = scrapeFunc html url
                match record with
                | None -> ()
                | Some x -> pipeline.Post x
            with _ -> logger.Post <| "Failed to scrape " + url

    /// Scrapes all the data items from the specified URL or HTML code.    
    member __.ScrapeAll(scrapeFunc) =
        let url = driver.Url
        logger.Post <| "Scraping data from " + url
        let html = driver.PageSource
        let records = scrapeFunc html url
        match records with
        | None -> None
        | Some lst ->
            lst |> List.iter pipeline.Post
            records

    member __.ScrapeAll(url, scrapeFunc) =
        try
            logger.Post <| "Scraping data from " + url
            let html = load url |> Option.get
            let records = scrapeFunc html url
            match records with
            | None -> None
            | Some lst ->
                lst |> List.iter pipeline.Post
                records
        with _ ->
            logger.Post <| "Failed to scrape " + url
            None

    member __.ScrapeAll(urls, scrapeFunc) =
        for url in urls do
            try
                logger.Post <| "Scraping data from " + url
                let html = load url |> Option.get
                let records = scrapeFunc html url
                match records with
                | None -> ()
                | Some lst -> lst |> List.iter pipeline.Post
            with _ -> logger.Post <| "Failed to scrape " + url

    /// Returns the data stored so far by the scraper.
    member __.Data =
        dataStore
        |> Seq.toArray

//    /// Returns the urls that scraper failed to download.
//    member __.FailedRequests = failedRequests.ToArray()

//    /// Stores a failed HTTP request, use this method when
//    /// handling HTTP requests by yourself and you want to
//    /// track errors.
//    member __.StoreFailedRequest url = failedRequests.Enqueue url
//
    /// Returns the data stored so far by the scraper in JSON format.
    member __.JsonData =
        JsonConvert.SerializeObject(dataStore, Formatting.Indented)

    /// Returns the data stored so far by the scraper as a Deedle data frame.
//    member __.DataFrame = Frame.ofRecords dataStore

    /// Saves the data stored by the scraper in a CSV file.
    member __.SaveCsv(path) =
        let headers =
            FSharpType.GetRecordFields typeof<'T>
            |> Array.map (fun x -> x.Name)
//            |> fun x -> Array.append x [|"Source"|]
        let sw = File.CreateText(path)
        let csv = new CsvWriter(sw)
        headers
        |> Array.iter (fun x -> csv.WriteField x)
        csv.NextRecord()
        dataStore
        |> Seq.iter (fun x ->
            Utils.fields x
            |> Array.iter (fun x -> csv.WriteField x)
            csv.NextRecord()            
        )
        sw.Flush()
        sw.Dispose()

    /// Saves the data stored by the scraper in an Excel file.
    member __.SaveExcel(path) =
        let xl = XlApp.startHidden()
        let workbook = XlWorkbook.add xl
        let worksheet = XlWorksheet.byIndex workbook 1
        let headers =
            FSharpType.GetRecordFields typeof<'T>
            |> Array.map (fun x -> x.Name)
        let columnsCount = Array.length headers
        let rangeString = String.concat "" ["A1:"; string (char (columnsCount + 64)) + "1"]
        let rng = XlRange.get worksheet rangeString
        Array.toRange rng headers
        dataStore
        |> Seq.iteri (fun idx x ->
            let idxString = string <| idx + 2
            let rangeString = String.concat "" ["A"; idxString; ":"; string (char (columnsCount + 64)); idxString]
            let rng = XlRange.get worksheet rangeString
            Array.toRange rng (Utils.fields x)
        )
        XlWorkbook.saveAs workbook path
        XlApp.quit xl