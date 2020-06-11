namespace FizzBuzz.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Threading.Tasks
open Microsoft.AspNetCore.Mvc
open FizzBuzzModule

[<Route("api/[controller]")>]
type FizzBuzzController() =
    inherit Controller()
    
    // GET api/fizzbuzz/seq/100
    [<HttpGet("seq/{n}")>]
    member this.Get(n:int) = fizzbuzz n

    // GET api/fizzbuzz
    [<HttpGet>]
    member this.Get() = this.Get(100)

    // GET api/fizzbuzz/1
    [<HttpGet("{n}")>]
    member this.Item(n:int) = fizzbuzz' n

    // [<HttpPost>]
    // [<HttpPut("{n}")>]
    // [<HttpDelete("{n}")>]
