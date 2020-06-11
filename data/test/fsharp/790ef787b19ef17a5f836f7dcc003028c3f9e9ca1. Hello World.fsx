#load "SetupThespian.fsx"

open System
open System.Diagnostics
open MBrace.Core
open MBrace.Thespian

// 1. Spin up a 4 node cluster locally. We'll use this cluster for now for learning about MBrace
let cluster = createLocalCluster(4)

// 2. Observe details on the cluster. Notice all workers are running on this machine.
cluster.ShowWorkers()

// 2a - View process history

cluster.ShowProcesses()

// 3. Let's try our first computation!
let helloWorld = cloud { return "Hello world!" }

// Send the computation to our cluster
let textProcess = cluster.CreateProcess helloWorld

// Look at the workers - one will have some text against it carrying out the work.

// Call this to get latest info on the process
textProcess.ShowInfo()

// Block and get the result
let text = textProcess.Result

// 4. Here's another one...
let computation =
    // everything inside "cloud { }" is executed on a worker.
    cloud {
        let p = Process.GetCurrentProcess()
        return "Hello from process ID " + (p.Id.ToString())
    }

// cluster.Run is like Task.Result - it blocks until the computation completes and
// unwraps the result. Run this a few times; observe that depending on which node the
// computation is sent to, you'll get a different process ID.
let answer = cluster.Run computation

// 5. Now one for you....

// Create a cloud computation that calculates the current date and time. Just return the time of day.

let dateTime =
    cloud {
        return DateTime.UtcNow.TimeOfDay.ToString()
    }

cluster.Run dateTime