// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.Xmpp.Runtime
open Yaaf.Helper

/// Used to manage a primitive stream and to provide an higher level API.
type StreamManager<'prim>(p:'prim, provider : 'prim -> IXmlStream) =
    let mutable isOpen = false
    let mutable isClosed = false
    let mutable xmlStream = None
    abstract member CloseStreamOverride : unit -> Async<unit>
    default x.CloseStreamOverride () = async.Return()
    member x.CloseStream() =
        async {
            isOpen <- false
            isClosed <- true
            do! x.CloseStreamOverride()
        }
    abstract member OpenStreamOverride : unit -> Async<unit>
    default x.OpenStreamOverride () = async.Return()
    member x.OpenStream() =
        async {
            isOpen <- true
            try
              xmlStream <- Some (provider(p))
              do! x.OpenStreamOverride()
            with e ->
              isOpen <- false
              isClosed <- true
              Async.reraise e
        }
    member x.PrimitiveStream = p
    member x.XmlStream =
        match xmlStream with
        | Some stream -> stream
        | None -> failwith "Stream not opened!"
    member x.IsOpened = isOpen
    member x.IsClosed = isClosed
    interface IStreamManager with
        member x.XmlStream = x.XmlStream
        member x.IsOpened = x.IsOpened
        member x.IsClosed = x.IsClosed
        member x.CloseStream () = x.CloseStream()
        member x.OpenStream () = x.OpenStream()

    interface IStreamManager<'prim> with
        member x.PrimitiveStream = x.PrimitiveStream
        
/// Used to provide (and abstract away) the core communication layer.
type CoreStreamApi(opener : IInternalStreamOpener) =
    let mutable isCurrentStreamOpen = false
    let mutable isCurrentStreamClosed = false
    let mutable history : IStreamManager list = []
    let setCoreStream (prim:IStreamManager) =
        if prim.IsClosed then invalidArg "prim" "Stream should not be closed already!"
        history <- prim :: history
        isCurrentStreamOpen <- false
        isCurrentStreamClosed <- false
        ()
         
    let getFirstManager () = 
        match history with
        | h :: _ -> h
        | _ -> invalidOp "No Stream was set with SetCoreStream!"
    let getFirst () = 
        async {
            let h = getFirstManager()
            if h.IsClosed then invalidOp "Current Stream already finished!"
            if not h.IsOpened then do! h.OpenStream()
            return h.XmlStream
        }
    let openStream () = 
        async {
            try
                let! current = getFirst()
                do! opener.OpenStream(current)
                isCurrentStreamOpen <- true
            with e ->
                isCurrentStreamClosed <- true
                isCurrentStreamOpen <- false
                Async.reraise e
        }
    let closeStream () = 
        async {
            if not isCurrentStreamClosed then
                isCurrentStreamClosed <- true
                isCurrentStreamOpen <- false
                let! current = getFirst()
                do! opener.CloseStream(current)
        }
    // basically we can always read after OpenStream (as long as the underlaying stream is open)
    let checkRead () = 
        if not isCurrentStreamOpen && not isCurrentStreamClosed then
            // before OpenStream
            invalidOp "Open a stream with OpenStream first!"

    // We can only write between Openstream and CloseStream
    let checkWrite () = 
        if not isCurrentStreamOpen then
            if isCurrentStreamClosed then
                raise <| new SendStreamClosedException("Stream was already closed.")
            else
                // before OpenStream
                invalidOp "Writing is only possible between OpenStream and CloseStream!"

    let abstractStream =
        { new IXmlStream with
            member x.TryRead () = 
                async {
                    checkRead()
                    let! stream = getFirst ()
                    return! stream.TryRead()
                } 
                
            member x.Write elem =
                async {
                    checkWrite()
                    let! stream = getFirst ()
                    return! stream.Write elem
                } 
            member x.ReadStart () =
                async {
                    checkRead()
                    let! stream = getFirst ()
                    return! stream.ReadStart ()
                } 
            member x.WriteStart elem = 
                async {
                    checkWrite()
                    let! stream = getFirst ()
                    return! stream.WriteStart elem
                } 
            member x.ReadEnd () =
                async {
                    checkRead()
                    let! stream = getFirst ()
                    return! stream.ReadEnd ()
                } 
            member x.WriteEnd () =
                async {
                    checkWrite()
                    let! stream = getFirst ()
                    return! stream.WriteEnd ()
                } 
        }

    interface ICoreStreamApi with
        member x.PluginService = 
            let openerServices = opener.PluginService
            if isNull openerServices then Service.None else openerServices

        member x.SetCoreStream prim = setCoreStream prim
        member x.CoreStreamHistory = history
        member x.AbstractStream = abstractStream
        member x.OpenStream () = openStream()
        member x.CloseStream () = closeStream()
        member x.IsClosed = isCurrentStreamClosed