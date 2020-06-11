#r "../packages/FSharp.Data/lib/net40/FSharp.Data.dll"
#r "../packages/Suave/lib/net40/Suave.dll"

#load "ParsingHelpers.fs"
#load "CallbackAPI.fs"
#load "SendAPI.fs"
#load "API.fs"



open FacebookMessengerConnector
open FacebookMessengerConnector.CallbackAPI
open FacebookMessengerConnector.SendAPI
open Suave


let send r =
   r |> Request.make "API_TOKEN_GOES_HERE"
   |> Async.RunSynchronously
   |> printfn "%A"

let handler (callback : Callback) =
   for entry in callback.Entries do
      for event in entry.messagingEvents do
         match event.message with
         | None -> ()
         | Some m ->
            let action = SenderAction ((Recipient.Id event.sender), TypingOn)
            send action
            match m.text with
            | Some text ->
               let response = Message((Recipient.Id event.sender), Message.Text(sprintf "I got '%s' from you" text, None, None), None)
               send response
            | _ -> ()



let app = Callback.webPart "/webhook" "VERIFICATION_TOKEN_GOES_HERE" handler

open Suave.Logging
let logger = Loggers.ConsoleWindowLogger LogLevel.Verbose

startWebServer {defaultConfig with logger = logger} app


