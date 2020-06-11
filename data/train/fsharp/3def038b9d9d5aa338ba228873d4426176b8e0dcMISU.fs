module MISU

open System

// First cut - it is possible to represent many illegal states:

type Price = 
   { Id : int
     Ticker : string
     Side : int // 1 = Bid; 2 = Ask
     Price : decimal
     TraderId : int option
     BrokerId : int option }

let goodPrice = 
   { Id = 1
     Ticker = "GOOG"
     Side = 1
     Price = 551.76M
     TraderId = Some 16
     BrokerId = None }

let badPrice = 
   { Id = 1
     Ticker = ""
     Side = 3
     Price = 551.76M
     TraderId = None
     BrokerId = None }

// Second cut - Side is safer but ticker can be blank and originator can be either, neither or both of
// trader and broker:

type MarketSide = 
   | Bid
   | Ask

type Price2 = 
   { Id : int
     Ticker : string
     Side : MarketSide
     Price : decimal
     TraderId : int option
     BrokerId : int option }

let goodPrice2 = 
   { Price2.Id = 1
     Ticker = "GOOG"
     Side = Bid
     Price = 551.76M
     TraderId = Some 16
     BrokerId = None }

let badPrice2 = 
   { Price2.Id = 1
     Ticker = ""
     Side = Bid
     Price = 551.76M
     TraderId = None
     BrokerId = None }

// Third cut - Originator must be one of either Trader or Broker; ticker might still be blank or null:

type Originator = 
   | Trader of Id : int
   | Broker of Id : int

type Price3 = 
   { Id : int
     Ticker : string
     Side : MarketSide
     Price : decimal
     Originator : Originator }

let goodPrice3 = 
   { Price3.Id = 1
     Ticker = "GOOG"
     Side = Bid
     Price = 551.76M
     Originator = Trader 16 }

let badPrice3 = 
   { Price3.Id = 1
     Ticker = ""
     Side = Bid
     Price = 551.76M
     Originator = Trader 16 }

// Fourth cut - ticker can't be null or blank:

type ValidatedTicker(symbol : string) =
   do
      if (String.IsNullOrWhiteSpace symbol) then
         raise (ArgumentException(sprintf "Invalid symbol %s" symbol))
         // In reality some collection or database access here to check
         // it's a real symbol
   member __.Symbol = symbol

type Price4 = 
   { Id : int
     Ticker : ValidatedTicker
     Side : MarketSide
     Price : decimal
     Originator : Originator }

let goodPrice4 = 
   { Price4.Id = 1
     Ticker = ValidatedTicker "GOOG"
     Side = Bid
     Price = 551.76M
     Originator = Trader 16 }

let badPrice4 = 
   { Price4.Id = 1
     Ticker = ValidatedTicker "" // Runtime exception
     Side = Bid
     Price = 551.76M
     Originator = Trader 16 }

// Fifth cut - use single case DU's to strengthen ID and Price. Is this too much?

type PriceId = Id of int
type PriceValue = Price of decimal

type Price5 = 
   { Id : PriceId
     Ticker : ValidatedTicker
     Side : MarketSide
     Price : PriceValue
     Originator : Originator }

let goodPrice5 = 
   { Price5.Id = Id 1
     Ticker = ValidatedTicker "GOOG"
     Side = Bid
     Price = Price 551.76M
     Originator = Trader 16 }

let badPrice5 = 
   { Price5.Id = Id 1
     Ticker = ValidatedTicker "" // Runtime exception
     Side = Bid
     Price = Price 551.76M
     Originator = Trader 16 }


