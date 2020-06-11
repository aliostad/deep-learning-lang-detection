namespace FReactive

open System
open System.Threading
open System.Collections.Concurrent

type SingleActionSynchronizer<'a>(schedulerType, f:'a -> unit) =
   let mutable q = ConcurrentQueue()
   let mutable itemCount = 0
   let mutable item = Unchecked.defaultof<_>

   let processUntilEmpty() =
      let rec processActions processedActionCount =
         let hasItem = q.TryDequeue(&item)
         if hasItem then 
            f item
            processActions (processedActionCount+1)
         else
            item <- Unchecked.defaultof<_>
            let newCount = Interlocked.Add(&itemCount, -processedActionCount)
            if newCount <> 0 then processActions 0
      f item
      let newCount = Interlocked.Decrement &itemCount
      if newCount <> 0 then 
         processActions 0

   let processUntilEmpty =
      match schedulerType with
      | Immediate -> fun () -> processUntilEmpty()
      | OnThreadPool -> 
         let callback = WaitCallback(fun _ -> processUntilEmpty())
         fun () -> ThreadPool.QueueUserWorkItem callback |> ignore<bool>
      | OnCustomScheduler schedule ->
         schedule processUntilEmpty

   let doOrEnqueue i =
      let newItemCount = Interlocked.Increment &itemCount
      let isFirstItem = newItemCount = 1
      if isFirstItem then 
         item <- i
         processUntilEmpty()
      else q.Enqueue i

   member __.Enqueue item = doOrEnqueue item

module SingleActionSynchronizer =
   let CreateGeneric (f:Action<_>) = SingleActionSynchronizer(Immediate, f.Invoke)
   let Create (f:Action) = SingleActionSynchronizer(Immediate, f.Invoke)

type ActionSynchronizer(schedulerType) =
   let sync = SingleActionSynchronizer(schedulerType)
   member __.Enqueue f = sync.Enqueue f
   member __.EnqueueAction (f:Action) = sync.Enqueue  f.Invoke

open System.Collections.Generic

type ValueTuple<'a, 'b> =
   struct
      val A: 'a
      val B: 'b
      new (a, b) = { A=a; B=b }
   end

type MultipleActionSynchronizer<'a, 'b>(schedulerType, f:'a -> unit, g:'b -> unit) =
   let sync = 
      SingleActionSynchronizer(schedulerType, fun (keyValue:KeyValuePair<_,_>) ->
         let functionNumber = keyValue.Key
         let argument:ValueTuple<_,_> = keyValue.Value
         match functionNumber with
         | 0 -> f argument.A
         | 1 -> g argument.B
         | _ -> invalidOp "Expected number between 0 and 1 (inclusive).")

   member __.EnqueueA x = sync.Enqueue <| KeyValuePair<_,_>(0, ValueTuple(x, Unchecked.defaultof<_>))
   member __.EnqueueB y = sync.Enqueue <| KeyValuePair<_,_>(1, ValueTuple(Unchecked.defaultof<_>, y))

type MutuallyRecursiveActionSynchronizer<'a, 'b>
      (  schedulerType,
         f:MutuallyRecursiveActionSynchronizer<'a, 'b> -> 'a -> unit, 
         g:MutuallyRecursiveActionSynchronizer<'a, 'b> -> 'b -> unit  ) as this =
   let f = f this
   let g = g this
   let sync = MultipleActionSynchronizer<'a, 'b>(schedulerType, f, g)
   member __.EnqueueA x = sync.EnqueueA x
   member __.EnqueueB y = sync.EnqueueB y

type ValueTuple<'a, 'b, 'c> =
   struct
      val A: 'a
      val B: 'b
      val C: 'c
      new (a, b, c) = { A=a; B=b; C=c }
   end

type MultipleActionSynchronizer<'a, 'b, 'c>(schedulerType, f:'a -> unit, g:'b -> unit, h:'c -> unit) =
   let sync = 
      SingleActionSynchronizer(schedulerType, fun (keyValue:KeyValuePair<_,_>) ->
         let functionNumber = keyValue.Key
         let argument:ValueTuple<_,_,_> = keyValue.Value
         match functionNumber with
         | 0 -> f argument.A
         | 1 -> g argument.B
         | 2 -> h argument.C
         | _ -> invalidOp "Expected number between 0 and 2 (inclusive).")
   member __.EnqueueA x = sync.Enqueue <| KeyValuePair(0, ValueTuple<_,_,_>(x, Unchecked.defaultof<_>, Unchecked.defaultof<_>))
   member __.EnqueueB y = sync.Enqueue <| KeyValuePair(1, ValueTuple<_,_,_>(Unchecked.defaultof<_>, y, Unchecked.defaultof<_>))
   member __.EnqueueC z = sync.Enqueue <| KeyValuePair(1, ValueTuple<_,_,_>(Unchecked.defaultof<_>, Unchecked.defaultof<_>, z))
    