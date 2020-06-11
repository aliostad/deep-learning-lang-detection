namespace RaynMaker.Portfolio.Specs.PositionsInteractor

open System
open NUnit.Framework
open FsUnit
open RaynMaker.Portfolio.Entities
open RaynMaker.Portfolio.Interactors

[<AutoOpen>]
module internal Broker = 
    let fee = 9.9M<Currency> 

    let at year month day = new DateTime(year, month, day)

    let buy company count price date =
        { StockBought.Date = date 
          Name = company
          Isin = sprintf "US%i" (company.GetHashCode())
          Count = count |> decimal
          Price = 1.0M<Currency> * (price |> decimal)
          Fee = fee
        } |> StockBought

    let sell company count price date =
        { StockSold.Date = date 
          Name = company
          Isin = sprintf "US%i" (company.GetHashCode())
          Count = count |> decimal
          Price = 1.0M<Currency> * (price |> decimal)
          Fee = fee
        } |> StockSold


[<TestFixture>]
module ``Given some stock transactions`` =
    
    [<Test>]
    let ``<When> stock only bought <Then> position is open and full invest is sumed up``() =
        let positions =
            [
                at 2016 10 10 |> buy "Joe Inc" 10 10.0
                at 2016 12 12 |> buy "Joe Inc" 5 15.0
            ]
            |> PositionsInteractor.getPositions

        positions |> should haveLength 1

        positions.[0].Open |> should equal (at 2016 10 10)
        positions.[0].Close |> should equal None
        positions.[0].Count |> should equal 15
        positions.[0].Invested |> should equal ((10.0M * 10.0M<Currency> + fee) + (5.0M * 15.0M<Currency> + fee))
        positions.[0].Payouts |> should equal 0.0M<Currency>
        positions.[0].Dividends |> should equal 0.0M<Currency>

    [<Test>]
    let ``<When> an open position is closed <Then> position summary shows profits and ROIs``() =
        let summary =
            [
                at 2014 01 01 |> buy "Joe Inc" 10 10.0
                at 2015 01 01 |> buy "Joe Inc" 5 15.0
                at 2016 01 01 |> sell "Joe Inc" 15 20.0
            ]
            |> PositionsInteractor.getPositions
            |> PositionsInteractor.summarizePositions

        summary |> should haveLength 1

        let investedMoney = 175.0M<Currency> + (2.0M * fee)
        let profit = 300.0M<Currency> - fee - investedMoney
        let roi = profit / investedMoney * 100.0M<Percentage>

        summary.[0].Close |> should equal (at 2016 01 01 |> Some)
        summary.[0].MarketProfit |> should equal profit
        summary.[0].MarketRoi |> should equal roi
        summary.[0].MarketRoiAnual |> should equal (roi / 2.0M)


