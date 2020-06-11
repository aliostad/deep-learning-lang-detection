module Handlers

open Suave
open System.Text.RegularExpressions

let sanitize input =
    let pattern = @"[^a-zA-Z0-9-]+"
    Regex.Replace (input, pattern, "")

let response output =
    match String.isEmpty output with
    | true  -> RequestErrors.NOT_FOUND ""
    | false -> output |> Successful.OK

let getKeysHandler name ttl =
    name
    |> sanitize
    |> Keys.getKeysforUserOrGroup
    |> Templates.createUsers ttl
    |> Templates.verifyConfig
    |> response

let getKeys name =
    getKeysHandler name 0

let getKeysWithTTL p =
    let name, ttl = p
    getKeysHandler name ttl
