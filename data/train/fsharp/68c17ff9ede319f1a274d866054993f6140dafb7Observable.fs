namespace FileSorter.Core  //Microsoft.FSharp.Control

open System
open System.Runtime.ExceptionServices
open System.Threading.Tasks
open System.Threading


    module ObservableEx =
        
        // TODO extract into TaskEx class
        let isFinished (task: Task) =
            task.IsCanceled = true || task.IsCompleted = true || task.IsFaulted = true

        let subscribe onNext onCompleted onError (observable: IObservable<'a>) =
            observable.Subscribe(
                {new IObserver<_> with
                    member x.OnCompleted() =
                        onCompleted()
                    member x.OnNext v =
                        onNext(v)
                    member x.OnError er =
                        onError er})

        let collect mapping (observable: IObservable<'a>) =
            let s = Subject<_>()
            observable.Subscribe(
                {new IObserver<_> with
                    member x.OnCompleted() =
                        s.Completed()
                    member x.OnNext v =
                        let r = mapping(v)
                        Seq.iter (fun v -> s.Next(v)) r
                    member x.OnError er =
                        s.Error er}) 
                |> ignore
            
            s :> IObservable<_>


        // TODO it seems reasonable encapsulate the mapping between
        // IObservable of 'a to IObservable of Task<'b> into separate method
        // because we could manage throughput here.
        // Like for CPU intensive operations we should use 4 simultaneous tasks
        // in one time, but for IO intensive operations we could have much more.
        let toTasks mapping (observable: IObservable<'a>) : IObservable<Task<'b>> =
            Observable.map (fun d -> mapping d) observable


        let processOneByOne2 (selector: 'a -> Task<'b>) (observable: IObservable<'a>) : IObservable<'a> =
            let subject = Subject<'a>()
            let completed = ref false
            let taskCount = ref 0
            let finishedTaskCount = ref 0

            let checkAndFireOnCompleted() =
                if completed.Value = true && finishedTaskCount.Value = taskCount.Value then
                    subject.Completed()

            observable.Subscribe(
                {new IObserver<_> with
                    member x.OnCompleted() =
                        completed := true
                        checkAndFireOnCompleted()
                    member x.OnNext (v: 'a) =
                        Interlocked.Increment(taskCount) |> ignore
                        let tsk = selector v
                        //taskCount := taskCount.Value + 1
                        // TODO I'm not sure, but Rx contract for OnNext is following
                        // We should not call next "OnNext" before previous one is not finished
                        // Check whether current Subject type supports this contract
                       
                        // For finished tasks we can fire it further right away
                        if isFinished tsk then
                            Interlocked.Increment(finishedTaskCount) |> ignore
                            subject.Next v
                        else
                            // TODO: interestingly, why I should specify ft's type explicitely?!?!?!?
                            tsk.ContinueWith(fun (ft: Task<'b>) -> 
                                printfn "task finished"
                                Interlocked.Increment(finishedTaskCount) |> ignore
                                subject.Next v
                                checkAndFireOnCompleted()
                                ) |> ignore

                        ()
                    member x.OnError er =
                        subject.Error er})
                |> ignore

            subject :> IObservable<_>

        /// Converts sequence of non-finished tasks into the sequence of completed tasks
        let processOneByOne (observable: IObservable<Task<'a>>) : IObservable<Task<'a>> =
            let subject = Subject<_>()
            let completed = ref false
            let taskCount = ref 0
            let finishedTaskCount = ref 0

            let checkAndFireOnCompleted() =
                if completed.Value = true && finishedTaskCount.Value = taskCount.Value then
                    subject.Completed()

            observable.Subscribe(
                {new IObserver<_> with
                    member x.OnCompleted() =
                        completed := true
                        checkAndFireOnCompleted()
                    member x.OnNext (v: Task<'a>) =
                        Interlocked.Increment(taskCount) |> ignore
                        //taskCount := taskCount.Value + 1
                        // TODO I'm not sure, but Rx contract for OnNext is following
                        // We should not call next "OnNext" before previous one is not finished
                        // Check whether current Subject type supports this contract
                       
                        // For finished tasks we can fire it further right away
                        if isFinished v then
                            Interlocked.Increment(finishedTaskCount) |> ignore
                            subject.Next v
                        else
                            // TODO: interestingly, why I should specify ft's type explicitely?!?!?!?
                            v.ContinueWith(fun (ft: Task<'a>) -> 
                                printfn "task finished"
                                Interlocked.Increment(finishedTaskCount) |> ignore
                                subject.Next ft
                                checkAndFireOnCompleted()
                                ) |> ignore

                        ()
                    member x.OnError er =
                        subject.Error er})
                |> ignore

            subject :> IObservable<_>


        /// Simple trasformer from sequence to observable.
        /// Transformation peformed asynchronously.
        let fromSeq (s: 'a seq) =
            let subject = Subject<_>()
            
            let a = async {
                let completed = ref false
                try
                    for v in s do
                        subject.Next v
                    
                    completed := true
                with
                    | e -> subject.Error e

                // We can't call subject.Completed() from the try block,
                // because potentially this call could fail and in this case
                // we would call subject.Error
                if completed.Value = true then
                    subject.Completed()
            }

            Async.Start a

            subject :> IObservable<_>

        let toSeq (observable: IObservable<'a>) =
            // TODO: take a look at Rx implementation!
            let maxCapacity = 42
            let queue = new System.Collections.Concurrent.BlockingCollection<_>(maxCapacity)
            // TODO: is there any functional solution for this?
            let (e: ExceptionDispatchInfo option ref) = ref None
            
            observable.Subscribe(
                {new IObserver<_> with
                    member x.OnCompleted() =
//                        printfn "OnCompleted"
                        queue.CompleteAdding()
                    member x.OnNext v =
                        queue.Add v
                    member x.OnError er =
                        e := Some(ExceptionDispatchInfo.Capture(er))
                        queue.CompleteAdding()})
                |> ignore

            seq { 
                for v in queue.GetConsumingEnumerable() -> v
                // TODO: Check latest Rx impl, because on 4.0 framework their behavior is not perfect
                // (they throw original exception screwing original call stack)
                if e.Value.IsSome then
                    e.Value.Value.Throw()
            }

        let toArray (observable: IObservable<'a>) =
            toSeq observable |> Seq.toArray 

        let toList (observable: IObservable<'a>) =
            toSeq observable |> Seq.toList


