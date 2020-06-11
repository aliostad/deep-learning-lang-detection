open System

// Weak MISU, runtime check
type LineLossFactorClass(value:int) =
    do 
        if value < 1 || value > 999 then
            raise(Exception("Invalid LineLossFactorClass"))

    override __.ToString() = sprintf "%03i" value

 
let lineLoss = LineLossFactorClass(10)
printfn "%s" (lineLoss.ToString())


// Stronger MISU

type Price = {
        Id: int
        Ticker: string
        Side: int // 1 or 2
        Price: decimal
        TraderId: int
        BrokerId: int
    }

{
    Id = 1
    Ticker =  ""
    Side = 3
    Price = 10.10M
    TraderId = 1001
    BrokerId = 1001
}

type MarketSide = Bid | Ask
type Originator =
    | Trader of Id:int
    | Broker of Id:int

type ValidatedTicker(symbol: string) =
    do
        if(String.IsNullOrEmpty symbol) then 
            raise(Exception("Symbol cannot be null"))

    member __.Symbol = symbol

type MISUPrice = 
    {
        Id: int
        Ticker: ValidatedTicker
        Side: MarketSide
        Price: decimal
        Originator: Originator
    }

{
    Id = 1
    Ticker = ValidatedTicker("MSFT")
    Side = Bid
    Price = 101.0M
    Originator = Trader 1001
}
