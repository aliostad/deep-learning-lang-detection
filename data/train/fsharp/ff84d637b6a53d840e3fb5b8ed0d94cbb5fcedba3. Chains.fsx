#load "SetupThespian.fsx"

open System
open System.Timers
open System.Diagnostics
open MBrace.Core
open MBrace.Thespian

let cluster = createLocalCluster(4)

let processTimer fn timeout =
    let t = new Timer()
    t.Interval <- timeout
    t.Elapsed.Add(fun x -> fn(x))
    t.Start()
    t

let processShower =
    processTimer (fun x -> cluster.ShowProcesses()) 5000.0

processShower.Enabled <- false

// 1. You can easily call one workflow from within another one
let helloCloud = cloud { return "Hello" }
let worldCloud = cloud { return "World" }

// Inside of a cloud { }, we can simply use let! to "unwrap" the result of the child cloud
// process without needing to e.g. call cluster.Run. This is a similar model to async / await
// in C# (which itself is modelled on async { } in F#).
let sentence =
    cloud {
        // use let! to unwrap from Cloud<string> to just string
        // this is like async / await "unwrapping" Task<string> to just string
        let! hello = helloCloud
        let world = "" // get the value of "worldCloud" here
        return hello + " " + world
    } |> cluster.Run // outside of cloud { } we need to call cluster.Run to "unwrap" the result.

// We can also do this across processes that have already started. Let's start to processes on the cluster and get a handle to them...
let helloProcess = cloud { printfn "HELLO!"; return "Hello" } |> cluster.CreateProcess
let worldProcess = cloud { printfn "WORLD!"; return "World" } |> cluster.CreateProcess

// Now we can get those results within a third cloud { } - even though all three might be
// running on different nodes. MBrace will handle all the dirty work for us.
let sentenceTwo =
    cloud {
        printfn "Starting!";
        let! hello = helloProcess |> Cloud.AwaitProcess
        let world = "" // get the value of worldProcess here...
        printfn "Stopping!";
        return hello + " " + world
    } |> cluster.Run

// Look in the console - you'll see that "HELLO!" "WORLD!" and ("Starting!" "Stopping!") all are on different workers.