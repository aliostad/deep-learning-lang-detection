type VoPair = 
    { v: int; o:int }
    
type Process = 
    { pid: int; parcels: VoPair seq }

type State = 
    { elements: int list; completedProcesses: Process seq }

let duration f = 
    let timer = new System.Diagnostics.Stopwatch()
    timer.Start()
    let returnValue = f()
    printfn "Elapsed Time: %ims" timer.ElapsedMilliseconds
    returnValue

[<EntryPoint>]
let main argv = 
    let seedProcess = {pid = 1; parcels = seq [{v = 3; o = 2}]}

    let nextState state =         
        let nextProcessStep proc = 
            if (proc.pid < 10) then
                { pid = proc.pid + 1; parcels = Seq.append proc.parcels [ { v = 2; o = 1 } ] }
            else 
                proc

        let nxtElements = 
            List.append state.elements [(state.elements |> Seq.last) + 1]

        let nxtCompletedProcesses = 
            Seq.append (state.completedProcesses |> Seq.map nextProcessStep) [seedProcess]

        let nxtState = 
            { elements = nxtElements; completedProcesses = nxtCompletedProcesses  }

        Some (state, nxtState)

    let seedState = { elements = [1]; completedProcesses = seq [seedProcess] }
    let nthState n = 
        seedState |> Seq.unfold nextState |> Seq.nth n 

    printf "nthState 5, " 
    (duration ( fun() -> nthState 5 )) |> ignore
    
    printf "nthState 500, " 
    (duration ( fun() -> nthState 500 )) |> ignore

    printf "nthState 1000, " 
    (duration ( fun() -> nthState 1000 )) |> ignore

    printf "nthState 5000, " 
    (duration ( fun() -> nthState 5000 )) |> ignore

    printf "nthState 10000, " 
    (duration ( fun() -> nthState 10000 )) |> ignore

    System.Console.ReadKey() |> ignore
    0 
