open System
open System.Threading

let createTimer interval handler =
    let timer = new System.Timers.Timer(float interval)
    timer.AutoReset <- true

    timer.Elapsed.Add handler

    async {
        timer.Start()
        do! Async.Sleep 5000
        timer.Stop()
    }

let createTimerAndObservable interval =
    let timer = new System.Timers.Timer(interval)
    timer.AutoReset <- true
    let observable = timer.Elapsed

    let task = async {
        timer.Start()
        do! Async.Sleep 5000
        timer.Stop()
    }

    (task, observable)

type ImperativeTimerCount () =
    let mutable count = 0
    member this.handleEvent _ = 
        count <- count + 1
        printfn "Tick %i" count

let handler = new ImperativeTimerCount()
let timerCount1 = createTimer 500 handler.handleEvent
Async.RunSynchronously timerCount1

let timerCount2, timerEventStream = createTimerAndObservable 500.0

timerEventStream
|> Observable.scan (fun count _ -> count + 1) 0
|> Observable.subscribe (fun count -> printfn "Tick %i" count)

Async.RunSynchronously timerCount2
