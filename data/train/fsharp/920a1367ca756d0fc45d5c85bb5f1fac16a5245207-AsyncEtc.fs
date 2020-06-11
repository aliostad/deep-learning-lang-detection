module _07_AsyncEtc

(* Async workflow *)
open System.IO
let readfile (fileName:string) =
    use sr = new StreamReader(fileName)
    let length = async {
        let! body = Async.AwaitTask (sr.ReadToEndAsync())
        printfn "Finished reading file"
        return body.Length
    }
    printfn "Waiting for file read to complete. Doning "
    printfn "Length is %d" (length |> Async.RunSynchronously)

readfile @"c:\windows\DPINST.LOG"




(* First class events *)
open System
open System.Windows.Forms
let mainForm = new Form()
mainForm.Show()
let button = new Button()
button.Text <- "Click here"
mainForm.Controls.Add(button)
let label = new Label()
label.Top <- button.Height
mainForm.Controls.Add(label)
button.Click |> Event.add(fun e-> label.Text <- "Time is " + DateTime.Now.ToString())
mainForm.MouseMove
    |> Event.filter (fun e-> e.X % 25 = 0)
    |> Event.add (fun e-> label.Text <- sprintf "At x=%i" e.X)


(* Agents *)
open Microsoft.FSharp.Control
type PingPongMessage =
    | Ping of int * PingPongMessage MailboxProcessor
    | Pong of int * PingPongMessage MailboxProcessor

let pinger = MailboxProcessor.Start(fun inbox ->
    let rec handler() = async {
        let! msg = inbox.Receive()
        match msg with
        |Ping(0, _) -> printfn "Last ping"
        |Ping(i, handler) -> printfn "Ping %i" i; handler.Post(Pong(i - 1, inbox))
        |_ -> printfn "Unknown message type"; ()
        return! handler()
    }
    handler()
)


let ponger = MailboxProcessor.Start(fun inbox ->
    let rec handler() = async {
        let! msg = inbox.Receive()
        match msg with
        |Pong(0, _) -> printfn "Last pong"
        |Pong(i, handler) -> printfn "Pong %i" i; handler.Post(Ping(i - 1, inbox)); handler |> ignore
        |_ -> printfn "Unknown message type"; ()
        return! handler()
    }
    handler()
)
pinger.Post(Ping(5, ponger))