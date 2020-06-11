module Helpers

open System
open System.Reflection
open System.IO

module Json =
    open Newtonsoft.Json

    let settings = JsonSerializerSettings()
    settings.Converters.Add(Fable.JsonConverter())

    let serialize (value : 'a) =
        JsonConvert.SerializeObject(value, settings)

    let deserialize (json) : 'a =
        JsonConvert.DeserializeObject<'a>(json, settings)

let normalizePath path =
    Uri(path).LocalPath

let exeFolder = 
    Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) |> normalizePath

open Suave
open Suave.Filters
open Suave.Operators
open Suave.RequestErrors

let restResponce handler =
    request (fun req ->
        match handler |> Async.RunSynchronously with
        | Result.Ok result -> result |> Json.serialize |> Successful.OK
        | Result.Error error -> BAD_REQUEST error)
    >=> Writers.setMimeType "application/json; charset=utf-8"