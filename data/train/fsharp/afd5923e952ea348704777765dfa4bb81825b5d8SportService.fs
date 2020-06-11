module SportService

open Monads.Choice
open Newtonsoft.Json
open Suave
open Suave.Operators
open Suave.RequestErrors
open Suave.Successful
open Types

let CORS = Writers.addHeader "Access-Control-Allow-Origin" "*"
let JSON = Writers.setMimeType "application/json"
let resp = JSON >=> CORS
let okJSON s = OK s >=> resp

let name (ctx : HttpContext) =
  let r = ctx.request
  (r.queryParam "firstName"), (r.queryParam "lastName")

let failResponse (fail:FailureCode) =
  match fail with
  | RecordNotFound -> NOT_FOUND "Record not found"

let processRoute statFunc (ctx : HttpContext) =
  let input = choice {
    let! firstName = fst (name ctx)
    let! lastName = snd (name ctx)
    return (firstName, lastName)
  }

  let result =
    match input with
    | Choice2Of2 err -> BAD_REQUEST err
    | Choice1Of2 (first, last) -> match statFunc first last with
                                  | Failure f -> (failResponse f) >=> resp
                                  | Success record -> JsonConvert.SerializeObject(record)
                                                      |> okJSON

  result ctx

let getLowestTournament (db:IDB) (ctx : HttpContext) =
  processRoute db.GetLowestTournament ctx

let getLowestRound (db:IDB) (ctx : HttpContext) =
  processRoute db.GetLowestRound ctx

let getTotalGolfEarnings (db:IDB) (ctx : HttpContext) =
  processRoute db.GetTotalGolfEarnings ctx

let getHomeruns (db:IDB) (ctx : HttpContext) =
  processRoute db.GetHomeruns ctx

let getStrikeouts (db:IDB) (ctx : HttpContext) =
  processRoute db.GetStrikeouts ctx

let getSteals (db:IDB) (ctx : HttpContext) =
  processRoute db.GetSteals ctx
