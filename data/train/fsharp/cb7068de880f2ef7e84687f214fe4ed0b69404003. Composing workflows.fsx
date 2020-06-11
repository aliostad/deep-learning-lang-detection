#load "SetupThespian.fsx"

open System
open System.Diagnostics
open MBrace.Core
open MBrace.Thespian

// 1. Let's start by looking at how we compose "async" workflows in F#: -

let helloAsync = async { return "Hello" }
let worldAsync = async { return "World" }
let sentenceAsync = async {
    (* "unwrap" the async<string> -> string. Roughly equivalent to:
       var hello = await helloTask i.e. "unwrap" Task<string> -> string *)
    let! hello = helloAsync
    let! world = worldAsync
    return sprintf "%s %s" hello world }

// We "run" the workflow by sending it to the thread pool and block
let textFromAsync = sentenceAsync |> Async.RunSynchronously

// 1.1 - What happens if you remove the "!" from one of the let! above?

(* 2. Let's try and do the same thing as above but this time from a cluster.
   You can easily call one workflow from within another one just like above in order
   to compose more powerful workflows. *)
let cluster = createLocalCluster(4)

let helloCloud = cloud { return "Hello" }
let worldCloud = cloud { return "World" }

(* When we use let! on a cloud { }, this will "start" the child computation and wait
   asynchronously for the result. *)
let sentenceCloud = cloud {
    (* use let! to unwrap from Cloud<string> to just string
       this is like async / await "unwrapping" Task<string> to just string *)
    let! hello = helloCloud
    let! world = worldCloud
    return sprintf "%s %s" hello world }
    
// Outside of cloud { } we need to call cluster.Run to "unwrap" the result.
let textFromCloud = sentenceCloud |> cluster.Run

(* IMPORTANT: Inside cloud { } you never need to call cluster.Run - just use
   let! (or if there is no result, you can use do!) *)


// We can also do this across processes that have already started. Let's start to processes on the cluster and get a handle to them...
let helloProcess = cloud { printfn "HELLO!"; return "Hello" } |> cluster.CreateProcess
let worldProcess = cloud { printfn "WORLD!"; return "World" } |> cluster.CreateProcess

(* Now we can get those results within a third cloud { } - even though all three might be
   running on different nodes. MBrace will handle all the dirty work for us. *)

// Look in the console - you'll see that "HELLO!" "WORLD!" and ("Starting!" "Stopping!") all are on different workers.

let sentenceTwo =   
    cloud {
        printfn "Starting!";

        (* You can only "let!" on a Cloud<T>. So you have to "convert" (or "lift") from a
           CloudProcess<T> to a Cloud<T> using Cloud.AwaitProcess. *)
        let! hello = helloProcess |> Cloud.AwaitProcess        
        let world = "" // get the value of worldProcess here...

        printfn "Stopping!";
        return hello + " " + world
    } |> cluster.Run