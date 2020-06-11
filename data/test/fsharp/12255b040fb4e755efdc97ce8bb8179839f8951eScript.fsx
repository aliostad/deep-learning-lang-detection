// Learn more about F# at http://fsharp.net. See the 'F# Tutorial' project
// for more guidance on F# programming.

#load "MonitoringChannel.fs"
#load "Script.fs"

open System
open Fweeny
open Fweeny.FSharp

// Define your library scripting code here

let queue = seq {
    for x in 1 .. 200 do
        yield x
}
let processData (x: int, monitor: MonitoringChannel) =
    monitor.LogInformation("[Monitor] processingData")

    (x, System.Threading.Thread.CurrentThread.ManagedThreadId)

let log (x, id) =
    printfn "[%O] Processed: %O" id x

let script = new Script<int, int * int>(queue, processData, log, 2)
script.Wait()