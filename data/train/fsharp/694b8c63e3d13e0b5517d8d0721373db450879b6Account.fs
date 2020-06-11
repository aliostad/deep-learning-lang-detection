// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module AccountTests

open System
open Helpers
open NUnit.Framework
open Helpers
open Wireclub.Models


[<SetUp>]
let setup () =
    Helpers.setup ()

[<TearDown>]
let teardown () = Helpers.teardown ()

[<Test>]
let Login () =
    Account.login username password 
    |> run
    |> assertApiResult
    |> ignore

[<Test>]
let ``Bad Login`` () =
    match Account.login "sdfasfafd" "dsaewrwer" |> run with
    | Api.BadRequest [ { Key = "error" } ] -> ()
    | _ -> Assert.Fail ()

[<Test>]
let ``Token Login`` () =
    let result = Account.login username password |> run |> assertApiResult
    Account.loginToken result.Token 
    |> run 
    |> assertApiResult 
    |> ignore
    

[<Test>]
let ``Token Login (Invalid)`` () =
    match Account.loginToken "000" |> run with
    | Api.Unauthorized -> ()
    | unexpected -> Assert.Fail (sprintf "%A" unexpected)

[<Test>]
let Identity () =
    run (Account.login username password) 
    |> assertApiResult 
    |> ignore

    let identity = 
        Account.identity ()
        |> run
        |> assertApiResult
    
    Assert.AreEqual (username, identity.Slug)

[<Test>]
let Signup () =
    let result= 
        Account.signup ("tst" + System.DateTime.UtcNow.Ticks.ToString() + "@test.com") "testtest"
        |> run
        |> assertApiResult

    Account.loginToken result.Token
    |> run 
    |> assertApiResult 
    |> ignore


[<Test>]
let ``Reset Password`` () =
    Account.resetPassword email
    |> run
    |> assertApiResult
    |> ignore
