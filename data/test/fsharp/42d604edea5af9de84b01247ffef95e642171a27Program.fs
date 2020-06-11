open System

let processes = 5
let rnd       = new Random()
let mutable q = [|for i in 0 .. (processes - 1) -> false|]

let printProcess(i : int) =
    lock q ( fun _ -> q.[i] <- true
                      if (Array.fold (fun a e -> a && e) true q.[0..i])
                      then printfn "Finished process №%A" i
                           if i < processes 
                           then let mutable j = i + 1
                                while (j < processes && q.[j]) do
                                printfn "Finished process №%A" j
                                j <- j + 1
           )

let asyncProcess(i : int) = 
    let time = rnd.Next(1,100)
    printfn "Process №%A will wait %A" i time
    async {
        do! Async.Sleep(time)
        printProcess i   
    }

let asyncProcesses = [for i in 0 .. (processes - 1) -> asyncProcess(i)]     

[<EntryPoint>]
let main _ =
    printfn "------------------------"
    asyncProcesses |> Async.Parallel |> Async.RunSynchronously |> ignore
    printfn "------------------------"
    printfn "Done!"
    Console.ReadKey() |> ignore
    0