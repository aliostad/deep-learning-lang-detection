open System

type MarketSide =
    | Bid
    | AskS

type Originator =
    | Trader of Id : int
    | Broker of Id : int

type Price =
    { Id : int
      Ticker : string
      Side : MarketSide
      Price : decimal
      Originator : Originator }



let goodPrice =
    { Id = 1
      Ticker = "GOOG"
      Side = Bid
      Price = 551.76M
      Originator = Trader 16 }

let badPrice =
    { Id = 1
      Ticker = ""
      Side = Bid
      Price = 551.76M
      Originator = Broker 32 }







[<EntryPoint>]
let main argv = 
    printfn "%A" argv
    0 // return an integer exit code

