




#load "helpers.fsx"

open MBrace
open MBrace.Azure
open MBrace.Azure.Client
open MBrace.Azure.Runtime


let config = 
    { Configuration.Default with
        StorageConnectionString = ""
        ServiceBusConnectionString = "" }


let runtime = Runtime.GetHandle(config)

runtime.ShowWorkers()
runtime.ShowProcesses()
runtime.ShowLogs()

runtime.ClientLogger.Attach(Common.ConsoleLogger())

let proc = 
    cloud {
        let! workers = Cloud.GetAvailableWorkers()
        let! childs = workers |> Array.map (fun worker -> Cloud.StartChild( cloud { return System.Environment.MachineName }, worker)) |> Cloud.Parallel
        return! childs |> Cloud.Parallel
    } |> runtime.CreateProcess

proc.AwaitResult()

let proc = 
    cloud { return System.Environment.MachineName }
    |> runtime.CreateProcess


proc.AwaitResult()

//runtime.GetProcesses() |> Seq.iter (fun proc -> proc.ClearProcessResources())
//Configuration.DeleteResources(config) |> Async.RunSynchronously




//#r "MBrace.Azure.Runtime.Standalone"
//open MBrace.Azure.Runtime.Standalone
//Runtime.WorkerExecutable <- __SOURCE_DIRECTORY__ + "/../../lib/MBrace.Azure.Runtime.Standalone.exe"
//Runtime.Spawn(config, 4)



//let proc = 
//    cloud {
//       // do System.Environment.SetEnvironmentVariable("TMP", "C:\\temp")
//        //do System.Environment.SetEnvironmentVariable("TEMP", "C:\\temp")
//        return System.IO.Path.GetTempPath()
//    } |> runtime.CreateProcess
//
//
//proc.AwaitResult()

open Nessos.Streams
open MBrace.Streams

let xs = 
    [|1..10|]
    |> CloudStream.ofArray
    |> CloudStream.map (fun x -> x * x)
    |> CloudStream.toArray


let ps = runtime.CreateProcess xs
ps.AwaitResult()


let ps1 = runtime.CreateProcess(CloudFile.Enumerate "wiki", name = "enumeratefiles")
let files = ps1.AwaitResult()


let getTop files count =
    files
    |> CloudStream.ofCloudFiles CloudFile.ReadLines
    |> CloudStream.collect Stream.ofSeq 
    |> CloudStream.collect (fun text -> Helpers.splitWords text |> Stream.ofArray |> Stream.map Helpers.wordTransform)
    |> CloudStream.filter Helpers.wordFilter
    |> CloudStream.countBy id
    |> CloudStream.sortBy (fun (_,c) -> -c) count
    |> CloudStream.toArray
    //|> CloudStream.length

let ps = runtime.CreateProcess(getTop files 20, name = "getTop with cloudfiles")
let r = ps.AwaitResult()


let mkCloudArray files =
    cloud {
        let! cloudarray =
            files
            |> CloudStream.ofCloudFiles CloudFile.ReadAllText
            |> CloudStream.collect (fun text -> Helpers.splitWords text |> Stream.ofArray |> Stream.map Helpers.wordTransform)
            |> CloudStream.filter Helpers.wordFilter
            |> CloudStream.toCloudArray
        return! CloudStream.cache cloudarray
    }

let getTop' cloudarray count =
    cloudarray
    |> CloudStream.ofCloudArray
    |> CloudStream.countBy id
    |> CloudStream.sortBy (fun (_,c) -> -c) count
    |> CloudStream.toArray

let caProcess = runtime.CreateProcess(mkCloudArray files, name = "create cloudarray")
let ca = caProcess.AwaitResult()

let ps' = runtime.CreateProcess(getTop' ca 20, name = "getTop with cloudarray")
let r' = ps'.AwaitResult()
