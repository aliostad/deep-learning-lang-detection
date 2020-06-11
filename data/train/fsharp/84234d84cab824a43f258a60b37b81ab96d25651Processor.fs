module NCF.AlarmHistory.Processor

open System.Messaging
open CitectAlarmEvent

[<Literal>]
let private CitectAlarmHistoryQueuePath = @".\private$\NCFCitectAlarmHistory"
let private queue = new MessageQueue(CitectAlarmHistoryQueuePath)
queue.Formatter <- new XmlMessageFormatter([|"System.String"|])
let private msg () = string (queue.Receive().Body)

let rec processLoop () : unit = 
    let m = msg()
    let log  = Log.log m
    match m |> msg2record with
    | Ok evt -> DB.manage evt log
    | Error erMsg -> log erMsg
    if m <> "STOP" then processLoop()