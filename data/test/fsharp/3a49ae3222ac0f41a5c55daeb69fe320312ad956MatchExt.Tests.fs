namespace NiceTry.Tests.Combinators

open FsUnit
open NUnit.Framework
open NiceTry
open NiceTry.Combinators
open System
open TheVoid

module MatchExtTests =
  [<Test>]
  let ``Matching a succes should execute the handler for success`` () =
    let original = Try.Success 3
    original.Match((fun x -> string x), (fun err -> err.Message)) |> should equal "3"

  [<Test>]
  let ``Matching a failure should execute the handler for failure`` () =
    let err = Exception "Expected err"
    let original = Try.Failure<int> err
    original.Match((fun x -> string x), (fun err -> err.Message)) |> should equal err.Message
