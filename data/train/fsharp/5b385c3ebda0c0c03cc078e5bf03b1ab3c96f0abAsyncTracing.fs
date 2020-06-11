// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------

/// This is not very performant and not really required, manage the instances yourself if possible
/// Therefore this module is no longer opened by default
module Yaaf.Logging.AsyncTracing

open System.Diagnostics
open Yaaf.Logging

module internal Helpers =
#if NO_PCL
    type CallContext = System.Runtime.Remoting.Messaging.CallContext
    type BindingFlags = System.Reflection.BindingFlags
#endif
    let inline reraisePreserveStackTrace (e:System.Exception) =
#if NET45
        System.Runtime.ExceptionServices.ExceptionDispatchInfo.Capture(e).Throw()
        raise e
#else
        let remoteStackTraceString = typeof<exn>.GetField("_remoteStackTraceString", BindingFlags.Instance ||| BindingFlags.NonPublic);
        remoteStackTraceString.SetValue(e, e.StackTrace + System.Environment.NewLine);
        raise e
#endif

    let namespaceTracer = new System.Collections.Concurrent.ConcurrentDictionary<string, ITraceSource>()
    let namespaceWarnings = new System.Collections.Concurrent.ConcurrentDictionary<string, unit>()
    let tryGetTraceSourceFromNs (ns:string) =
        match namespaceTracer.TryGetValue(ns) with
        | true, source -> Some source
        | _ -> 
            if namespaceWarnings.TryAdd(ns, ()) then
                Log.globalUnhandledSource.Value.TraceEvent(TraceEventType.Warning, 0, "A TraceSource for the namespace {0} could not be found! You can ignore this warning if you are fine with the fallback TraceSource.", ns)
            None
    let getTraceSourceFromNs (ns:string) =
        match tryGetTraceSourceFromNs (ns) with
        | Some source -> source
        | _ -> Log.globalUnhandledSource.Value
    type AsyncTracerData = 
      { Tracer : ITracer
        /// The namespace of the ITracer, this is only read when ActivityTraceSource is None (which means we reuse the ITracer.TraceSource)
        Namespace : string option
        ActivityId : System.Guid
        ActivityTraceSource : ITraceSource option }
    let getTracerData() =
        match Helper.currentBackend.GetLogicalData ("Yaaf.Logging.AsyncTracing.AsyncTracerData") with
        | null -> None
        | t -> Some (t:?>AsyncTracerData)
    let setTracerData(tracer:AsyncTracerData) =
       Helper.currentBackend.SetLogicalData ("Yaaf.Logging.AsyncTracing.AsyncTracerData", tracer)
    let modifyTracerData f = 
        let c = getTracerData()
        match c with 
        | Some s -> setTracerData (f s)
        | None -> failwith "cannot modify tracer data."

    let getCurrentStack() =
        match Helper.currentBackend.GetLogicalData("Yaaf.Logging.AsyncTracing.AsyncStackTrace") with
        | null -> []
        | t -> t :?> IStackFrame list
    let setCurrentStack(stacktrace:IStackFrame list) =
        Helper.currentBackend.SetLogicalData("Yaaf.Logging.AsyncTracing.AsyncStackTrace", stacktrace)
    let addStack frame = 
        setCurrentStack(frame :: getCurrentStack())
    let removeStack() =
        match getCurrentStack() with
        | h::l -> setCurrentStack (l)
        | [] -> ()
        
    let getFullMethodName (frame:IStackFrame) = 
        let meth = frame.GetMethod()
        let declType = meth.DeclaringType
        let name = meth.Name
        sprintf "%s.%s" declType.FullName name
    let handleRawNamespace (rawNamespace:string) = 
        if (rawNamespace.StartsWith "<StartupCode$") then
            // Try to extract info
            let ``first >`` = rawNamespace.IndexOf (">")
            if (``first >`` + 3 < rawNamespace.Length) then
                // <StartupCode$Yaaf-Xmpp>.$Yaaf.Xmpp
                rawNamespace.Substring(``first >`` + 3)
            else
                // <StartupCode$Yaaf-Xmpp>
                let mid = rawNamespace.IndexOf ("$") + 1
                rawNamespace.Substring(mid, rawNamespace.Length - mid - 1)
                        .Replace("-", ".")
        else
            rawNamespace

    let getNamespace (frame:IStackFrame) = 
        let meth = frame.GetMethod()
        meth.DeclaringType.Namespace
        |> handleRawNamespace

    let getAsyncStackString () =
        getCurrentStack()
        |> Seq.map 
            (fun s -> 
                sprintf "at %s in %s on line %d" (getFullMethodName s) (s.GetFileName()) (s.GetFileLineNumber()))
        |> String.concat "\n\t"
    let getTracerFromActivityOrFallbackNs ns = 
        let data = getTracerData()
        match data with
        | None ->
            let source, ns = 
                match tryGetTraceSourceFromNs ns with
                | Some tracer -> tracer, Some ns
                | None -> 
                    // make sure we dont use the globaltracer the next time (try again next time)
                    Log.globalUnhandledSource.Value, None
            let tracer = Log.DefaultTracer source "root"
            let data = 
              { Namespace = ns
                ActivityId = tracer.ActivityId
                Tracer = tracer
                ActivityTraceSource = None }
            setTracerData data
            tracer
        | Some t -> 
            match t.ActivityTraceSource with
            | None ->
                if t.Namespace.IsSome && t.Namespace.Value = ns then
                    Log.ForActivity t.Tracer.TraceSource t.ActivityId
                else // Log to correct namespace
                    let newSource = getTraceSourceFromNs ns
                    Log.ForActivity newSource t.ActivityId
            | Some source ->
                // overwrite namespace tracesources
                Log.ForActivity source t.ActivityId
    let getTracerFrom frame =
        let ns = getNamespace frame
        getTracerFromActivityOrFallbackNs ns

    let startActivity frame traceSource activity =
        let tracer = getTracerFrom frame
        // create new activity
        let child = tracer.childTracer tracer.TraceSource activity
        // set as current activity
        modifyTracerData (fun d -> {d with ActivityId = child.ActivityId; ActivityTraceSource = traceSource})
        child

    let endActivity (tracer:ITracer) = 
        tracer.Dispose()
    
    let rec private isTracked (exn:exn) = 
        if isNull exn then false
        elif exn.Data.Contains("tracked") then
            true
        else
            isTracked exn.InnerException
    [<System.Diagnostics.DebuggerStepThroughAttribute>]
    [<System.Diagnostics.DebuggerNonUserCodeAttribute>]
    [<System.Diagnostics.DebuggerHiddenAttribute>]
    let inline TraceMeAdv frame source trackAct a =
#if DEBUG
        async {
            addStack frame
            let activity =
                trackAct |> Option.map (startActivity frame source)
            try
                try
                    let! result = a
                    return result
                with
                | exn ->
                    if not <| isTracked exn then
                        let tracer = getTracerFromActivityOrFallbackNs "Yaaf.Logging"
                        tracer.logWarn(fun () -> 
                            let rec buildMessage msg (exn:exn) =
                                match exn with
                                | null -> msg
                                | _ -> 
                                    let msg = sprintf "%s -> %s" msg exn.Message
                                    buildMessage msg exn.InnerException
                            L "noticed exception in Async Code (%O):%s" (exn.GetType()) (buildMessage "" exn))
                        tracer.logVerb(fun () -> L "AsyncStacktrace: %s" (getAsyncStackString()))
                        tracer.logVerb(fun () -> L "Stacktrace: %O" exn)
                        exn.Data.Add("tracked", true)
                    return 
                        reraisePreserveStackTrace exn
            finally
                removeStack()
                match activity with
                | Some t ->
                    endActivity t
                | None -> ()
        }
#else
        a
#endif
open Helpers

module Log =
    /// <summary>
    /// Gets the traceSource for all unhandled namespaces.
    /// </summary>
    [<System.Obsolete("Use Log.GetUnhandledSource() instead")>]
    let UnhandledSource = Log.globalUnhandledSource.Value

    /// <summary>
    /// Gets the dictionary to configure the namespaces that should be logged.
    /// </summary>
    let TraceSourceDict = namespaceTracer

    /// <summary>
    /// Helper API to init a tracesource for a given namespace. 
    /// If no Tracesource was added to TraceSourceDict for the given namespace a new TraceSource will be added,
    /// If for the given namespace was already a TraceSource added nothing will be done but f will be called on the current instance.
    /// </summary>
    /// <param name="f">function to modify the tracesource (you can use ignore)</param>
    /// <param name="ns">the namespace to set (will be the namespace of the TraceSource)</param>
    let SetupNamespace f ns =
        let source = namespaceTracer.GetOrAdd(ns, fun _ -> Log.Source ns)
        f source

    /// <summary>
    /// Gets the current Async Stacktrace. Head is the latest added item. (fifo)
    /// </summary>
    let AsyncStack () = getCurrentStack()
    /// <summary>
    /// Get the current AsyncStack() and formats it as an stacktrace string
    /// </summary>
    let AsyncStackString () = getAsyncStackString()
    
    /// <summary>
    /// Starts an activity with the given name.
    /// </summary>
    /// <param name="act">The name of the activity to start.</param>
    let StartActivity act = startActivity (Helper.currentBackend.CreateStackFrame(1, true)) None act 
    /// <summary>
    /// Starts an activity with overwriting the namespace tracesources. 
    /// Within the activity (and all child activites for that matter) this tracesource will be used.
    /// </summary>
    /// <param name="source">The tracesource to use for the activity</param>
    /// <param name="act">The name of the activity to start</param>
    let StartActivitySource source act  = startActivity (Helper.currentBackend.CreateStackFrame(1, true)) (Some source) act 
    /// <summary>
    /// Ends the given activity.
    /// </summary>
    /// <param name="act">The activity to end (as given by StartActivity*)</param>
    let EndActivity act = endActivity act
    
    /// <summary>
    /// Traces the given async
    /// </summary>
    /// <param name="a">the Async to trace</param>
    [<System.Diagnostics.DebuggerStepThroughAttribute>]
    [<System.Diagnostics.DebuggerNonUserCodeAttribute>]
    [<System.Diagnostics.DebuggerHiddenAttribute>]
    let TraceMe a = TraceMeAdv (Helper.currentBackend.CreateStackFrame(1, true)) None None a
    
    /// <summary>
    /// Trace the given async as Activity
    /// </summary>
    /// <param name="act">The name of the activity</param>
    /// <param name="a">The Async to trace</param>
    [<System.Diagnostics.DebuggerStepThroughAttribute>]
    [<System.Diagnostics.DebuggerNonUserCodeAttribute>]
    [<System.Diagnostics.DebuggerHiddenAttribute>]
    let TraceMeAs act a = TraceMeAdv (Helper.currentBackend.CreateStackFrame(1, true)) None (Some act)  a

    /// <summary>
    /// Trace the given async as Activity with the given TraceSource
    /// </summary>
    /// <param name="source">The TraceSource object to use for tracing</param>
    /// <param name="act">The name of the Activity</param>
    /// <param name="a">the Async to trace</param>
    [<System.Diagnostics.DebuggerStepThroughAttribute>]
    [<System.Diagnostics.DebuggerNonUserCodeAttribute>]
    [<System.Diagnostics.DebuggerHiddenAttribute>]
    let TraceMeSource source act a = TraceMeAdv (Helper.currentBackend.CreateStackFrame(1, true)) (Some source) (Some act) a
    
    let Crit fmt = (getTracerFrom (Helper.currentBackend.CreateStackFrame(1, true))).logCrit fmt
    let Err  fmt =  (getTracerFrom (Helper.currentBackend.CreateStackFrame(1, true))).logErr fmt
    let Info fmt = (getTracerFrom (Helper.currentBackend.CreateStackFrame(1, true))).logInfo fmt
    let Verb fmt = (getTracerFrom (Helper.currentBackend.CreateStackFrame(1, true))).logVerb fmt
    let Warn fmt = (getTracerFrom (Helper.currentBackend.CreateStackFrame(1, true))).logWarn fmt

/// Helps by logging the exception before throwing it, can lead helpful traces in the log when using async code.
[<System.Diagnostics.DebuggerStepThroughAttribute>]
[<System.Diagnostics.DebuggerNonUserCodeAttribute>]
[<System.Diagnostics.DebuggerHiddenAttribute>]
let raise (exn:exn) =
    if not (exn.Data.Contains ("tracked")) then
        exn.Data.Add("tracked", true)
        let asyncStack = getAsyncStackString()
        exn.Data.Add("asynctrace", asyncStack)

        Log.Warn(fun () -> L "Raising Exception in Async Code: %A" exn)
        Log.Verb(fun () -> L "AsyncStacktrace: %s" asyncStack)
        let stacktrace =
            try
                failwith "test"
            with exn ->
                exn.StackTrace
        Log.Verb(fun () -> L "Stacktrace: %s" (stacktrace))
    else
        Log.Warn(fun () -> L "Re-Raising Exception in Async Code (see previous message for stacktrace): %A" exn)
    Microsoft.FSharp.Core.Operators.raise exn

/// Helps by logging the exception before throwing it, can lead helpful traces in the log when using async code.
[<System.Diagnostics.DebuggerStepThroughAttribute>]
[<System.Diagnostics.DebuggerNonUserCodeAttribute>]
[<System.Diagnostics.DebuggerHiddenAttribute>]
let failwith msg =
    let exn = new exn(msg)
    raise exn
     
/// Helps by logging the exception before throwing it, can lead helpful traces in the log when using async code.
[<System.Diagnostics.DebuggerStepThroughAttribute>]
[<System.Diagnostics.DebuggerNonUserCodeAttribute>]
[<System.Diagnostics.DebuggerHiddenAttribute>]
let failwithf fmt =
    Microsoft.FSharp.Core.Printf.ksprintf (failwith) fmt
