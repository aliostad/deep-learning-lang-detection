#r "../packages/Suave/lib/net40/Suave.dll"
#r "../packages/RethinkDb.Driver/lib/net45/RethinkDb.Driver.dll"
#load "model.fs"
    
open Suave
open Suave.Filters
open Suave.Successful
open Suave.Operators
open Suave.Files
open Suave.Sockets
open Suave.Sockets.Control
open Suave.WebSocket

open Model

open RethinkDb.Driver
open RethinkDb.Driver.Net

module Db = 
    
    let R = RethinkDB.R

    let conn = 
        R.Connection()
         .Hostname("docker.local")
         .Port(28015)
         .Connect()

    let registerBrodcaster handler =  async {
        R.Db("test").Table("Messages").Changes().RunChanges<Model.Message>(conn)
        |> handler
    }
    
    let saveMessage (msg : Message) = 
        R.Db("test").Table("Messages").Insert(msg).Run(conn) 
        |> ignore

let clients = ResizeArray ()

let echo (webSocket : WebSocket) =
    fun cx ->
        clients.Add webSocket
        socket {
            let loop = ref true
            while !loop do
                let! msg = webSocket.read()
                match msg with
                | (Text, data, true) ->
                    data
                    |> Json.fromJson 
                    |> Db.saveMessage
                | (Ping, _, _) -> do! webSocket.send Pong [||] true
                | (Close, _, _) ->
                    do! webSocket.send Close [||] true
                    clients.Remove webSocket |> ignore
                    loop := false
                | _ -> ()
            }

let sendAll msg =
    let msg' = Json.toJson msg
    clients |> Seq.iter (fun w ->  w.send Text msg' true |> Async.Ignore |> Async.Start)
    ()

let rec handler (cursor : Cursor<Model.Change<Model.Message>>) = 
    cursor.MoveNext() |> ignore
    cursor.Current.NewValue |> sendAll
    handler cursor

do Db.registerBrodcaster handler |> Async.Start

let app : WebPart =
    choose [ path "/websocket" >=> handShake echo
             GET >=> choose [ path "/" >=> file "index.html"
                              browseHome ]
             RequestErrors.NOT_FOUND "Found no handlers." ]      
    