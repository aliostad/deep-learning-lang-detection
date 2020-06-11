open Argu
open FSharp.Data
open Slack
open Suave
open Suave.Filters
open Suave.Logging
open Suave.Operators
open Suave.Successful

/////////////////////////////////////////////////////////////////////////////
// Logging helpers
let log = Suave.Logging.Log.create("foo")
let logSimple(s: string) =
    Message.event Info s |> log.logSimple
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Command line arguments
type Arguments = 
    | [<Mandatory>] IncomingWebhookUrl of url: string
with
    interface IArgParserTemplate with
        member this.Usage = 
            match this with
            | IncomingWebhookUrl _ -> "incoming webhook URL to use"
/////////////////////////////////////////////////////////////////////////////

// Pushes a string back to Slack, via the incoming webhook URL.
let sendStringViaWebhook(webhookUrl: string)(s: string) = 
    // send the request to the webhook
    let response = "{\"text\": \"" + s + "\"}"
    Http.RequestString(webhookUrl, httpMethod = "POST", body = TextRequest(response.ToString()), headers = [ HttpRequestHeaders.ContentType(HttpContentTypes.Json) ]) |> ignore

// Request handler for echo requests.
let echoRequestHandler(r: SlackRequest): SlackResponse = 
    {
        SlackResponse.responseType = SlackResponseType.InChannel
        text = r.Text |> Option.defaultValue("")
    }

// Request handler for initiating a countdown.
let countdownRequestHandler(webhookUrl: string)(r: SlackRequest): SlackResponse = 
    let resp = 
        {
            SlackResponse.responseType = SlackResponseType.InChannel
            text = "Commencing countdown!"
        }

    async {
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("5!")
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("4!")
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("3!")
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("2!")
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("1!")
        do! Async.Sleep(1000)
        sendStringViaWebhook(webhookUrl)("Blast off!")
    } |> Async.StartAsTask |> ignore

    resp

// Suave command handler for Slack bot commands.
let commandHandler(webhookUrl: string)(ctx: HttpContext) = 
    (
        let req = SlackRequest.FromHttpContext ctx
        let resp = 
            match req.Text with
            | Some("countdown") -> countdownRequestHandler(webhookUrl)(req)
            | _ -> echoRequestHandler(req)

        resp.ToString()
        |> OK
    ) ctx

// Suave app handler.
let app(webhookUrl: string) = 
    let handler = commandHandler(webhookUrl)
    choose [
        POST >=> path "/command" >=> handler >=> Writers.setMimeType "application/json"
    ]

[<EntryPoint>]
let main argv = 
    let parser = ArgumentParser.Create<Arguments>()
    let results = parser.Parse(argv)

    match results.TryGetResult(<@ IncomingWebhookUrl @>) with
    | Some(webhookUrl) -> 
        startWebServer defaultConfig (app(webhookUrl))
        0
    | _ ->
        System.Console.WriteLine(parser.PrintCommandLineSyntax)
        1
