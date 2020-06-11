module ClientTests

open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Testing
open Elmish.Browser.UrlParser

open App
open Common
open ClientModels
open Helpers

let equal (expected: 'T) (actual: 'T) =
    Assert.AreEqual(expected, actual)

[<Test>]
let ``Urls parsing``() =
    let testUrl url r =
        let parsed =
            createObj
                [ "hash" ==> url
                  "search" ==> "" ]
            |> unbox
            |> parseHash pageParser

        equal (Some r) parsed
        equal url (toHash r) 

    testUrl "#/home" PageRequest.Home
    testUrl "#/user"  PageRequest.UserSearch
    testUrl "#/product"  PageRequest.ProductSearch


let baseApi : Api.SampleDataApi = 
    { User = 
        { Search = fun _ -> invalidOp "No Handled" }
      Product = 
        { Search = fun _ -> invalidOp "No Handled" } }
