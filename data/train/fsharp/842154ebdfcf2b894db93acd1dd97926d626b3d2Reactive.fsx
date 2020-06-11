open System
open System.Threading

/// create a timer and register an event handler, 
/// then run the timer for five seconds
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

// create a handler. The event args are ignored
let basicHandler _ = printfn "tick %A" DateTime.Now

// register the handler
let basicTimer1 = createTimer 1000 basicHandler

// run the task now
Async.RunSynchronously basicTimer1 

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

// create the timer and the corresponding observable
let basicTimer2 , timerEventStream = createTimerAndObservable 1000

// register that everytime something happens on the 
// event stream, print the time.
timerEventStream 
|> Observable.subscribe (fun _ -> printfn "tick %A" DateTime.Now)

// run the task now
Async.RunSynchronously basicTimer2

type ImperativeTimerCount() =
    
    let mutable count = 0

    // the event handler. The event args are ignored
    member this.handleEvent _ =
      count <- count + 1
      printfn "timer ticked with count %i" count

// create a handler class
let handler_0 = new ImperativeTimerCount()

// register the handler method
let timerCount1 = createTimer 500 handler_0.handleEvent

// run the task now
Async.RunSynchronously timerCount1 

// create the timer and the corresponding observable
let timerCount2, timerEventStream2 = createTimerAndObservable 500

// set up the transformations on the event stream
timerEventStream2
|> Observable.scan (fun count _ -> count + 1) 0 
|> Observable.subscribe (fun count -> printfn "timer ticked with count %i" count)

// run the task now
Async.RunSynchronously timerCount2

type FizzBuzzEvent = {label:int; time: DateTime}

let areSimultaneous (earlierEvent,laterEvent) =
  let {label=_;time=t1} = earlierEvent
  let {label=_;time=t2} = laterEvent
  t2.Subtract(t1).Milliseconds < 50

type ImperativeFizzBuzzHandler() =
 
  let mutable previousEvent: FizzBuzzEvent option = None
 
  let printEvent thisEvent  = 
    let {label=id; time=t} = thisEvent
    printf "[%i] %i.%03i " id t.Second t.Millisecond
    let simultaneous = previousEvent.IsSome && areSimultaneous (previousEvent.Value,thisEvent)
    if simultaneous then printfn "FizzBuzz"
    elif id = 3 then printfn "Fizz"
    elif id = 5 then printfn "Buzz"
 
  member this.handleEvent3 eventArgs =
    let event = {label=3; time=DateTime.Now}
    printEvent event
    previousEvent <- Some event
 
  member this.handleEvent5 eventArgs =
    let event = {label=5; time=DateTime.Now}
    printEvent event
    previousEvent <- Some event

// create the class
let handler = new ImperativeFizzBuzzHandler()

// create the two timers and register the two handlers
let timer3_0 = createTimer 300 handler.handleEvent3
let timer5_0 = createTimer 500 handler.handleEvent5
 
// run the two timers at the same time
[timer3_0;timer5_0]
|> Async.Parallel
|> Async.RunSynchronously

let timer3, timerEventStream3 = createTimerAndObservable 300
let timer5, timerEventStream5 = createTimerAndObservable 500

// convert the time events into FizzBuzz events with the appropriate id
let eventStream3  = 
   timerEventStream3  
   |> Observable.map (fun _ -> {label=3; time=DateTime.Now})
   
let eventStream5  = 
   timerEventStream5  
   |> Observable.map (fun _ -> {label=5; time=DateTime.Now})

// combine the two streams
let combinedStream = 
    Observable.merge eventStream3 eventStream5
 
// make pairs of events
let pairwiseStream = 
   combinedStream |> Observable.pairwise
 
// split the stream based on whether the pairs are simultaneous
let simultaneousStream, nonSimultaneousStream = 
    pairwiseStream |> Observable.partition areSimultaneous

// split the non-simultaneous stream based on the id
let fizzStream, buzzStream  =
  nonSimultaneousStream  
  // convert pair of events to the first event
  |> Observable.map (fun (ev1,_) -> ev1)
  // split on whether the event id is three
  |> Observable.partition (fun {label=id} -> id=3)

//print events from the combinedStream
combinedStream 
|> Observable.subscribe (fun {label=id;time=t} -> 
                              printf "[%i] %i.%03i " id t.Second t.Millisecond)
 
//print events from the simultaneous stream
simultaneousStream 
|> Observable.subscribe (fun _ -> printfn "FizzBuzz")

//print events from the nonSimultaneous streams
fizzStream 
|> Observable.subscribe (fun _ -> printfn "Fizz")

buzzStream 
|> Observable.subscribe (fun _ -> printfn "Buzz")

// run the two timers at the same time
[timer3;timer5]
|> Async.Parallel
|> Async.RunSynchronously