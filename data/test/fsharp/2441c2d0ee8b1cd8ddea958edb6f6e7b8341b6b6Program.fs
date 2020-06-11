namespace API

type Program() =
  member x.Main () =
    printf "hello"

(*
open System.IO
open Suave.Http
open Suave.Http.Successful
open Suave
open Suave.Http.Applicatives
open Suave.Web
open Newtonsoft.Json
open Newtonsoft.Json.Serialization

type Person = {
  Id: int
  Name: string
  Age: int
  Email: string
}

[<EntryPoint>]
let main argv =
  let person = {
    Id = 0
    Name = "Tomas"
    Age = 28
    Email = "tomas@example.com"
  }

  let JSON v =
    let jsonSerializerSettings = new JsonSerializerSettings()
    jsonSerializerSettings.ContractResolver <- new CamelCasePropertyNamesContractResolver()
    JsonConvert.SerializeObject(v, jsonSerializerSettings)
    |> OK
    >>= Writers.setMimeType "application/json; charset=utf-8"

  let api =
    choose [
      path "/user" >>= (JSON person)
    ]

  startWebServer defaultConfig api

  0
*)
