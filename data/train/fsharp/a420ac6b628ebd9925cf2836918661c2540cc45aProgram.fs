open KafkaNet
open KafkaNet.Model
open KafkaNet.Protocol
open System
open System.Collections.Generic
open System.Configuration
open System.IO
open System.Reactive.Concurrency
open System.Threading

let printMe s = printfn "%s" s

let getTopic (argv : string []) = 
    match argv.Length with
    | len when len > 0 -> argv.[0]
    | _ -> failwithf "topic sux"

let getRouter (argv : string []) = 
    match argv.Length with
    | len when len > 1 -> new BrokerRouter(new KafkaOptions(new Uri(argv.[1])))
    | _ -> failwithf "url sux"

let produceWith (producer : Producer) topic messages = 
    try 
        producer.SendMessageAsync(topic, messages)
        |> Async.AwaitTask
        |> ignore
    with
    | :? System.AggregateException as ex -> 
        for ix in ex.InnerExceptions do
            ix.InnerException.Message |> printMe
    | ex -> printMe ex.Message

let rec readLine callback = 
    let line = Console.ReadLine()
    if (line <> null) then 
        callback line
        readLine callback

[<EntryPoint>]
let main argv = 
    let topic = getTopic argv
    let router = getRouter argv
    let producer = new Producer(router)
    try 
        readLine (fun x -> [ new Message(x) ] |> produceWith producer topic)
    finally
        producer.Dispose()
    if argv.Length = 1 then Console.ReadKey() |> ignore
    0 // return an integer exit code
