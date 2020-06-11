open System

let processes = 5
let rand = new Random()
let timeProcesses = [|for i in 0..processes - 1 -> rand.Next(10000)|]

let stateArray = [|for i in 0..processes - 1 -> false|]

let printProcesses i = 

    lock stateArray (fun() -> stateArray.[i] <- true
                              if (Array.forall(fun x -> x = true) stateArray.[0..i]) then 
                                printfn "Finished process №%A" (i + 1)
                                if i < processes then 
                                  let mutable j = i + 1
                                  while (j < processes && stateArray.[j]) do
                                    printfn "Finished process №%A" (j + 1)
                                    j <- j + 1
                    )

let asyncProcess i =
    async {
        do! Async.Sleep(timeProcesses.[i])
        printProcesses i
    }

let asyncProcesses = [for i in 0..processes - 1 -> asyncProcess i]

for i in 0..processes - 1 do printfn "Process number %A works %A seconds" (i + 1) timeProcesses.[i]

asyncProcesses |> Async.Parallel |> Async.RunSynchronously |> ignore