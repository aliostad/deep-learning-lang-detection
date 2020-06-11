// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Test.Yaaf.Xmpp
open Yaaf.FSharp.Control
open Yaaf.Xmpp
open Yaaf.Helper
open Yaaf.Logging
open Yaaf.Logging.AsyncTracing
open Yaaf.TestHelper
open Yaaf.Xmpp.XmlStanzas
open System.Threading.Tasks

//[<AutoOpen>]
//module XmppClientExtensions = 
//    type IXmppClient with
//        member x.WriteRaw (s:System.String) = 
//            let elem = System.Xml.Linq.XElement.Parse s
//            let nsElem = Yaaf.Xmpp.XmlStanzas.Parsing.replaceNamespace "" x.Config.StreamNamespace elem
//            x.WriteElem nsElem
//        member x.WriteRawUnsafe s = 
//            x.WriteRaw s |> Async.RunSynchronously
//        member x.WriteElemUnsafe s = 
//            x.WriteElem s |> Async.RunSynchronously
//
//    let Event_ElementReceivedRawEvent = XmppEvent.create<StreamElement> "Yaaf.XmppTest.Events.ElementReceivedRaw"
//    type IEventManager with
//        member x.AddElementReceivedRaw = x.AddEventHandlerSimple Event_ElementReceivedRawEvent
//        member x.TriggerElementReceivedRaw h = 
//            x.TriggerEvent Event_ElementReceivedRawEvent h
//open XmppClientExtensions
//type NUnitStreamHandler (config : XmppReadonlyConfig) =
//    interface IXmppStreamHandler with
//        member x.Name with get() = "NUnitStreamHandler"
//        member x.FilterNamespace with get() = ""
//        member x.Init context = ()
//        member x.UpdateConfig config = ()
//        // We do only work at stream opening
//        member x.HandleElement (elem, context) =
//            async {
//                do! context.Events.TriggerElementReceivedRaw elem
//                return HandlerResult.Unhandled
//            }
module NUnitHelper =
    //let NUnitHandler =Yaaf.Xmpp.Handler.Core.createStreamHandlerInitalizer "NUnitStreamHandler"  (fun (config) -> new NUnitStreamHandler(config) :> IXmppStreamHandler) : IXmppStreamHandlerInitalizer
    let FromObservable obs = 
        obs
        |> AsyncSeq.ofObservableBuffered
        |> AsyncSeq.cache

    //let ElemReceiver (client:IXmppClient) =
    //    let obSource = ObservableSource()
    //    client.ContextManager.RequestContextSync(fun context ->
    //        context.Events.AddElementReceivedRaw(fun (context, elem) -> obSource.Next (elem); async.Return TriggerResult.Continue))
    //    //obSource.Completed,
    //    obSource.AsObservable
    //    |> FromObservable
    //
    //let StanzaReceiver (client:IXmppClient) =
    //    let obSource = ObservableSource()
    //    client.ContextManager.RequestContextSync(fun context ->
    //        context.Events.AddRawStanzaReceived(fun (context, elem) -> obSource.Next (elem); async.Return TriggerResult.Continue))
    //    //obSource.Completed,
    //    obSource.AsObservable 
    //    |> FromObservable

    let tryHeadImpl (s:AsyncSeq<_>) =   
        async {
            let! t = s
            return
                match t with
                | Nil -> None
                | Cons(data, next) ->
                    Some(data, next)
        } 
    let tryHead (s:AsyncSeq<_>) =   
        async {
            let! t = tryHeadImpl s
            return t |> Option.map fst
        } 
    let head (s:AsyncSeq<_>) =   
        async {
            let! t = tryHead s
            return
                match t with
                | None -> failwith "no head found"
                | Some s -> s
        } 
    let readNext (s:AsyncSeq<_>) = 
        async {
            Log.Verb (fun _ -> L "NUnitHelper: start waiting for next element!")
            let! t = tryHeadImpl s
            Log.Verb (fun _ -> L "NUnitHelper: got %A as next element!" (t |> Option.map fst))
            return
                match t with
                | None -> failwith "no next found!"
                | Some d -> d
        } 
    let readNextTask (s:AsyncSeq<_>) = readNext s |> Async.StartAsTask

    let NEXT (result:Task<'a * AsyncSeq<'a>>) = 
        let stanza, receiver  = result |> waitTaskIT "result" (defaultTimeout * 2)
        stanza, readNextTask receiver

