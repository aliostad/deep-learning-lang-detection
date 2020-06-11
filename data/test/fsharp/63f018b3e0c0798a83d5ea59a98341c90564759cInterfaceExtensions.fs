// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
[<AutoOpen>]
module Yaaf.Xmpp.Runtime.InterfaceExtensions

open Yaaf.Helper
open Yaaf.Xmpp
open Yaaf.Logging
open Yaaf.Logging.AsyncTracing
open Yaaf.FSharp.Control
open Yaaf.DependencyInjection
open System.Threading.Tasks

type IXmlStream with
    member x.ReadElement() = 
        async { 
            let! flow = x.TryRead()
            return 
                match flow with
                | None -> raise <| StreamUnexpectedFinishException("Stream was finished unexpectedly")
                | Some elem -> elem
        }

type IXmlPluginManager with
    member x.StreamOpened() = 
        async {
            for w in x.GetPlugins() |> Seq.map (fun p -> p.StreamOpened()) do
                do! w
        }
type ICoreStreamApi with
    /// Like CloseStream, however before closing the xmpp stream the given error is sent.
    member x.FailwithStream err = 
        async {
            if not x.IsClosed then
                do! x.AbstractStream.Write(StreamError.writeStreamError err)
                do! x.CloseStream()
        }
type ILocalDelivery with
    member x.QueueMessage msg = x.QueueMessages([msg])

type IXmppPluginConfig with
    static member Empty = { new IXmppPluginConfig } 

type IService with
    static member FromTuple tuple =
        let t,i = tuple
        { new IService with 
            member x.ServiceInstance = i
            member x.ServiceType = t }
    static member FromTupleOption tuple =
        let t,i = tuple
        { new IService with 
            member x.ServiceInstance = i :> obj
            member x.ServiceType = t } |> Seq.singleton
    static member FromInstance<'tservice> instance =
        let t = instance.GetType()
        let serviceType = typeof<'tservice>
        if not <| serviceType.IsAssignableFrom(t) then
            Configuration.configFail "the given instance is not of the given service type"
        { new IService with 
            member x.ServiceInstance = instance :> obj
            member x.ServiceType = serviceType } |> Seq.singleton
    
type Pipeline<'a> =
    {
        HandlerName : string
        Modify : ProcessInfo<'a> -> PreprocessResult<'a>
        HandlerState : ProcessInfo<'a> -> HandlerState
        ProcessSync : ProcessInfo<'a> -> Async<unit>
        Process : ProcessInfo<'a> -> Task<unit>
    } with
    interface IPipeline<'a> with
        member x.HandlerName = x.HandlerName
        member x.Modify info = x.Modify info
        member x.HandlerState info = x.HandlerState info
        member x.ProcessSync info = x.ProcessSync info
        member x.Process info = x.Process info
    static member Empty name =
        {
            HandlerName = name
            Modify = fun (info:ProcessInfo<'a>) -> info.Result
            HandlerState = fun _ -> HandlerState.Unhandled
            ProcessSync = fun _ -> async.Return ()
            Process = fun info -> Task.returnM ()
        }
module Pipeline =
    let empty<'a> name = Pipeline<'a>.Empty name
    let emptyPipeline<'a> name = empty<'a> name :> IPipeline<'a>

    let processPipeline name (pipelineList:IPipeline<'a> seq) (item:'a) = 
        async {
            // preprocess
            //Log.Verb (fun () -> L "Starting '%s' pipeline with." name)
            let info = { Result = { Element = item; IgnoreElement = false }; OriginalElement = item }
            let afterPreprocess =
                pipelineList
                |> Seq.fold (fun state item -> let next = item.Modify state in { state with Result = next }) info

            // group by states
            //Log.Verb (fun () -> L "Check HandlerState in pipeline '%s'." name)
            let states =
                pipelineList
                |> Seq.map 
                    (fun h -> 
                        let state = h.HandlerState afterPreprocess
                        (match state with
                        | HandlerState.ExecuteIfUnhandled prio -> Some prio
                        | _ -> None),
                        state,
                        h)
                |> Seq.groupBy 
                    (fun (prio, state, h) -> 
                        match state with
                        | HandlerState.ExecuteAndHandle -> "ExecuteAndHandle"
                        | HandlerState.ExecuteIfUnhandled _ -> "ExecuteIfUnhandled"
                        | HandlerState.ExecuteUnhandled -> "ExecuteUnhandled"
                        | _ -> "Others")
                |> dict
            
            // process
            //Log.Verb (fun () -> L "pipeline '%s' is processing the handlers" name)
            let tryGetState key =
                match states.TryGetValue (key) with
                | true, k -> k
                | _ -> Seq.empty
            let notifyHandlers = tryGetState "ExecuteUnhandled" |> Seq.map (fun (_,_,h) -> h) |> Seq.toList
            for h in notifyHandlers do  
                do! h.ProcessSync afterPreprocess

            let processWork =    
                notifyHandlers
                // start all processes
                |> Seq.map (fun pipe -> pipe.Process afterPreprocess)
                |> Seq.toList
                //|> Task.whenAll
                //|> Task.ignore

            let handlersFound = tryGetState "ExecuteAndHandle" |> Seq.toArray
            if handlersFound.Length > 1 then
                Log.Err (fun () -> L "pipeline '%s' found multiple handling handlers: %s" name (System.String.Join(",", handlersFound |> Seq.map (fun (_,_,h) -> h.HandlerName))))
            let fromTuple (isHandled, handlers) =
                {
                    ResultElem = afterPreprocess.Result.Element
                    IsHandled = isHandled
                    IsIgnored = afterPreprocess.Result.IgnoreElement
                    ProcessTask = 
                        handlers
                        |> Task.whenAll
                        |> Task.ignore
                        //async {
                        //    for h : IPipeline<'a> in handlers do  
                        //        do! h.Process afterPreprocess
                        //}
                }
            if handlersFound.Length > 0 then
                let _,_,handler = handlersFound.[0]
                do! handler.ProcessSync afterPreprocess
                let w = handler.Process afterPreprocess
                return fromTuple(true, w :: processWork)
            else
                //Log.Verb (fun () -> L "pipeline '%s' is searching fallback handlers" name)
                let prio, handlers, count = 
                    tryGetState "ExecuteIfUnhandled"
                    |> Seq.fold (fun (curPrio, curHandler, count) (prio,_,h) -> 
                        if prio.Value < curPrio then
                            (prio.Value, [h], 1)
                        elif prio.Value = curPrio then
                            (curPrio, h :: curHandler, count + 1)
                        else (curPrio, curHandler, count)) (System.Int32.MaxValue, [], 0)
                let handlers = List.rev handlers
                if count > 1 then
                    Log.Warn (fun () -> L "pipeline '%s' found multiple fallback handler with priority %d: %s" name prio (System.String.Join(",", handlers |> Seq.map (fun h -> h.HandlerName))))
                match handlers with
                | h :: _ ->
                    do! h.ProcessSync afterPreprocess
                    let w = h.Process afterPreprocess
                    return fromTuple(true, w :: processWork)
                | _ -> 
                    //Log.Info (fun () -> L "pipeline '%s' found no handling handlers for %A" name item)
                    return fromTuple(false, processWork)
            // return running work and result
        }
        
    let processManagerG name (manager:IPluginManager<'a>) f (item:'b) =
        processPipeline name (manager.GetPlugins() |> Seq.map f) item
    let processManager name (manager:IPluginManager<#IReceivePipelineProvider<'a>>) (item:'a) =
        processManagerG name manager (fun p -> p.ReceivePipeline) item
    let processSendManager name (manager:IPluginManager<#ISendPipelineProvider<'a>>) (item:'a) =
        processManagerG name manager (fun p -> p.SendPipeline) item

type internal XmlPipelineManager () =
    inherit PluginManager<IXmlPipelinePlugin>()
    interface IXmlPluginManager

type RuntimeConfig =
    {
        JabberId : JabberId
        RemoteJabberId : JabberId option
        IsInitializing : bool
        StreamType : StreamType
    } with
    interface IRuntimeConfig with
        member x.JabberId = x.JabberId
        member x.RemoteJabberId = x.RemoteJabberId
        member x.IsInitializing = x.IsInitializing
        member x.StreamType = x.StreamType
    static member OfInterface (x:IRuntimeConfig) = 
        {
            JabberId = x.JabberId
            RemoteJabberId = x.RemoteJabberId
            IsInitializing = x.IsInitializing
            StreamType = x.StreamType
        }
    static member Default =
        {
            JabberId = Unchecked.defaultof<_>
            RemoteJabberId = None
            IsInitializing = true
            StreamType = StreamType.ClientStream
        }

type IRuntimeConfig with
    member x.IsServerSide with get () = x.StreamType.IsServerSide(x.IsInitializing)
    member x.IsC2sClient with get () = x.StreamType.IsC2sClient(x.IsInitializing)
    member x.StreamNamespace with get() = x.StreamType.StreamNamespace
    static member Default = RuntimeConfig.Default :> IRuntimeConfig

type IKernel with
    member x.HasNot<'a when 'a : not struct>() =
        x.TryGet<'a>().IsNone
        
    member x.GetWithDefault<'a, 'b when 'a : not struct> (f)  (def  : 'b) =
        match x.TryGet<'a>() with
        | Some s -> f s
        | None -> def
module Kernel =
    let inline getConfig< ^I, ^C when ^C : (static member get_Default: unit-> ^C) and  ^C : (static member OfInterface: ^I -> ^C) and ^I : not struct> (kernel:IKernel) =
        let ofInterface i = (^C : (static member OfInterface : ^I -> ^C) i)
        let def = (^C : (static member get_Default : unit -> ^C) ())
        kernel.GetWithDefault ofInterface def
        
    let inline overrideConfig< ^I, ^C when ^C : (static member get_Default: unit-> ^C) and  ^C : (static member OfInterface: ^I -> ^C) and ^I : not struct> (kernel:IKernel) overwrite =
        let overwritten = overwrite (getConfig< ^I, ^C > kernel)
        kernel.Rebind< ^I >().ToConstant(overwritten) |> ignore
        overwritten
        