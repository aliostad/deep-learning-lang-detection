module Harmful.Tests

open Harmful
open Harmful.Fogbugz
open NUnit.Framework
open FsUnitTyped

(* case 123456
   ob ui/dev
   kb ui/dev
   sync unity
   build unity2
*)

[<Test>]
let ``fogbugz login`` () =
    let api = Api.from "http://fogbugz.unity3d.com/api.asp"
    let api = api |> Fogbugz.Api.login "theor@unity3d.com" (System.Environment.GetEnvironmentVariable "FBZPASS")
    printfn "%s" api.token
    let cases = api |> Fogbugz.Api.search 806120 |> Async.RunSynchronously
    printfn "%A" cases
    ()

[<Test>]
let ``fogbugz case`` () =
    let c = { user = "theor@unity3d.com"
              apiUrl ="http://fogbugz.unity3d.com/api.asp"
              password = (System.Environment.GetEnvironmentVariable "FBZPASS") }
    let p = Fogbugz.Provider(c) :> Types.IProvider

    let res = p.Search(Types.Search ["case"; "123456"]) |> Async.RunSynchronously
    Seq.length res |> shouldEqual 1
    (Seq.head res :?> Fogbugz.CaseItem).case |> shouldEqual 123456

[<Test>]
let ``usecase`` () =
    "case 123456"; ()
