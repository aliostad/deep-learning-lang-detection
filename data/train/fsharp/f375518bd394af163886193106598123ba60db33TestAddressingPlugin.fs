// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Test.Yaaf.Xmpp

open System.Xml
open System.Xml.Linq
open System.IO
open NUnit.Framework
open FsUnit
open Test.Yaaf.Xmpp

open Yaaf.DependencyInjection
open Yaaf.Xmpp
open Yaaf.Xmpp.Server
open Yaaf.Xmpp.Stream
open Yaaf.Xmpp.Runtime
open System.Threading.Tasks
open Yaaf.IO
open Yaaf.Helper
open Yaaf.TestHelper
open Foq
open Swensen.Unquote

[<TestFixture>]
type ``Test-Yaaf-Xmpp-AddressingPlugin: Check that the addressing plugin works as expected``() =
    inherit MyTestClass()
    
    let getTestInstance serverApi =
        let kernelMock = Mock<IKernel>()
        let runtimeConfigMock = Mock<IRuntimeConfig>()
        let neg = 
            Mock<INegotiationService>()
                .Setup(fun n -> <@ n.LocalJid @>).Returns(JabberId.Parse("test@yaaf.de/res_0"))
                .Create()
        let runtimeConfig, kernel =
            match serverApi with
            | Some (api:IServerApi) -> 
                let kernel = 
                    kernelMock
                        .Setup(fun k -> <@ k.Get<IServerApi>() @>).Returns(api)
                        .Create()
                let runtimeConfig =
                    runtimeConfigMock
                        .Setup(fun r -> <@ r.StreamType @>).Returns(StreamType.ClientStream)
                        .Setup(fun r -> <@ r.IsInitializing @>).Returns(false)
                        .Create()
                runtimeConfig, kernel
            | None -> runtimeConfigMock.Create(), kernelMock.Create()
        AddressingPlugin(neg, runtimeConfig, kernel) :> IAddressingService
                
    let getDefaultServerApi () =
        Mock<IServerApi>()
            .Setup(fun s -> <@ s.IsLocalJid(any()) @>).Calls<JabberId>(fun jid -> jid.Domainpart = "yaaf.de")
            .Create()
    [<Test>]
    member this.``Check if addressing works properly on client`` () =
        let instance = getTestInstance None
        test 
            <@ instance.IsLocalStanza (
                { To = None; From = None; Type= None; Id = None; StanzaType = XmlStanzas.XmlStanzaType.Iq }:XmlStanzas.StanzaHeader) @>



    [<Test>]
    member this.``Check if addressing works properly on server for messages`` () =
    
        let serverApi =
            Mock<IServerApi>()
                .Setup(fun s -> <@ s.Domain @>).Returns("yaaf.de")
                .Setup(fun s -> <@ s.IsLocalJid(any()) @>).Calls<JabberId>(fun jid -> jid.Domainpart = "yaaf.de")
                .Create()
        let instance = getTestInstance (Some serverApi)

        test 
            <@ not <| instance.IsLocalStanzaOnServer 
                (serverApi,
                 ({ To = Some (JabberId.Parse "user@yaaf.de"); From = Some (JabberId.Parse "other@example.tld"); Type= None; Id = None; StanzaType = XmlStanzas.XmlStanzaType.Message }:XmlStanzas.StanzaHeader)) @>

        test 
            <@ instance.IsLocalStanzaOnServer 
                (serverApi,
                 ({ To = Some (JabberId.Parse "yaaf.de"); From = Some (JabberId.Parse "other@example.tld"); Type= None; Id = None; StanzaType = XmlStanzas.XmlStanzaType.Message }:XmlStanzas.StanzaHeader)) @>










