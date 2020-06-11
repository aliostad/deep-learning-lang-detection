module KataPotter

// http://codingdojo.org/cgi-bin/wiki.pl?KataPotter
// more: http://www.pirrmann.net/potter-kata/
// another katas:
    // parking meter : http://strangelights.com/blog/archive/2013/04/27/alt-net-coding-breakfast-ndash-april-2013-edition.aspx
    // http://www.pirrmann.net/alt-net-coding-breakfast-june-2013-edition/

//  rules
// books (of 5)     cost/discount
// 1 of any         8 EUR
// 2 diffrent       5% off on the two books
// 3 diffrent       10% off
// 4 diffrent       20% off
// all set of 5     25% off


//For example, how much does this basket of books cost?
//  2 copies of the first book
//  2 copies of the second book
//  2 copies of the third book
//  1 copy of the fourth book
//  1 copy of the fifth book
//(answer: 51.20 EUR)


#if INTERACTIVE
#r "../packages/xunit.1.9.1/lib/net20/xunit.dll"
#r "../packages/FsUnit.xUnit.1.2.1.2/Lib/Net40/FsUnit.Xunit.dll"
#r "../packages/xunit.extensions.1.9.2/lib/net20/xunit.extensions.dll"
#endif

open System
open Xunit
open Xunit.Extensions
open FsUnit.Xunit


type BookItem<'T> =
    | BookItem of 'T

type DiscountRule = 
    | Diff of int

let calculateBasket basket =
    
    let unitPrice = 8.
    let discounts = [
        Diff 2, 0.95;
        Diff 3, 0.90;
        Diff 4, 0.80;
        Diff 5, 0.75;
        ]


    let rec processSingleDiscount countedBasket partialTotal discount =
        match discount with
        | Diff d, discountValue when d <= List.length countedBasket -> 
            let unprocessedItemsBasket = countedBasket 
                                        |> List.filter (snd >> (<) 0)
                                        |> List.map ( fun (item, count) -> item, count - 1)
                                        |> List.filter (snd >> (<>) 0)
            processSingleDiscount unprocessedItemsBasket (partialTotal + discountValue * unitPrice * float d) discount
        | _ -> (partialTotal, countedBasket)

    let processDiscounts countedBasket discounts =
        let rec processDiscountsRec basket totalAcc = function
                    | discount::ds -> 
                        let total, unprocessedItemsBasket = processSingleDiscount basket 0.0 discount
                        processDiscountsRec unprocessedItemsBasket (totalAcc + total) ds
                    | [] -> totalAcc + unitPrice * float (List.sumBy snd basket)

        processDiscountsRec countedBasket 0.0 discounts

    let counted = 
        basket 
        |> Seq.map BookItem
        |> Seq.countBy id
        |> List.ofSeq

    processDiscounts counted (discounts |> List.sortBy snd)



type ``When calculating basket price`` () =

    static let asPropertyData testData = testData |> List.map (fun (p,b) -> [|p:>Object;b:>Object|])

    static member basicBaskets =
        [ 
          0., []
          8., [0]
          8., [1]
          8., [2]
          8., [3]
          8., [4]
          8. * 2., [0;0]
          8. * 3., [1;1;1]
        ] |> asPropertyData

    [<Theory>]
    [<PropertyData("basicBaskets")>]
    member x.``It should return correct price when no discount`` (price:float, basket:int list) =
        calculateBasket basket |> should equal price


    static member simpleDiscountBaskets =
        [ 
          8. * 2. * 0.95,       [0;1]
          8. * 2. * 0.95 + 8.,  [0; 2; 2]
          8. * 3. * 0.9,        [0; 2; 4]
          8. * 4. * 0.8,        [0; 1; 2; 4]
          8. * 5. * 0.75,       [0; 1; 2; 3; 4]
        ] |> asPropertyData

    [<Theory>]
    [<PropertyData("simpleDiscountBaskets")>]
    member x.``It should return disounted price``(price:float, basket:int list) =
        calculateBasket basket |> should equal price

    // two sets of four books is cheaper than a set of five and a set of three
    static member trickyBaskets = [51.2, [0;0;1;1;2;2;3;4]] |> asPropertyData
    [<Theory>]
    [<PropertyData("trickyBaskets")>]
    member x.``It should find the lowest discount possible``(price:float, basket:int list) =
        calculateBasket basket |> should equal price