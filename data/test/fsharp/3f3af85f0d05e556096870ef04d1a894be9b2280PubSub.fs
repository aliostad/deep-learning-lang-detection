module PubSub

open Net.Lib
open System
open System.Net
open System.Text
open System.Threading

[<EntryPoint>]
let main argv =
  let port = int argv.[0]
  let publisher = PubSub.create PubSub.MultiCastAddress port

  let handler = function
    | PubSubEvent.Request (id, bytes) ->
      bytes
      |> Encoding.UTF8.GetString
      |> printfn "[%O] received: %s" id

  publisher.Subscribe(handler) |> ignore

  let mutable run = true
  while run do
    Console.Write("> ")
    match Console.ReadLine() with
    | "exit" -> run <- false
    | other ->
      other
      |> Encoding.UTF8.GetBytes
      |> publisher.Send
  publisher.Dispose()
  0
