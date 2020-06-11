#load "SetupThespian.fsx"

open System
open System.Diagnostics
open MBrace.Core
open MBrace.Thespian

(* 1. Spin up a 4 node cluster locally. We'll use this cluster for now for learning about MBrace
   Go to definition of this function - it's just a thin wrapper function around MBrace Thespian.
   No magic (yet) ;) *)
let cluster = createLocalCluster(4)

// 2. Observe details on the cluster. Notice all workers are running on this machine.
cluster.ShowWorkers()

(* 3. Let's create our first computation!
   Note: A computation is *lazily* evaluated. All we have done here is "build" a
   computation; we haven't executed it. To do that we send it to the cluster. *)
let helloWorld = cloud { return "Hello world!" }

(* Mouse over "helloWorld". Notice the type is Cloud<string>, not "string". This is
   somewhat similar to Task<string> i.e. this is executed on a remote machine and must
   be "unwrapped" before you can access the data. *)

// Send the computation to our cluster - actually start the work.
let textProcess = cluster.CreateProcess helloWorld

(* Look at the worker console windows - one will have some text against it carrying out
   the work. *)

// Call this to get latest info on the process
textProcess.ShowInfo()

// Block and get the result. This is the same behaviour as .Result on a Task.
let text = textProcess.Result




// 4 - View process history

// cluster. ???



// 4. Here's another one...
let computation =
    // everything inside "cloud { }" is executed on a worker.
    cloud {
        let p = Process.GetCurrentProcess()
        return "Hello from process ID " + (p.Id.ToString())
    }

(* cluster.Run is like Task.Result - it blocks until the computation completes and
   unwraps the result. Run this a few times; observe that depending on which node the
   computation is sent to, you'll get a different process ID. *)
let answer = cluster.Run computation





// 5. Now one for you....

// Create a cloud computation that calculates the current date and time.
// Just return the time of day.


// 6. Once you are done you can manually kill the cluster: -
cluster.KillAllWorkers()

// If you reset FSI and lose the handle to the cluster, you can just close down the
// worker processes by shutting their windows.