#load "Common.fsx"

open System
open System.Text
open System.Threading.Tasks
open Microsoft.Azure.ServiceBus

let receiveMessages () =
    let client = Common.createQueueClient ()

    let handler (message: Message) = async {
        printfn
            "Received message with SequenceNumber: %d Body: %s"
            message.SystemProperties.SequenceNumber
            (message.Body |> Encoding.UTF8.GetString)
        return! message.SystemProperties.LockToken |> client.CompleteAsync |> Async.AwaitTask
    }

    client.RegisterMessageHandler(
        (fun msg _ -> msg |> handler |> Async.StartAsTask :> Task),
        MessageHandlerOptions(MaxConcurrentCalls = 1, AutoComplete = false))

    client

let client = receiveMessages ()
Async.Sleep 2000 |> Async.RunSynchronously
client.CloseAsync() |> Async.AwaitTask |> Async.RunSynchronously