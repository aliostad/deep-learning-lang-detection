namespace React.Android

module private Scheduler =
  open System
  open System.Reactive.Concurrency
  open System.Reactive.Disposables
  open Android.App
  open Android.OS

  type private LooperScheduler (looper: Looper) =
    let handler = new Handler(looper)
    let threadID = looper.Thread.Id

    interface IScheduler with
      member this.Schedule ((state: 'TState), (action: Func<IScheduler, 'TState, IDisposable>)) =
        let mutable isCancelled = false
        let innerDisp = new SerialDisposable()
        innerDisp.Disposable <- Disposable.Empty

        let currentThread = Java.Lang.Thread.CurrentThread().Id

        if threadID = currentThread then 
          action.Invoke(this, state)
        else 
          let handlerCb () = 
            if isCancelled then () 
            else innerDisp.Disposable <- action.Invoke(this, state)
          let handlerAction = Action handlerCb
          handler.Post(handlerAction) |> ignore
          let result = 
            new CompositeDisposable(
              Disposable.Create(fun () -> isCancelled <- true), 
              innerDisp
            )
          result :> IDisposable

      member this.Schedule ((state: 'TState), (dueTime: TimeSpan), (action: Func<IScheduler, 'TState, IDisposable>)) =
        let mutable isCancelled = false

        let innerDisp = new SerialDisposable()
        innerDisp.Disposable <- Disposable.Empty

        let handlerCb () = if isCancelled then () else innerDisp.Disposable <- action.Invoke(this, state)
        let handlerAction = Action handlerCb

        let dueTime = (dueTime.Ticks / (int64 10) / (int64 1000))

        handler.PostDelayed(handlerAction, dueTime) |> ignore

        let result = 
          new CompositeDisposable(
            Disposable.Create(fun () -> isCancelled <- true), 
            innerDisp
          )
        result :> IDisposable

      member this.Schedule (state, dueTime, action) =
        let this = (this :> IScheduler) 

        if dueTime <= this.Now 
        then this.Schedule (state, action)
        else this.Schedule (state, dueTime - this.Now, action)

      member this.Now with get () = DateTimeOffset.Now

  let looperScheduler looper = (new LooperScheduler(looper)) :> IScheduler 
  let mainLoopScheduler = looperScheduler Looper.MainLooper
