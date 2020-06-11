namespace XaOpenXC
open System

module Logging =

    let private logBuffer = Collections.Generic.LinkedList<string>()
    
    let log t s = 
        lock logBuffer (fun () ->
            if logBuffer.Count > 1000 then logBuffer.RemoveLast()
            logBuffer.AddFirst(sprintf "%A %s : %s" DateTime.Now t s) |> ignore)
            
    let getLog() =
        lock logBuffer (fun () -> 
            let a2 = Array.zeroCreate logBuffer.Count
            logBuffer.CopyTo(a2,0)
            a2)
            
    let clearLog() =
        lock logBuffer (fun () -> logBuffer.Clear())

