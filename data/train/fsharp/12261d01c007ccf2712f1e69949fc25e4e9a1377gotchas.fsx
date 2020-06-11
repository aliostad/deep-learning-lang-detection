
#load "credentials.fsx"

open System
open System.IO
open MBrace
open MBrace.Azure
open MBrace.Azure.Client
open MBrace.Workflows
open MBrace.Flow



let cluster = Runtime.GetHandle(config)
cluster.AttachClientLogger(ConsoleLogger())

cluster.ShowProcesses()
cluster.ShowWorkers()
cluster.ShowLogs()

// closures and non-serializable objects

let test1 = 
    cloud {
        let client = new System.Net.WebClient()
        let! result = Cloud.Parallel [| cloud { return client.DownloadString("www.fsharp.org") } |]
        return result
    }

let proc1 = cluster.CreateProcess(test1)

proc1.AwaitResult()

// closures and big data

let test2 = 
    cloud {
        let data = [|1..10000000|]
        let! result =
            [|1..100|]
            |> Array.map (fun _ -> cloud { return data.Length }) 
            |> Cloud.Parallel 
        return result
    }

let proc2 = cluster.CreateProcess(test2)

proc2.AwaitResult()



// closures identity

let test3 = 
    cloud {
        let data = [|1..10000000|]
        let! data' = Cloud.Parallel [| cloud { return data } |]
        return Object.ReferenceEquals(data, data') 
    }

let proc3 = cluster.CreateProcess(test3)

proc3.AwaitResult()