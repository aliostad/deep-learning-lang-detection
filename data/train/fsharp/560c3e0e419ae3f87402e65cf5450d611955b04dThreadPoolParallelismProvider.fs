﻿namespace MBrace.ThreadPool.Internals

open System
open System.Threading
open System.Threading.Tasks

open MBrace.FsPickler

open MBrace.Core
open MBrace.Core.Internals
open MBrace.Runtime.Utils

open MBrace.Runtime
open MBrace.ThreadPool

#nowarn "444"

/// In-Memory WorkerRef implementation
[<AutoSerializable(false); CloneableOnly>]
type ThreadPoolWorker private () =
    static let singleton = new ThreadPoolWorker()
    let name = System.Net.Dns.GetHostName()
    let pid = System.Diagnostics.Process.GetCurrentProcess().Id
    static let cpuClockSpeed = 
        use perfMon = PerformanceMonitor.Start()
        let counters = perfMon.GetCounters()
        counters.MaxClockSpeed

    interface IWorkerRef with
        member __.Hostname = name
        member __.Type = "InMemory worker"
        member __.Id = name
        member __.ProcessorCount = Environment.ProcessorCount
        member __.MaxCpuClock = 
            if cpuClockSpeed.HasValue then cpuClockSpeed.Value 
            else raise <| NotImplementedException("Mono CPU clock speed not implemented.")

        member __.ProcessId = pid
        member __.CompareTo(other : obj) =
            match other with
            | :? ThreadPoolWorker -> 0
            | :? IWorkerRef as wr -> compare name wr.Id
            | _ -> invalidArg "other" "invalid comparand."

    /// Gets a WorkerRef instance that corresponds to the instance
    static member LocalInstance : ThreadPoolWorker = singleton

/// ThreadPool runtime IParallelismProvider implementation
[<Sealed; AutoSerializable(false)>]
type ThreadPoolParallelismProvider private (processId : string, memoryEmulation : MemoryEmulation, logger : ICloudLogger, faultPolicy : FaultPolicy) =

    static let mkNestedCts (ct : ICloudCancellationToken) = 
        ThreadPoolCancellationTokenSource.CreateCancellationTokenSource(ct) :> ICloudCancellationTokenSource

    /// <summary>
    ///     Creates a new threadpool runtime instance.
    /// </summary>
    /// <param name="logger">Logger for runtime. Defaults to no logging.</param>
    /// <param name="memoryEmulation">Memory semantics used for parallelism. Defaults to shared memory.</param>
    static member Create (logger : ICloudLogger, memoryEmulation : MemoryEmulation) = 
        let processId = mkUUID()
        new ThreadPoolParallelismProvider(processId, memoryEmulation, logger, FaultPolicy.NoRetry)
        
    interface IParallelismProvider with
        member __.CreateCancellationTokenSource (parents : ICloudCancellationToken[]) = async {
            return ThreadPoolCancellationTokenSource.CreateCancellationTokenSource parents :> _
        }

        member __.CloudProcessId = sprintf "In-Memory MBrace computation %s" processId
        member __.WorkItemId = sprintf "TheadId %d" <| System.Threading.Thread.CurrentThread.ManagedThreadId
        member __.Logger = logger
        member __.IsTargetedWorkerSupported = false
        member __.GetAvailableWorkers () = async {
            return [| ThreadPoolWorker.LocalInstance :> IWorkerRef |]
        }

        member __.CurrentWorker = ThreadPoolWorker.LocalInstance :> IWorkerRef

        member __.FaultPolicy = faultPolicy
        member __.WithFaultPolicy newFp = new ThreadPoolParallelismProvider(processId, memoryEmulation, logger, newFp) :> IParallelismProvider

        member __.IsForcedLocalParallelismEnabled = MemoryEmulation.isShared memoryEmulation
        member __.WithForcedLocalParallelismSetting (setting : bool) =
            if setting && memoryEmulation <> MemoryEmulation.Shared then 
                new ThreadPoolParallelismProvider(processId, MemoryEmulation.Shared, logger, faultPolicy) :> IParallelismProvider
            else
                __ :> IParallelismProvider

        member __.ScheduleParallel computations = cloud {
            return! Combinators.Parallel(mkNestedCts, memoryEmulation, Seq.map fst computations)
        }

        member __.ScheduleChoice computations = cloud {
            return! Combinators.Choice(mkNestedCts, memoryEmulation, Seq.map fst computations)
        }

        member __.ScheduleLocalParallel computations = Combinators.Parallel(mkNestedCts, MemoryEmulation.Shared, computations)
        member __.ScheduleLocalChoice computations = Combinators.Choice(mkNestedCts, MemoryEmulation.Shared, computations)

        member __.ScheduleCreateProcess (workflow:Cloud<'T>, _ : FaultPolicy, ?cancellationToken:ICloudCancellationToken, ?target:IWorkerRef, ?taskName:string) = cloud {
            ignore taskName
            target |> Option.iter (fun _ -> raise <| new System.NotSupportedException("Targeted workers not supported in In-Memory runtime."))
            let! resources = Cloud.GetResourceRegistry()
            return Combinators.StartAsTask(workflow, memoryEmulation, resources, ?cancellationToken = cancellationToken) :> ICloudProcess<'T>
        }