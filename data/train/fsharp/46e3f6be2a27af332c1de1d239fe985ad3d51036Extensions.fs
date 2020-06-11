namespace UIAQuery

[<System.Runtime.CompilerServices.Extension>]
module Extensions =
    open System.Windows.Automation
    open System.Threading

    type EventHandle(wait_handle : WaitHandle, on_event) =  
        member this.WaitForEvent() =
            wait_handle.WaitOne() |> ignore
            wait_handle.Dispose()
            on_event()

    [<System.Runtime.CompilerServices.Extension>]
    let PrepareOneTimeEvent (element : AutomationElement) (event_id : AutomationEvent) (scope : TreeScope) =
        let event_handle = new AutoResetEvent(false)
        
        let on_event = AutomationEventHandler(fun x y -> event_handle.Set() |> ignore)

        Automation.AddAutomationEventHandler(event_id, element, scope, on_event)

        EventHandle(event_handle, fun () -> Automation.RemoveAutomationEventHandler(event_id, element, on_event))
        

