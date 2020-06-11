// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.Xmpp.Server

open Yaaf.Helper
open Yaaf.Logging
open Yaaf.Logging.AsyncTracing
open Yaaf.Xmpp
open Yaaf.Xmpp.Runtime
open Yaaf.Xmpp.XmlStanzas


/// Plugin which is only available on the server side, and registers some server side only actions
type XmppServerDeliveryPlugin
    (serverApi : IServerApi, neg : INegotiationService, runtimeConfig: IRuntimeConfig, stanzas : IXmlStanzaService, 
     registrar : IPluginManagerRegistrar, addressing : IAddressingService) = 
   
    static let handleAddressingHeader (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, header:StanzaHeader) = 
        match streamType with
        | ClientStream ->
            let header =
                if header.From.IsNone || header.From.Value <> remoteJid 
                then { header with From = Some remoteJid }
                else header
            match header.StanzaType with
            | XmlStanzaType.Message ->
                if header.To.IsNone
                then { header with To = Some remoteJid.BareJid }
                else header
            | _ -> header
        | ComponentStream _
        | ServerStream ->
            if header.From.IsNone || header.To.IsNone then
                StreamError.fail XmlStreamError.ImproperAddressing
            elif header.From.Value.Domainpart <> remoteJid.BareId then
                StreamError.fail XmlStreamError.InvalidFrom
            elif not (serverApi.IsLocalJid header.To.Value) then
                StreamError.fail XmlStreamError.HostUnknown
            else header
    static let handleAddressing (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, stanza:Stanza) = 
        stanza.WithHeader (handleAddressingHeader (serverApi, remoteJid, streamType, stanza.Header))

    //let handleAddressingGeneric (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, stanza:Stanza<_>) = 
    //    { stanza with Header = handleAddressingHeader (serverApi, remoteJid, streamType, stanza.Header) }
        
    static let deliverStanza (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, localSendStanza, (stanza : Stanza)) = 
        async {
            let toj = stanza.Header.To
            let delivery = serverApi.Delivery
            // deliver stanza
            let! delivered = delivery.TryDeliver (toj.Value) (stanza)
            if not delivered then 
                // We can't respond with an error when this already is an error.
                if stanza.Header.IsErrorStanza then
                    Log.Err (fun () -> L "Received an error stanza which could not be delivered to its destination, we can only ignore it at this point: %A" stanza)
                else
                    Log.Err (fun () -> L "Received an stanza which could not be delivered to its destination, we return bad-request: %A" stanza)
                    let error = XmlStanzas.StanzaException.createBadRequest stanza
                    let error = error.WithHeader { error.Header with From = Some(JabberId.Parse serverApi.Domain) }
                    localSendStanza error.SimpleStanza
        }

    let pluginPipeline =
        { new IRawStanzaPlugin with    
            member x.ReceivePipeline = 
                { Pipeline.empty "XmppServerPlugin Stanza Received pipeline" with
                    Modify =
                        fun info ->
                            if neg.NegotiationCompleted then
                                { info.Result with 
                                    Element = handleAddressing (serverApi, neg.RemoteJid, runtimeConfig.StreamType, info.Result.Element) }
                            else info.Result
                    HandlerState = 
                        fun info -> 
                            if neg.NegotiationCompleted && not <| addressing.IsLocalStanzaOnServer (serverApi, info.Result.Element)
                            then HandlerState.ExecuteIfUnhandled 99
                            else HandlerState.Unhandled
                    Process =
                        fun info ->
                            async {
                                let elem = info.Result.Element
                                assert (not <| addressing.IsLocalStanzaOnServer (serverApi, elem))
                                return! deliverStanza (serverApi, neg.RemoteJid, runtimeConfig.StreamType, stanzas.QueueStanza None, elem)
                            } |> Async.StartAsTaskImmediate
                } :> IPipeline<_> }
    do
        registrar.RegisterFor<IRawStanzaPlugin> pluginPipeline
        
    let unvalidatedPipeline =
        { new IRawUnvalidatedStanzaPlugin with    
            member x.ReceivePipeline = 
                { Pipeline.empty "XmppServerPlugin Stanza Received pipeline" with
                    HandlerState = 
                        fun info ->
                            // Deliver Error stanzas immediatly if applicable 
                            let elem : Stanza = info.Result.Element
                            let stanzaType = elem.Header.Type
                            // Deliver only after negotiation
                            if neg.NegotiationCompleted 
                                && not <| addressing.IsLocalStanzaOnServer(serverApi, elem)
                                && stanzaType.IsSome && stanzaType.Value = "error"
                            then HandlerState.ExecuteIfUnhandled 99
                            else HandlerState.Unhandled
                    Process =
                        fun info ->
                            async {
                                let elem = info.Result.Element
                                assert (not <| addressing.IsLocalStanzaOnServer(serverApi, elem))
                                return! deliverStanza (serverApi, neg.RemoteJid, runtimeConfig.StreamType, stanzas.QueueStanza None, elem)
                            } |> Async.StartAsTaskImmediate
                } :> IPipeline<_> }
    do
        registrar.RegisterFor<IRawUnvalidatedStanzaPlugin> unvalidatedPipeline

    interface IXmppPlugin with
        member x.PluginService = Seq.empty
        member x.Name = "XmppServerPlugin"

    static member HandleAddressing (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, stanza:Stanza) =
        handleAddressing (serverApi, remoteJid, streamType, stanza)
    static member HandleAddressing (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, stanza:StanzaHeader) =
        handleAddressingHeader (serverApi, remoteJid, streamType, stanza)
    static member DeliverStanza (serverApi : IServerApi, remoteJid : JabberId, streamType : StreamType, localDeliver, stanza:Stanza) =
        deliverStanza (serverApi, remoteJid, streamType, localDeliver, stanza)