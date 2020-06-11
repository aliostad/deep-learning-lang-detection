module EventHandler

open System
open System.Threading

let createTimer timerInterval eventHandler =
    // setup a timer
    let timer = new System.Timers.Timer(float timerInterval)
    timer.AutoReset <- true
    
    // add an event handler
    timer.Elapsed.Add eventHandler

    // return an async task
    async {
        // start timer...
        timer.Start()
        // ...run for five seconds...
        do! Async.Sleep 5000
        // ... and stop
        timer.Stop()
        }

let createTimerAndObservable timerInterval =
    // setup a timer
    let timer = new System.Timers.Timer(float timerInterval)
    timer.AutoReset <- true

    // events are automatically IObservable
    let observable = timer.Elapsed  

    // return an async task
    let task = async {
        timer.Start()
        do! Async.Sleep 5000
        timer.Stop()
        }

    // return a async task and the observable
    (task,observable)

type ImperativeTimerCount() =
    
    let mutable count = 0

    // the event handler. The event args are ignored
    member this.handleEvent _ =
      count <- count + 1
      printfn "timer ticked with count %i" count



[<EntryPoint>]
let main argv = 
//    let basicHandler _ = printfn "tick %A" DateTime.Now
//
//    // register the handler
//    let basicTimer1 = createTimer 1000 basicHandler
//
//    // run the task now
//    Async.RunSynchronously basicTimer1 
    
    
    
    
//    let basicTimer2 , timerEventStream = createTimerAndObservable 1000
//
//    // register that everytime something happens on the 
//    // event stream, print the time.
//    timerEventStream 
//    |> Observable.subscribe (fun _ -> printfn "tick %A" DateTime.Now) |> ignore
//
//    // run the task now
//    Async.RunSynchronously basicTimer2

//    let handler = new ImperativeTimerCount()
//
//    // register the handler method
//    let timerCount1 = createTimer 500 handler.handleEvent
//
//    // run the task now
//    Async.RunSynchronously timerCount1 


    let timerCount2, timerEventStream = createTimerAndObservable 100
    
    // set up the transformations on the event stream
    timerEventStream 
    |> Observable.scan (fun count _ -> count + 4) 56
    |> Observable.subscribe (fun x -> (printfn "timer ticked with count %s" ( x.ToString())))
    |> ignore

    // run the task now
    Async.RunSynchronously timerCount2



    System.Console.WriteLine(true) |> ignore
    System.Console.ReadLine() |> ignore

    0