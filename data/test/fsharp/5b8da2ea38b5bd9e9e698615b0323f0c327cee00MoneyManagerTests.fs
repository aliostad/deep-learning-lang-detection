namespace FSharpPlayHouse.Test
//open NUnit.Framework
open FsUnit
open System
open ShogeStrategies
open MoneyManagerModule

//[<TestFixture>]
//type ``Given that I want to manage my money the money manager``() =
//    
//    let emptyAccount = {new IBankAccount with member x.Balance() = 0M}
//    let mutable riskManager : SimpleRiskManager = new SimpleRiskManager()
//
//    [<SetUp>]
//    member x.Setup() = ()
////        SimpleRiskManager = new SimpleRiskManager()
////        |> ignore
//
//    [<Test>]
//    member I.``Should return a balance of zero from a empty bank account`` () =
//        //arrange
//        let emptyAccFunc = fun _ -> 0M
//        //act
//        let balance = riskManager.GetPortfolioBalance |> emptyAccFunc
//        //assert
//        balance |> should equal 0
//
//    [<Test>]
//    member I.``Should return balance of bank account passed into the constructor``() =
//        //arrange
//        let expectedBalance = 1500M
//        let barclaysAccount = { new IBankAccount with member x.Balance() = expectedBalance }
//        //act
//        let balance = riskManager.GetPortfolioBalance barclaysAccount.Balance
//        //assert
//        balance |> should equal expectedBalance
//
//    [<Test>]
//    member I.``Should by default only ever risk 1% of total capital``() =
//        //arrange
//        let stockPrice = 10M
////        let barclaysAccount = { new IBankAccount with member x.Balance() = 1500M<GBP> }
//        let manager = new SimpleRiskManager()
//        //act
//        let balance,units = manager.Offer 100000M stockPrice 
//        let expectedBalance = 100000M  * 0.01M
//        //assert
//        balance |> should equal expectedBalance
//
//    [<Test>]
//    member I.``should be able to choose what % of risk that i use``() =
//        let accountFunc = fun _ -> 100000M 
//        let stockPrice = 10M
//        let prcToUse =  0.05M
//        let manager = new SimpleRiskManager(prcToUse)
//        //act
//        let balance,units = manager.Offer 100000M stockPrice 
//        let expectedBalance = 100000M  * prcToUse
//        //assert
//        balance |> should equal expectedBalance
//
//
//    [<Test>]
//    member I.``should get a offer of 10 units on 1% of capital of 10000 and unit price of 10``() =
//        //arrange
//        let stockPrice = 10M
//        let prcToUse =  0.01M
//        let manager = new SimpleRiskManager(prcToUse)
//        //act
//        let balance, units = manager.Offer 100000M stockPrice
//        let expectedBalance = 100000M  * prcToUse
//        //assert
//        units |> should equal 100
//
//    [<Test>]
//    member I.``should get a offer of 2 units on 1% of capital of 1000 and unit price of 35``() =
//        //arrange
//        let stockPrice = 35M
//        let prcToUse =  0.01M
//        let manager = new SimpleRiskManager(prcToUse)
//        //act
//        let balance, units = manager.Offer 10000M stockPrice
//        //assert
//        units |> should equal 2
//
////    [<Test>]
////    member I.``Should return a weak offer if the risk is high``() =
////        //arrange
////        let accountFunc = fun _ -> 
//////        let barclaysAccount = { new IBankAccount with member x.Balance() = 1500M<GBP> }
////        let manager = new SimpleRiskManager()
////        //act
////        let balance = manager.GetPortfolioBalance accountFunc
////
////        //assert
////        balance |> should equal expectedBalance
//
//
