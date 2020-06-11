module EventStreams

//open System
//open System.Threading
//
///// create a timer and register an event handler,
///// then run the timer for five seconds
//let createTimer timerInterval eventHandler =
//    // setup a timer
//    let timer = new System.Timers.Timer(float timerInterval)
//    timer.AutoReset <- true
//
//    // add an event handler
//    timer.Elapsed.Add eventHandler
//    
//    // return an async task
//    async {
//        // start timer...
//        timer.Start()
//        // ...run for five seconds
//        do! Async.Sleep 5000
//        // ... and stop
//        timer.Stop()
//    } 
//
/////test it
//let basicHandler _ = printfn "tick %A" DateTime.Now
//
////register the handler
//let basicTimer1 = createTimer 1000 basicHandler
//
//// run the task now
//Async.RunSynchronously basicTimer1
open System
open System.Threading
/// create a timer and register an event handler,
/// then run the timer for five seconds
let createTimerAndObservable timerInterval =
    // setup a timer
    let timer = new System.Timers.Timer(float timerInterval)
    timer.AutoReset <- true

    // events are automatically IOservable
    let observable = timer.Elapsed
    
    // return an async task
    let task = async {
        // start timer...
        timer.Start()
        // ...run for five seconds
        do! Async.Sleep 5000
        // ... and stop
        timer.Stop()
    } 

    // return a async task and the observable
    (task,observable)

///// test it
//// create the timer and the corresponding observable
//let basicTimer2, timerEventStream = createTimerAndObservable 1000
//
////register that everytime something happen on
//// the event stream, print the time.
//timerEventStream 
//|> Observable.subscribe (fun _ -> printfn "tick %A" DateTime.Now)
//|> ignore
//
//// run the task now
//Async.RunSynchronously basicTimer2

/// test it
// create the timer and the corresponding observable
let timerCount, timerEventStream = createTimerAndObservable 500

//register that everytime something happen on
// the event stream, print the time.
timerEventStream 
|> Observable.scan (fun count _ -> count + 1) 0
|> Observable.subscribe (fun count -> printfn "timer ticked with count %i" count)
|> ignore

// run the task now
Async.RunSynchronously timerCount