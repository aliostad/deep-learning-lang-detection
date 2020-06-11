namespace FSharpWebAPIExample.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Net
open System.Net.Http
open System.Web.Http
open System.Web.Http.Description
open System.ComponentModel.DataAnnotations
open FSharpWebAPIExample
open FSharpWebAPIExample.Models
open FSharpWebAPIExample.WebServices
module E = FSharpWebAPIExample.ErrorHandling
open FSharpWebAPIExample.Log

type TestController () as __ =
    inherit ApiController ()

    let toHttpResultWith x = E.toHttpResult __ logError x
    let toJsonResult x = toHttpResultWith Utils.jsonResponse x

    // GET api/values
    member __.Get () =
         [| Some "value1"; Some "value2"; None |]

    // GET api/values/5
    member __.Get id =
        Call.getPerson id

    // POST api/values
    member  __.Post([<FromBody>] person : DTO.Person) =
        person
        |> DTO.Person.Validate |> E.badRequest
        |> E.bind (E.tryCatch Call.addPerson)
        |> toJsonResult
//        

    // DELETE api/values/5
    member __.Delete (id : int) =
        ()
