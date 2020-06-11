// for more guidance on F# programming.
#r "../packages/FSharp.Data/lib/net40/Fsharp.Data.dll"
#r "../packages/Http.fs/lib/net40/HttpClient.dll"
#r "../packages/Suave/lib/net40/Suave.dll"
#r "System.Web.Extensions"

#load "stockfighter/StockfighterBase.fs"
#load "stockfighter/SocketWrapper.fs"
#load "stockfighter/StockfighterApi.fs"

//#load "solutions/BaseSolutions.fs"

open System
open System.IO
open System.Threading
open SocketWrapper
open StockfighterApi
open StockfigherCommon
//open BaseSolutions
open Suave
open System.Net
open System.Threading
open System.Net.WebSockets
open StockfigherCommon

type Agent<'T> = MailboxProcessor<'T>

let apiKey = System.IO.File.ReadAllLines("api_key.prop").[0]

let levelApi = StockfighterLevel(apiKey)

let level = levelApi.startLevel("dueling_bulldozers") |> Async.RunSynchronously

let api = StockFighter(apiKey, level.account)
let venue = StockFighterVenue(api, level.venue)
let stock = StockFighterStock(venue, level.ticker)

//levelApi.stopLevel(level.instanceId) |> Async.RunSynchronously

stock.openSocketConnection()
stock.closeSocketConnection()
venue.isVenueUp()

type SocketAgent private (url, f) as this =
  let tokenSource = new CancellationTokenSource()
  let agent = Agent.Start((fun _ -> f this), tokenSource.Token)
  let socket = new ClientWebSocket()
  let _ = openSocket url socket

  let runSocket = async {
    while true do
      async {
        do! Async.Sleep(16)
      } |> Async.RunSynchronously
      let ms = GetSocketMessage url socket logQuote GetQuoteResponse
      agent.Post(ms) }
  do Async.Start(runSocket, cancellationToken = tokenSource.Token)

  member x.Receive(?timeout) = agent.Receive(?timeout = timeout)

  member x.Stop() = tokenSource.Cancel()

  static member Start(url, f) =
    new SocketAgent(url, f)

let a =
  SocketAgent.Start(stock.getSockertUrl(), fun agent -> async {
    while true do
      let! log = agent.Receive()
      printfn "agent %A" log })
a.Stop()
