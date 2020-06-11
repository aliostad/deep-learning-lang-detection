// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Test.Yaaf.Xmpp.Runtime

open Yaaf.TestHelper
open Yaaf.Xml
open Yaaf.Xmpp
open Yaaf.Xmpp.Runtime
open System.IO
open System.Xml.Linq
open NUnit.Framework
open FsUnit
open Swensen.Unquote
open Foq

[<TestFixture>]
type TestCoreStreamApi() = 
    inherit Yaaf.TestHelper.MyTestClass()
    let mutable coreApi = Unchecked.defaultof<ICoreStreamApi>
    let mutable opener = Unchecked.defaultof<IInternalStreamOpener>
    let createStreamManager (xmlStream:IXmlStream) =
        Mock<IStreamManager>()
            .Setup(fun x -> <@ x.IsOpened @>).Returns(true)
            .Setup(fun x -> <@ x.IsClosed @>).Returns(false)
            .Setup(fun x -> <@ x.OpenStream() @>).Returns(async.Return())
            .Setup(fun x -> <@ x.CloseStream() @>).Returns(async.Return())
            .Setup(fun x -> <@ x.XmlStream @>).Returns(xmlStream)
            .Create()

    override this.Setup() = 
        base.Setup()
        opener <-
            Mock<IInternalStreamOpener>()
                .Setup(fun x -> <@ x.OpenStream(any()) @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.PluginService @>).Returns(Service.None)
                .Setup(fun x -> <@ x.CloseStream(any()) @>).Returns(async.Return ())
                .Create()
        coreApi <- CoreStreamApi(opener) :> ICoreStreamApi

    override this.TearDown() = 
        base.TearDown()
    

    [<Test>]
    member this.``check that services are provided properly``() = 
        let services = coreApi.PluginService
        test <@ services |> Seq.isEmpty @>
        let service = Service.FromInstance<ITestService,_> (new TestService())
        let opener =
            Mock<IInternalStreamOpener>()
                .Setup(fun x -> <@ x.PluginService @>).Returns(service)
                .Create()
        let coreApi = CoreStreamApi(opener) :> ICoreStreamApi
        test <@ obj.ReferenceEquals (coreApi.PluginService |> Seq.head, service |> Seq.head) @>

    [<Test>]
    member this.``check that multiple opening is allowed``() = 
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Create()
        let streamManager1 = createStreamManager xmlStream1
        coreApi.SetCoreStream(streamManager1)
        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.never)

        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.once)

        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.exactly 2)


    [<Test>]
    member this.``check that opener is called``() = 
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Create()
        let streamManager1 = createStreamManager (xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.never)
        Mock.Verify (<@ opener.CloseStream(xmlStream1) @>, Times.never)

        coreApi.OpenStream() |> Async.StartAsTask |> waitTask

        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.once)
        Mock.Verify (<@ opener.CloseStream(xmlStream1) @>, Times.never)
        
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask

        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.once)
        Mock.Verify (<@ opener.CloseStream(xmlStream1) @>, Times.once)
    
        // Multiple closes MUST be prevented (and silently ignored)
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask

        Mock.Verify (<@ opener.OpenStream(xmlStream1) @>, Times.once)
        Mock.Verify (<@ opener.CloseStream(xmlStream1) @>, Times.once)

    [<Test>]
    member this.``check that SetXmlStream doesn't change AbstractStream property (but changes its side effects)``() = 
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Create()
        let streamManager1 =createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        let abstract1 = coreApi.AbstractStream
        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        test <@ obj.ReferenceEquals(abstract1, coreApi.AbstractStream) @>
        let elem = abstract1.TryRead() |> Async.StartAsTask |> waitTask
        test <@ elem.IsNone @>

        let dummy = XElement(XName.Get("dummy", ""))
        let xmlStream2 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return (Some dummy))
                .Create()
        let streamManager2 =createStreamManager(xmlStream2)
        coreApi.SetCoreStream(streamManager2)
        let abstract2 = coreApi.AbstractStream
        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        test <@ obj.ReferenceEquals(abstract2, coreApi.AbstractStream) @>
        test <@ obj.ReferenceEquals(abstract1, abstract2) @>
        let elem = abstract2.TryRead() |> Async.StartAsTask |> waitTask
        test <@ elem.IsSome @>

    [<Test>]
    member this.``check that history is working properly``() = 
        test <@ coreApi.CoreStreamHistory.IsEmpty @>
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Create()
        let streamManager1 =createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        test <@ coreApi.CoreStreamHistory = [streamManager1] @>

        
        let dummy = XElement(XName.Get("dummy", ""))
        let xmlStream2 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return (Some dummy))
                .Create()
        let streamManager2 =createStreamManager(xmlStream2)
        coreApi.SetCoreStream(streamManager2)
        test <@ coreApi.CoreStreamHistory = [streamManager2; streamManager1] @>
       
    [<Test>]
    member this.``check that stream is closed when OpenStream fails``() = 
        raises<System.InvalidOperationException> <@ coreApi.OpenStream() |> Async.StartAsTask |> waitTask@>
        test <@ coreApi.IsClosed = true @>
        raises<System.InvalidOperationException> <@ coreApi.OpenStream() |> Async.StartAsTask |> waitTask@>
        
    [<Test>]
    member this.``check that CloseStream closes stream``() =
        raises<System.InvalidOperationException> <@ coreApi.CloseStream() |> Async.StartAsTask |> waitTask@>
        test <@ coreApi.IsClosed = true @>

    [<Test>]
    member this.``check that SetCoreStream resets a failed state``() =
        raises<System.InvalidOperationException> <@ coreApi.OpenStream() |> Async.StartAsTask |> waitTask@>
        test <@ coreApi.IsClosed = true @>

        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Setup(fun x -> <@ x.Write(any()) @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteEnd() @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteStart(any()) @>).Returns(async.Return ())
                .Create()
        let streamManager1 = createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask
        
    [<Test>]
    member this.``check that SetCoreStream resets after closing``() =
        raises<System.InvalidOperationException> <@ coreApi.CloseStream() |> Async.StartAsTask |> waitTask@>
        test <@ coreApi.IsClosed = true @>

        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Setup(fun x -> <@ x.Write(any()) @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteEnd() @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteStart(any()) @>).Returns(async.Return ())
                .Create()
        let streamManager1 = createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask

    [<Test>]
    member this.``check that we can't write before OpenStream and after CloseStream``() = 
        let dummy = XElement(XName.Get("dummy", ""))
        // because we have no stream
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.Write dummy |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.WriteEnd () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.WriteStart dummy |> Async.StartAsTask |> waitTask @>
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Setup(fun x -> <@ x.Write(any()) @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteEnd() @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.WriteStart(any()) @>).Returns(async.Return ())
                .Create()
        let streamManager1 =createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)
        
        // because stream was not opened
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.Write dummy |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.WriteEnd () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.WriteStart dummy |> Async.StartAsTask |> waitTask @>

        Mock.Verify (<@ xmlStream1.Write(any()) @>, Times.never)
        Mock.Verify (<@ xmlStream1.WriteEnd() @>, Times.never)
        Mock.Verify (<@ xmlStream1.WriteStart(any()) @>, Times.never)

        coreApi.OpenStream() |> Async.StartAsTask |> waitTask

        coreApi.AbstractStream.Write dummy |> Async.StartAsTask |> waitTask
        coreApi.AbstractStream.WriteEnd () |> Async.StartAsTask |> waitTask
        coreApi.AbstractStream.WriteStart dummy |> Async.StartAsTask |> waitTask
        
        Mock.Verify (<@ xmlStream1.Write(any()) @>, Times.atleastonce)
        Mock.Verify (<@ xmlStream1.WriteEnd() @>, Times.atleastonce)
        Mock.Verify (<@ xmlStream1.WriteStart(any()) @>, Times.atleastonce)
        
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask
        
        // because stream was closed
        raises<SendStreamClosedException> <@ coreApi.AbstractStream.Write dummy |> Async.StartAsTask |> waitTask @>
        raises<SendStreamClosedException> <@ coreApi.AbstractStream.WriteEnd () |> Async.StartAsTask |> waitTask @>
        raises<SendStreamClosedException> <@ coreApi.AbstractStream.WriteStart dummy |> Async.StartAsTask |> waitTask @>


    [<Test>]
    member this.``check that we can't read before Openstream, but still after CloseStream``() = 
        
        let dummy = XElement(XName.Get("dummy", ""))
        // because we have no stream
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.TryRead () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.ReadEnd () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.ReadStart () |> Async.StartAsTask |> waitTask @>
        
        let xmlStream1 =
            Mock<IXmlStream>()
                .Setup(fun x -> <@ x.TryRead() @>).Returns(async.Return None)
                .Setup(fun x -> <@ x.Write(any()) @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.ReadEnd() @>).Returns(async.Return ())
                .Setup(fun x -> <@ x.ReadStart() @>).Returns(async.Return dummy)
                .Create()
        let streamManager1 =createStreamManager(xmlStream1)
        coreApi.SetCoreStream(streamManager1)

         // because stream was not opened
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.TryRead () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.ReadEnd () |> Async.StartAsTask |> waitTask @>
        raises<System.InvalidOperationException> <@ coreApi.AbstractStream.ReadStart () |> Async.StartAsTask |> waitTask @>
        

        coreApi.OpenStream() |> Async.StartAsTask |> waitTask
        
        coreApi.AbstractStream.TryRead () |> Async.StartAsTask |> waitTask |> ignore
        coreApi.AbstractStream.ReadEnd () |> Async.StartAsTask |> waitTask
        coreApi.AbstractStream.ReadStart () |> Async.StartAsTask |> waitTask |> ignore
        
        coreApi.CloseStream() |> Async.StartAsTask |> waitTask

        // Still ok!
        coreApi.AbstractStream.TryRead () |> Async.StartAsTask |> waitTask |> ignore
        coreApi.AbstractStream.ReadEnd () |> Async.StartAsTask |> waitTask
        coreApi.AbstractStream.ReadStart () |> Async.StartAsTask |> waitTask |> ignore
    