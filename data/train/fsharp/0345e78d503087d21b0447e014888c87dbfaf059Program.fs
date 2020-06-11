(*
    Matvey Bryksin
*)

open System

type Syncer(processes: int) =
    class
    let mutable Queue = [||]
    
    member this.StartCycle() =
        Queue <- [| for i in 0 .. processes - 1 -> false|]
    
    member this.PrintProcess(j: int) =
        lock Queue (fun() -> Queue.[j - 1] <- true
                             if (Array.fold (fun acc elem -> acc && elem) true Queue.[0..j - 1])
                                then printfn "process №%A finished" j
                                     if j < processes 
                                        then let mutable i = j
                                             while (i < processes && Queue.[i]) do
                                                printfn "process №%A finished" (i + 1)
                                                i <- i + 1
                   )
    end

let processes = 10
let cycles = 3
let random = new Random()
let syncer = new Syncer(processes)
let timeProcesses = [for i in 1 .. processes -> random.Next(1,10000)]

let asyncProcess (num: int) =
    async {
        do! Async.Sleep(timeProcesses.[num - 1])
        syncer.PrintProcess(num)
    }

let asyncProcesses = [for i in 1 .. processes -> asyncProcess i] 

for j in 1 .. processes do
    printfn "process №%A time: %A ms" j timeProcesses.[j - 1] 

for j in 1 .. cycles do
    printfn "-------cycle №%A------" j
    syncer.StartCycle()
    asyncProcesses |> Async.Parallel |> Async.RunSynchronously |> ignore