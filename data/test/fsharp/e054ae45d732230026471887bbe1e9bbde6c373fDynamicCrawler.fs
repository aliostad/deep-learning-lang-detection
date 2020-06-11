module XTract.Dynamic.Crawler

open OpenQA.Selenium.PhantomJS
open System
open System.Collections.Concurrent
open OpenQA.Selenium.Chrome
open OpenQA.Selenium.Remote
open Settings

module Helpers =

    type Task =
        | Get of string
        | CssClick of string
        | XpathClick of string
        | CssSendKeys of string * string
        | XpathSendKeys of string * string
        | Scrape of (string -> string -> unit)
        | WithImplicitlyWait of TimeSpan
        | WithPageLoadTimeout of TimeSpan
        | ExecuteJs of string
        | ExecuteJsAsync of string
        | Maximize

    type Message =
        | Mailbox of MailboxProcessor<Message>
        | Stop
        | Url of string option
        | Start of AsyncReplyChannel<unit>
        | Pause
        | BrowserTask of Task

    let rec waitComplete (driver:#RemoteWebDriver) =
        let state = driver.ExecuteScript("return document.readyState;").ToString()
        match state with
        | "complete" -> ()
        | _ -> waitComplete driver

open Helpers

//type Driver =
//    | Chrome
//    | Phantom

type DynamicCrawler(?Gate, ?Options:ChromeOptions) as this =
    let q = ConcurrentQueue<string>()
    [<DefaultValue>] val mutable repl : AsyncReplyChannel<unit>
    [<DefaultValue>] val mutable scrapeFunc : string -> string -> unit
//    let driver = defaultArg Browser Phantom
    let options = defaultArg Options (ChromeOptions())
    let gate = defaultArg Gate 5
    let failedRequests = ConcurrentBag<string>()

    let supervisor =
        MailboxProcessor.Start(fun inbox -> async {
            let rec loop run =
                async {
                    let! msg = inbox.Receive()
                    match msg with
                    | Start channel ->
                        this.repl <- channel
                        return! loop true
                    | Pause -> return! loop false
                    | Mailbox(mailbox) -> 
                        match run with
                        | false ->
                            mailbox.Post (Url None)
                            return! loop false
                        | true ->
                            let url = q.TryDequeue()
                            match url with
                            | true, str ->
                                mailbox.Post <| Url(Some str)
                                return! loop run 
                            | _ -> mailbox.Post Pause
                    | Url _ -> failwith "Unexpected URL message!"
                    | BrowserTask _ -> failwith "Unexpected BrowserTask message!"
                    | Stop ->
                        printfn "Supervisor is done."
                        (inbox :> IDisposable).Dispose()
                }
            do! loop false })
  
    let replier =
        MailboxProcessor<Message>.Start(fun inbox ->
            let rec loop count =
                async {
                    let! msg = inbox.Receive()
                    match msg with
                    | Stop ->
                        (inbox :> IDisposable).Dispose()
                        printfn "URL collector is done."
                    | _ ->
                        match count with
                        | _ when count = gate ->
                            this.repl.Reply(())
                            supervisor.Post Pause
                            return! loop 1
                        | _ -> return! loop (count + 1)
                }
            loop 1)
    
    /// Initializes a crawling agent.
    let crawler id =
        let browser = new ChromeDriver(XTractSettings.chromeDriverDirectory, options)
//            match driver with
//            | Chrome -> new ChromeDriver(XTractSettings.chromeDriverDirectory) :> RemoteWebDriver
//            | Phantom -> new PhantomJSDriver(XTractSettings.phantomDriverDirectory) :> RemoteWebDriver
//        let load (url:string) = browser.Navigate().GoToUrl url
//        do browser.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds 10.) |> ignore
//        do browser.Manage().Timeouts().SetPageLoadTimeout(TimeSpan.FromSeconds 60.) |> ignore
        
        let load (url:string) =
            try
                browser.Navigate().GoToUrl url
                waitComplete browser
                Some browser.PageSource
            with _ ->
                failedRequests.Add url
                None
        MailboxProcessor.Start(fun inbox ->
            let rec loop() =
                async {
                    let! msg = inbox.Receive()
                    match msg with
                    | BrowserTask t ->
                        match t with
                        | CssClick selector ->
                            browser.FindElementByCssSelector(selector).Click()
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | XpathClick xpath ->
                            browser.FindElementByXPath(xpath).Click()
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | Get url ->
                            load url |> ignore
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | CssSendKeys (selector, text) ->
                            let elem = browser.FindElementByCssSelector selector
                            elem.SendKeys text
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | XpathSendKeys (xpath, text) ->
                            let elem = browser.FindElementByXPath xpath
                            elem.SendKeys text
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | Scrape f ->
                            let html = browser.PageSource
                            f html browser.Url
                            supervisor.Post(Mailbox(inbox))
                            return! loop()
                        | WithImplicitlyWait timespan ->
                            browser.Manage().Timeouts().ImplicitlyWait(timespan) |> ignore
                            return! loop()
                        | WithPageLoadTimeout timespan ->
                            browser.Manage().Timeouts().SetPageLoadTimeout(timespan) |> ignore
                            return! loop()
                        | ExecuteJs js ->
                            browser.ExecuteScript js |> ignore
                            waitComplete browser
                            return! loop()                         
                        | ExecuteJsAsync js ->
                            browser.ExecuteAsyncScript js |> ignore
                            waitComplete browser
                            return! loop()
                        | Maximize ->
                            browser.Manage().Window.Maximize()
                            return! loop()
                    | Url x ->
                        match x with
                        | Some url ->
                            let html = load url
                            match html with
                            | None ->
                                supervisor.Post(Mailbox(inbox))
                                return! loop()
                            | Some html ->
                                this.scrapeFunc html url
                                supervisor.Post(Mailbox(inbox))
                                return! loop()
                        | None -> supervisor.Post(Mailbox(inbox))
                                  return! loop()
                    | Pause ->
                        replier.Post Pause
                        return! loop()

                    | _ ->
                           browser.Quit()
                           printfn "Agent %d is done." id
                           (inbox :> IDisposable).Dispose()
                    }
            loop())

    // Spawn the crawlers.
    let crawlers =
        [
            for x in 1 .. gate do
                yield crawler x
        ]
    
    member __.Crawl(scrapeFunc, urls) =
        this.scrapeFunc <- scrapeFunc
        urls |> Seq.iter q.Enqueue
        crawlers |> List.iter (fun ag -> ag.Post <| Url None) 
        supervisor.PostAndAsyncReply(Start)

    member __.FailedRequests = failedRequests.ToArray()

    member __.StoreFailedRequest url = failedRequests.Add url

    member __.Quit() =
        crawlers |> List.iter (fun ag -> ag.Post Stop)
        replier.Post Stop
        supervisor.Post Stop

    member __.CssClick(cssSelector) =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| CssClick cssSelector))
        supervisor.PostAndAsyncReply(Start)

    member __.XpathClick(xpath) =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| XpathClick xpath))
        supervisor.PostAndAsyncReply(Start)

    member __.Get(url) =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| Get url))
        supervisor.PostAndAsyncReply(Start)

    member __.CssSendKeys cssSelector text =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| CssSendKeys(cssSelector, text)))
        supervisor.PostAndAsyncReply(Start)

    member __.XpathSendKeys xpath text =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| XpathSendKeys(xpath, text)))
        supervisor.PostAndAsyncReply(Start)

    member __.Scrape f =
        crawlers |> List.iter (fun ag -> ag.Post (BrowserTask <| Scrape f))
        supervisor.PostAndAsyncReply(Start)