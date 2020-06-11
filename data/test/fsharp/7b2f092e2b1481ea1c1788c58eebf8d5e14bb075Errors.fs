namespace Fazuki.Server

open System
open FSharp.Core
open Fazuki.Common
open System.Text
module Errors =

    let internal makeSuccess (message:byte[]) = 
        message |> Array.append "y"B

    let internal makeError (error:ServerError) = 
        match error with
        | ReceiveError(e) -> sprintf "RECEIVE RESPONSE: %s" (e.ToString())
        | DeserializeError(e) -> sprintf "DESERIALIZE REQUEST: %s" (e.ToString())
        | ExecuteError(e) -> sprintf "EXECUTE: %s" (e.ToString())
        | SerializeError(e) -> sprintf "SERIALIZE RESPONSE: %s" (e.ToString())
        | SendError(e) -> sprintf "SEND RESPONSE: %s" (e.ToString())
        | GetHandlerError(e) -> 
            match e with
            | MessageEmpty -> "received an empty message (no route, or content)"
            | NoContent -> "expected content for this route, but none supplied"
            | NoMessageName -> "you did not supply a route, dont know how to handle this message"
            | HandlerNotFound -> "could not find a handler for this route"
            | Unknown(ex) -> sprintf "GET HANDLER: %s" (ex.ToString())
        
        |> Encoding.UTF8.GetBytes
        
