// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.Xmpp

open Yaaf.Helper
open Yaaf.Logging
open Yaaf.Xmpp.Runtime
open Yaaf.Xmpp.Runtime.Features
open Yaaf.Xmpp.Server
open Yaaf.Xmpp.XmlStanzas
open Yaaf.DependencyInjection


type IAddressingService =
    abstract IsLocalStanza : StanzaHeader -> bool
    abstract IsLocalStanzaOnServer : IServerApi * StanzaHeader -> bool
    /// When on server ShouldHandleStanzaLocally is called while on client IsLocalStanza is used.
    abstract IsLocalStanzaMaybeServer : StanzaHeader -> bool
    abstract IsServer : bool with get
    abstract ServerApi : IServerApi option with get

[<AutoOpen>]
module AddressingServiceExtensions =
    type IAddressingService with
        member x.IsLocalStanza (stanza: IStanza) = x.IsLocalStanza stanza.Header
        member x.IsLocalStanzaOnServer (api, stanza: IStanza) = x.IsLocalStanzaOnServer (api, stanza.Header)
        member x.IsLocalStanzaMaybeServer (stanza: IStanza) = x.IsLocalStanzaMaybeServer (stanza.Header)

type AddressingPlugin(neg : INegotiationService, runtimeConfig : IRuntimeConfig, kernel : IKernel) = 
    static let isLocalStanza (neg : INegotiationService) (header : StanzaHeader) = 
            // if the stanza is addressed to us then call event
            let addressed = 
                lazy 
                    (header.To.Value = neg.LocalJid || header.To.Value.FullId = neg.LocalJid.BareId)
            header.To.IsNone || addressed.Value 

    static let isLocalStanzaOnServer (serverApi : IServerApi) (header : StanzaHeader) =
        let toj = header.To
        let isIq = header.StanzaType = XmlStanzaType.Iq
        // See 10.5.3.  localpart@domainpart
        toj.IsNone || 
            ((toj.Value.Localpart.IsNone || (isIq && toj.Value.Resource.IsNone)) && serverApi.IsLocalJid toj.Value) 
        
    let isLocalStanza header =
        isLocalStanza neg header
    let getServerApi () =
        if runtimeConfig.IsServerSide then
            let api = kernel.Get<IServerApi>()
            Some api
        else 
            None
        
    let isLocalStanzaMaybeServer (header:StanzaHeader) =
        match getServerApi () with
        | Some api ->
            isLocalStanzaOnServer api header
        | None -> 
            isLocalStanza header

    static member IsLocalStanza = isLocalStanza
    static member IsLocalStanzaOnServer = isLocalStanzaOnServer
    interface IAddressingService with
        member x.IsLocalStanza header = isLocalStanza header
        member x.IsLocalStanzaOnServer (serverApi, header) = isLocalStanzaOnServer serverApi header
        member x.IsLocalStanzaMaybeServer (header) = isLocalStanzaMaybeServer header

        member x.IsServer = runtimeConfig.IsServerSide
        member x.ServerApi with get() = getServerApi()

    interface IXmppPlugin with
        member x.PluginService = Service.FromInstance<IAddressingService,_> x
        member x.Name = "AddressedStanzaPlugin"

        