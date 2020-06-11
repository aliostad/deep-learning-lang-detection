namespace Microsoft.FSharp.Control

open System
open System.Threading.Tasks
open System.Runtime.CompilerServices

// FSharpTaskPartialComputation<'T> and FSharpTaskPartialComputationAwaiter<'T>:
//   These types manage state both real (resulted) value,
//   exiting state and related native task.
//   FSharpTaskPartialComputation<'T> has native task typed
//   "Task<'T * bool>" instead "Task<'T>."
//   Because bool value indicate exiting process from expression to outside.
//   (Both "return" and "returnFrom" constructed and finally unwrap to ValueTask<'T> at "run".)

[<Struct>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTaskPartialResult<'T> = internal {
    Value: 'T
    Exiting: bool
}

/// FSharpTaskPartialComputation's awaiter.
[<Struct>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTaskPartialComputationAwaiter<'T> internal (task: Task<FSharpTaskPartialResult<'T>>) =

    member __.IsCompleted =
        task.IsCompleted
    member __.IsCompletedSuccessfully =
        task.IsCompleted && not task.IsCanceled && not task.IsFaulted
    member __.IsCanceled =
        task.IsCanceled
    member __.IsFaulted =
        task.IsFaulted

    /// This method return truly 'T value, but will lose exiting state.
    /// You can use parent FSharpTaskPartialComputation instance instead.
    [<Obsolete("You lost computation exiting state.")>]
    member __.GetResult() =
        task.Result.Value
    
    // Internal members make inlining for performance improvements.
    member inline internal __.InternalIsCompletedSuccessfully =
        task.IsCompleted && not task.IsCanceled && not task.IsFaulted
    member inline internal __.InternalGetResult() =
        task.Result
    member inline internal __.InternalOnCompleted(continuation: Task<FSharpTaskPartialResult<'T>> -> unit) =
        task.ContinueWith(new Action<Task<FSharpTaskPartialResult<'T>>>(continuation)) |> ignore

    member __.UnsafeOnCompleted(action: Action) =
        task.ContinueWith(new Action<Task<FSharpTaskPartialResult<'T>>>(fun _ -> action.Invoke())) |> ignore
    member __.OnCompleted(action: Action) =
        task.ContinueWith(new Action<Task<FSharpTaskPartialResult<'T>>>(fun _ -> action.Invoke())) |> ignore

    /// Get printer friendly task status.
    override __.ToString() =
        FSharpTaskPartialComputation<'T>.ToString(task)

    interface ICriticalNotifyCompletion with
        member __.UnsafeOnCompleted(action) =
            task.ContinueWith(new Action<Task<FSharpTaskPartialResult<'T>>>(fun _ -> action.Invoke())) |> ignore
        member __.OnCompleted(action) =
            task.ContinueWith(new Action<Task<FSharpTaskPartialResult<'T>>>(fun _ -> action.Invoke())) |> ignore
and
    /// Temporary task holder for F# computation expression.
    [<Struct>]
    [<NoEquality; NoComparison; AutoSerializable(false)>]
    FSharpTaskPartialComputation<'T> private (result: 'T, exiting: bool, task: Task<FSharpTaskPartialResult<'T>>) =

        /// Construct with already completed task with a value.
        internal new (result: 'T, exiting: bool) =
            FSharpTaskPartialComputation<'T>(result, exiting, Unchecked.defaultof<_>)
        /// Construct with associated native task.
        internal new (task: Task<FSharpTaskPartialResult<'T>>) =
            FSharpTaskPartialComputation<'T>(Unchecked.defaultof<_>, false, task)

        // Internal members make inlining for performance improvements.
        member inline internal __.InternalIsCompletedSuccessfully =
            if task <> Unchecked.defaultof<_> then
                task.IsCompleted && not task.IsCanceled && not task.IsFaulted
            else true
        member inline internal __.InternalIsCompleted =
            if task <> Unchecked.defaultof<_> then
                task.IsCompleted
            else true
        member inline internal __.InternalGetResult() =
            if task <> Unchecked.defaultof<_> then task.Result
            else { Value = result; Exiting = exiting }
        member inline internal this.InternalGetAwaiter() =
            FSharpTaskPartialComputationAwaiter<'T>(task)

        //member __.IsCompleted = task.IsCompleted
        //member __.IsCompletedSuccessfully = task.IsCompletedSuccessfully
        //member __.IsCanceled = task.IsCanceled
        //member __.IsFaulted = task.IsFaulted

        /// Get task related awaiter.
        //member this.GetAwaiter() =
        //    FSharpTaskPartialComputationAwaiter<'T>(task.GetAwaiter())
            
        static member internal ToString(task: Task<FSharpTaskPartialResult<'T>>) : string =
            if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
                let result = task.Result
                sprintf "Finished: Result=%A%s" result.Value (if result.Exiting then " (Exiting computation)" else "")
            else
                sprintf "Running: Id=%d" (task.Id)

        /// Get printer friendly task status.
        override __.ToString() =
            FSharpTaskPartialComputation<'T>.ToString(task)

/// F# task.
[<Struct>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTask<'T> private (result: 'T, expr: unit -> FSharpTaskPartialComputation<'T>) =
    internal new (result: 'T) = FSharpTask<'T>(result, Unchecked.defaultof<unit -> FSharpTaskPartialComputation<'T>>)
    internal new (expr: unit -> FSharpTaskPartialComputation<'T>) = FSharpTask<'T>(Unchecked.defaultof<'T>, expr)
    
    /// Construct computation.
    member internal __.InternalCreate() : FSharpTaskPartialComputation<'T> =
        if (expr :> obj) = null then
            FSharpTaskPartialComputation<'T>(result, false)
        else
            expr()

    /// Construct value task.
    member internal __.InternalCreateValueTask() : ValueTask<'T> =
        if (expr :> obj) = null then
            ValueTask<'T>(result)
        else
            let computation = expr()
            if computation.InternalIsCompletedSuccessfully then
                let result = computation.InternalGetResult()
                ValueTask<'T>(result.Value)
            else
                let tcs = new TaskCompletionSource<'T>()
                let awaiter = computation.InternalGetAwaiter()
                awaiter.InternalOnCompleted(fun _ ->
                    let result = awaiter.InternalGetResult()
                    tcs.SetResult(result.Value))
                ValueTask<'T>(tcs.Task)

/// Internal implementations for FSharpContinuation.
module private FSharpTaskImpl =

    open System
    open System.Collections
    open System.Collections.Generic
    open System.Diagnostics
    open System.Runtime.ExceptionServices

    let inline private createComputationCompletionSource () =
        new TaskCompletionSource<FSharpTaskPartialResult<'T>>()

    let inline private createConst (value: 'T) (exiting: bool) =
        FSharpTaskPartialComputation<'T>(value, exiting)

    let inline private createComputation (task: Task<FSharpTaskPartialResult<'T>>) =
        FSharpTaskPartialComputation<'T>(task)
        
    //////////////////////////////////////////////////////////
    // of

    let inline ofResult (exiting: bool) (result: 'T) =
        createConst result exiting

    let private createComputationFromTask<'T, 'U when 'T :> Task> (task: 'T) (exiting: bool) (extractor: unit -> 'U) : FSharpTaskPartialComputation<'U> =
        let tcs = createComputationCompletionSource()
        task.ContinueWith(new Action<Task>(fun _ ->
            if task.IsCompleted then
                tcs.SetResult({ Value = extractor(); Exiting = exiting })
            elif task.IsCanceled then
                tcs.SetCanceled()
            elif task.IsFaulted then
                tcs.SetException(task.Exception))) |> ignore
        createComputation tcs.Task

    /// Construct task from the native task.
    let ofTaskT (exiting: bool) (task: Task<'T>) =
        // Task can convert to const value already completed (Except raised and canceled.)
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            createConst task.Result exiting
        else
            createComputationFromTask task exiting (fun () -> task.Result)

    /// Construct task from the native non-generic task.
    let ofTask (exiting: bool) (task: Task) =
        // Task can convert to const value already completed (Except raised and canceled.)
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            createConst () exiting
        else
            createComputationFromTask task exiting (fun () -> ())
                
    /// Construct task from the native value task.
    let ofValueTask (exiting: bool) (task: ValueTask<'T>) =
        // Task can convert to const value already completed (Except raised and canceled.)
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            createConst task.Result exiting
        else
            let task = task.AsTask()
            createComputationFromTask task exiting (fun () -> task.Result)

    //////////////////////////////////////////////////////////
    // zero, return, return!
    
    /// Cached zero computation instance.
    [<Sealed; AbstractClass>]
    [<NoEquality; NoComparison; AutoSerializable(false)>]
    type CachedZeroInstance<'T> private () =
        static let instance = createConst Unchecked.defaultof<'T> false
        static member inline Instance = instance

    /// Get zero instance.
    let inline zero<'T> () : FSharpTaskPartialComputation<'T> =
        CachedZeroInstance<'T>.Instance

    /// Begin exiting from expression with a value.
    let inline ``return`` (value: 'T) : FSharpTaskPartialComputation<'T> =
        createConst value true

    /// Begin exiting from expression with computation.
    let returnFrom (computation: FSharpTaskPartialComputation<'T>) : FSharpTaskPartialComputation<'T> =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            createConst result.Value true
        else
            let tcs = createComputationCompletionSource()
            let awaiter = computation.InternalGetAwaiter()
            awaiter.InternalOnCompleted(fun _ ->
                let result = awaiter.InternalGetResult()
                tcs.SetResult({ Value = result.Value; Exiting = true }))
            createComputation tcs.Task

    //////////////////////////////////////////////////////////
    // let!

    /// Bind continuation to computation.
    let bind (binder: 'T -> FSharpTaskPartialComputation<'U>) (computation: FSharpTaskPartialComputation<'T>) : FSharpTaskPartialComputation<'U> =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            // TODO: Is exiting = true, 'T equals 'U??
            let computation = binder result.Value
            if result.Exiting then returnFrom computation
            else computation
        else
            let tcs = createComputationCompletionSource()
            let awaiter = computation.InternalGetAwaiter()
            awaiter.InternalOnCompleted(fun _ ->
                let result = awaiter.InternalGetResult()
                let computation = binder result.Value
                if computation.InternalIsCompletedSuccessfully then
                    let result = computation.InternalGetResult()
                    tcs.SetResult(result)
                else
                    let awaiter = computation.InternalGetAwaiter()
                    awaiter.InternalOnCompleted(fun _ ->
                        let result = awaiter.InternalGetResult()
                        tcs.SetResult(result)))
            createComputation tcs.Task

    //////////////////////////////////////////////////////////
    // use

    /// Bind continuation and will auto dispose.
    let using (binder: 'T -> FSharpTaskPartialComputation<'U>) (resource: 'T :> #IDisposable) : FSharpTaskPartialComputation<'U> =
        let computation = binder resource
        if computation.InternalIsCompletedSuccessfully then
            resource.Dispose()
            let result = computation.InternalGetResult()
            createConst result.Value result.Exiting
        else
            let tcs = createComputationCompletionSource()
            let awaiter = computation.InternalGetAwaiter()
            awaiter.InternalOnCompleted(fun _ ->
                resource.Dispose()
                tcs.SetResult(awaiter.InternalGetResult()))
            createComputation tcs.Task

    //////////////////////////////////////////////////////////
    // combine

    let rec private delayedCombine (secondBody: unit -> FSharpTaskPartialComputation<'T>) (computation: FSharpTaskPartialComputation<'T>) (tcs: TaskCompletionSource<FSharpTaskPartialResult<'T>>) : unit =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                tcs.SetResult(result)
            else
                let computation = secondBody()
                delayedCombine secondBody computation tcs
        else
            let awaiter = computation.InternalGetAwaiter()
            awaiter.InternalOnCompleted(fun _ ->
                let result = awaiter.InternalGetResult()
                if result.Exiting then
                    tcs.SetResult(result)
                else
                    let computation = secondBody()
                    delayedCombine secondBody computation tcs)

    /// Combine computation based expressions.
    let rec combine (secondBody: unit -> FSharpTaskPartialComputation<'T>) (computation: FSharpTaskPartialComputation<'T>) : FSharpTaskPartialComputation<'T> =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                createConst result.Value result.Exiting
            else
                let computation = secondBody()
                combine secondBody computation
        else
            let tcs = createComputationCompletionSource()
            delayedCombine secondBody computation tcs
            createComputation tcs.Task

    //////////////////////////////////////////////////////////
    // while

    let rec private delayedWhile (body: unit -> FSharpTaskPartialComputation<'T>) (guard: unit -> bool) (computation: FSharpTaskPartialComputation<'T>) (tcs: TaskCompletionSource<FSharpTaskPartialResult<'T>>) : unit =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                tcs.SetResult(result)
            elif not (guard()) then
                tcs.SetResult(result)
            else
                let computation = body()
                delayedWhile body guard computation tcs
        else
            if computation.InternalIsCompleted then
                // TODO: handle exn
                Debug.Fail("")
            else
                let awaiter = computation.InternalGetAwaiter()
                awaiter.InternalOnCompleted(fun _ ->
                    let result = awaiter.InternalGetResult()
                    if result.Exiting then
                        tcs.SetResult(result)
                    elif not (guard()) then
                        tcs.SetResult(result)
                    else
                        let computation = body()
                        delayedWhile body guard computation tcs)

    let rec private internalWhile (body: unit -> FSharpTaskPartialComputation<'T>) (guard: unit -> bool) (computation: FSharpTaskPartialComputation<'T>) : FSharpTaskPartialComputation<'T> =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                computation
            elif not (guard()) then
                computation
            else
                let computation = body()
                internalWhile body guard computation
        else
            if computation.InternalIsCompleted then
                // TODO: handle exn
                Debug.Fail("")
            let tcs = createComputationCompletionSource()
            delayedWhile body guard computation tcs
            createComputation tcs.Task

    /// Examine computation based while loop.
    let inline ``while`` (body: unit -> FSharpTaskPartialComputation<'T>) (guard: unit -> bool) : FSharpTaskPartialComputation<'T> =
        internalWhile body guard (zero())

    //////////////////////////////////////////////////////////
    // for

    let rec private delayedForEach (body: 'T -> FSharpTaskPartialComputation<'U>) (enr: IEnumerator<'T>) (computation: FSharpTaskPartialComputation<'U>) (tcs: TaskCompletionSource<FSharpTaskPartialResult<'U>>) : unit =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                enr.Dispose()
                tcs.SetResult(result)
            elif not (enr.MoveNext()) then
                enr.Dispose()
                tcs.SetResult(result)
            else
                let computation = body (enr.Current)
                delayedForEach body enr computation tcs
        else
            if computation.InternalIsCompleted then
                // TODO: handle exn
                Debug.Fail("")
            else
                let awaiter = computation.InternalGetAwaiter()
                awaiter.InternalOnCompleted(fun _ ->
                    let result = awaiter.InternalGetResult()
                    if result.Exiting then
                        enr.Dispose()
                        tcs.SetResult(result)
                    elif not (enr.MoveNext()) then
                        enr.Dispose()
                        tcs.SetResult(result)
                    else
                        let computation = body (enr.Current)
                        delayedForEach body enr computation tcs)

    let rec private internalForEach (body: 'T -> FSharpTaskPartialComputation<'U>) (enr: IEnumerator<'T>) (computation: FSharpTaskPartialComputation<'U>) : FSharpTaskPartialComputation<'U> =
        if computation.InternalIsCompletedSuccessfully then
            let result = computation.InternalGetResult()
            if result.Exiting then
                enr.Dispose()
                computation
            elif not (enr.MoveNext()) then
                enr.Dispose()
                computation
            else
                let computation = body (enr.Current)
                internalForEach body enr computation
        else
            if computation.InternalIsCompleted then
                // TODO: handle exn
                Debug.Fail("")
            let tcs = createComputationCompletionSource()
            delayedForEach body enr computation tcs
            createComputation tcs.Task

    /// Examine computation based for loop.
    let inline forEach (body: 'T -> FSharpTaskPartialComputation<'U>) (sequence: #seq<'T>) : FSharpTaskPartialComputation<'U> =
        internalForEach body (sequence.GetEnumerator()) (zero())

    //////////////////////////////////////////////////////////
    // try-finally

    let tryFinally (body: unit -> FSharpTaskPartialComputation<'T>) (finallyBody: unit -> unit) : FSharpTaskPartialComputation<'T> =
        let computation = body ()
        if computation.InternalIsCompletedSuccessfully then
            finallyBody ()
            computation
        else
            if computation.InternalIsCompleted then
                // TODO: handle exn
                Debug.Fail("")
            let tcs = createComputationCompletionSource()
            let awaiter = computation.InternalGetAwaiter()
            awaiter.InternalOnCompleted(fun _ ->
                let result = awaiter.InternalGetResult()
                finallyBody ()
                tcs.SetResult(result))
            createComputation tcs.Task

    //////////////////////////////////////////////////////////
    // delay, run

    /// Delay examine timing for expression fragment.
    let inline delay (expr: unit -> FSharpTaskPartialComputation<'T>) : unit -> FSharpTaskPartialComputation<'T> =
        expr

    /// Execute partial computation and get F# task.
    let inline run (expr: unit -> FSharpTaskPartialComputation<'T>) : FSharpTask<'T> =
        FSharpTask<'T>(expr)

    //////////////////////////////////////////////////////////
    // ops

    /// Task based sleep.
    let sleep (timeSpan: TimeSpan) =
        ofTask false (Task.Delay(timeSpan))

    /// Execute task and hard wait.
    let runSynchronously (task: ValueTask<'T>) =
        try
            let awaiter = task.GetAwaiter()
            awaiter.GetResult()
        with :? AggregateException as exn ->
            // Unwrap AggregateException and continue with truly stack trace.
            ExceptionDispatchInfo.Capture(exn.InnerException).Throw()
            Unchecked.defaultof<'T>

/// F# task builder.
[<Struct>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTaskBuilder =

    member __.Source(computation: FSharpTaskPartialComputation<'T>) =
        computation
    member __.Source(task: FSharpTask<'T>) =
        task.InternalCreate()
    member __.Source(task: Task<'T>) =
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            FSharpTaskImpl.ofResult false task.Result
        else
            FSharpTaskImpl.ofTaskT false task
    member __.Source(task: Task) =
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            FSharpTaskImpl.ofResult false ()
        else
            FSharpTaskImpl.ofTask false task
    member __.Source(task: ValueTask<'T>) =
        if task.IsCompletedSuccessfully then
            FSharpTaskImpl.ofResult false task.Result
        else
            FSharpTaskImpl.ofValueTask false task
    member __.Source(sequence: #seq<'T>) =
        sequence

    member __.Zero() =
        FSharpTaskImpl.zero()
    member __.Return(value) =
        FSharpTaskImpl.``return`` value
    member __.ReturnFrom(computation) =
        FSharpTaskImpl.returnFrom computation
    member __.Bind(computation, binder) =
        FSharpTaskImpl.bind binder computation
    member __.Using(resource, binder) =
        FSharpTaskImpl.using binder resource
    member __.Combine(computation, secondBody) =
        FSharpTaskImpl.combine secondBody computation
    member __.While(guard, body) =
        FSharpTaskImpl.``while`` body guard
    member __.For(sequence: #seq<'T>, body) =
        FSharpTaskImpl.forEach body sequence
    member __.TryFinally(body, finallyBody) =
        FSharpTaskImpl.tryFinally body finallyBody
    //member __.TryWith(p, cf)         = tryWithExnO cf p

    member __.Delay expr =
        FSharpTaskImpl.delay expr
    member __.Run expr =
        FSharpTaskImpl.run expr

/// F# task builder.
[<AutoOpen>]
module FSharpTaskBuilderModule =

    /// F# task builder.
    let task = FSharpTaskBuilder()

/// F# task manipulators.
[<Sealed; AbstractClass>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTask private () =

    /// Get task from a value.
    static member FromResult (result: 'T) : FSharpTask<'T> =
        FSharpTask<'T>(result)

    static member private onceFactory toComputation task =
        let mutable current = Some task
        FSharpTask<'T>(fun () ->
            match current with
            | Some task ->
                let computation = toComputation false task
                current <- None
                computation
            | None ->
                raise (InvalidOperationException("FSharpTask`1: cannot create multiple tasks.")))
    
    /// Get task from native task.
    static member ToTaskOneTime (task: Task<'T>) : FSharpTask<'T> =
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            FSharpTask<'T>(task.Result)
        else
            FSharpTask.onceFactory FSharpTaskImpl.ofTaskT task

    /// Get task from native non-generic task.
    static member ToTaskOneTime (task: Task) : FSharpTask<unit> =
        if task.IsCompleted && not task.IsCanceled && not task.IsFaulted then
            FSharpTask<unit>(())
        else
            FSharpTask.onceFactory FSharpTaskImpl.ofTask task

    /// Get task from native value task.
    static member ToTaskOneTime (task: ValueTask<'T>) : FSharpTask<'T> =
        if task.IsCompletedSuccessfully then
            FSharpTask<'T>(task.Result)
        else
            FSharpTask.onceFactory FSharpTaskImpl.ofValueTask task

    /// Get native value task from task.
    static member ToValueTask (task: FSharpTask<'T>) : ValueTask<'T> =
        task.InternalCreateValueTask()

    /// Get native value task from task.
    static member ToTask (task: FSharpTask<'T>) : Task<'T> =
        task.InternalCreateValueTask().AsTask()

    /// Get native value task from task.
    static member ToTask (task: FSharpTask<unit>) : Task =
        task.InternalCreateValueTask().AsTask() :> Task

    /// Task based sleep.
    static member Sleep timeSpan =
        FSharpTask<unit>(fun () -> FSharpTaskImpl.sleep timeSpan)

    /// Task based sleep.
    static member Sleep milliseconds =
        FSharpTask<unit>(fun () -> FSharpTaskImpl.sleep (TimeSpan.FromMilliseconds(milliseconds)))
        
    /// Execute computation and hard wait.
    static member RunSynchronously (task: ValueTask<'T>) =
        FSharpTaskImpl.runSynchronously task

    /// Execute task and hard wait.
    static member RunSynchronously (task: FSharpTask<'T>) =
        let task = task.InternalCreateValueTask()
        FSharpTaskImpl.runSynchronously task

/// F# task manipulators of extension method (for C# interop).
[<Sealed; AbstractClass; System.Runtime.CompilerServices.Extension>]
[<NoEquality; NoComparison; AutoSerializable(false)>]
type FSharpTaskExtensions private () =

    /// Get task from native task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToTaskOneTime (task: Task<'T>) : FSharpTask<'T> =
        FSharpTask.ToTaskOneTime task

    /// Get task from native non-generic task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToTaskOneTime (task: Task) : FSharpTask<unit> =
        FSharpTask.ToTaskOneTime task

    /// Get task from native value task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToTaskOneTime (task: ValueTask<'T>) : FSharpTask<'T> =
        FSharpTask.ToTaskOneTime task
        
    /// Get native value task from task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToValueTask (task: FSharpTask<'T>) : ValueTask<'T> =
        task.InternalCreateValueTask()

    /// Get native value task from task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToTask (task: FSharpTask<'T>) : Task<'T> =
        task.InternalCreateValueTask().AsTask()

    /// Get native value task from task.
    [<System.Runtime.CompilerServices.Extension>]
    static member ToTask (task: FSharpTask<unit>) : Task =
        task.InternalCreateValueTask().AsTask() :> Task
