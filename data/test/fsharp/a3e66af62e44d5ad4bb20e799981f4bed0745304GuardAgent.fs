namespace RunMany

module GuardAgent = 
    open Model
    open System
    open System.Threading
    open System.Threading.Tasks

    type private Event = 
        | Command of Command
        | Recover of Guid
        | Finished

    type private State = 
        | Working
        | Crashed of Guid
        | Stopped

    let private guard name arguments (inbox: Agent<_>) = async {
        let delay (ms: int) = Task.Delay(ms)
        let push event = inbox.Post event
        let postpone (task: Task) event = task.ContinueWith(fun _ -> push event) |> ignore
        let await proc = postpone (proc |> Process.wait) Finished

        let rec loop state proc = 
            async {
                let! event = inbox.Receive ()
                match state, event with
                | _, Command Quit -> quit proc
                | _, Command Kill -> do! stop proc
                | Stopped, Finished -> do! loop state proc
                | Working, Command Start -> do! loop state proc
                | _, Command (Start | Reboot) -> do! start proc
                | Working, Finished -> do! recover ()
                | Crashed gc, Recover gr when gc = gr -> do! start proc
                | _ -> do! unhandled state event proc
            }
        and start proc = 
            printfn "START"
            Process.kill proc
            loop Working (arguments |> Process.exec |> tap await)
        and stop proc = 
            printfn "STOP"
            Process.kill proc
            loop Stopped None
        and recover () = 
            printfn "RECOVER"
            let guid = Guid.NewGuid ()
            postpone (delay 5000) (Recover guid)
            loop (Crashed guid) None
        and quit proc = 
            printfn "QUIT"
            Process.kill proc
        and unhandled state event proc = 
            printfn "Unhandled state/event (%A, %A)" state event
            loop state proc

        do! loop Stopped None
    }

    let createGuard name arguments =
        let agent = Agent.Start (guard name arguments)
        fun command -> agent.Post (Command command)
