namespace R4nd0mApps.XTestPlatform.Implementation.XUnit

open R4nd0mApps.XTestPlatform.Api
open R4nd0mApps.XTestPlatform.Implementation.XUnit.Converters
open System
open System.Collections.Generic
open System.IO
open System.Threading
open Xunit
open Xunit.Abstractions

type TestDiscoverySink(f) as i = 
    inherit DiscoveryEventSink()
    let finished = new ManualResetEvent(false)
    
    let testCaseDiscoveryHandler = 
        MessageHandler<ITestCaseDiscoveryMessage>(fun m -> 
            try 
                m.Message.TestCase |> f
            with _ -> ())
    
    let discoverCompletedHandler = 
        MessageHandler<IDiscoveryCompleteMessage>(ignore
                                                  >> finished.Set
                                                  >> ignore)
    
    do 
        i.add_TestCaseDiscoveryMessageEvent (testCaseDiscoveryHandler)
        i.add_DiscoveryCompleteMessageEvent (discoverCompletedHandler)
    
    member __.WaitForCompletion() = finished.WaitOne() |> ignore
    interface IDisposable with
        member __.Dispose() = 
            i.remove_DiscoveryCompleteMessageEvent (discoverCompletedHandler)
            i.remove_TestCaseDiscoveryMessageEvent (testCaseDiscoveryHandler)
            finished.Dispose()
            base.Dispose()

type XUnitTestDiscoverer() = 
    let messageLogged = Event<_>()
    let testDiscovered = Event<_>()
    let toXTestCase sfn source = XTestCase.FromITestCase sfn source >> testDiscovered.Trigger
    
    let discoverTests source = 
        let config = ConfigReader.Load(source, null)
        use sip = new NullSourceInformationProvider()
        use xfc = 
            new XunitFrontController(config.AppDomainOrDefault, source, null, config.ShadowCopyOrDefault, null, sip, 
                                     null)
        use discSink = new TestDiscoverySink(toXTestCase xfc.Serialize source)
        xfc.Find(true, discSink, TestFrameworkOptions.ForDiscovery(config))
        discSink.WaitForCompletion()
    
    interface IXTestDiscoverer with
        member __.ExtensionUri : XExtensionUri = Constants.extensionUri
        member it.Id : string = it.GetType().FullName
        member __.DiscoverTests(sources : seq<string>) : unit = sources |> Seq.iter (Path.GetFullPath >> discoverTests)
        member __.Cancel() : unit = failwith "Not implemented yet"
        member __.MessageLogged : IEvent<XTestMessageLevel * string> = messageLogged.Publish
        member __.TestDiscovered : IEvent<XTestCase> = testDiscovered.Publish

type TestExecutionSink(f1 : _ -> ITestResultMessage -> _, f2) as i = 
    inherit TestMessageSink()
    let finished = new ManualResetEvent(false)
    
    let testCasePassedHandler = 
        MessageHandler<_>(fun m -> 
            try 
                m.Message
                |> f1 XTestOutcome.Passed
                |> f2
            with _ -> ())
    
    let testCaseFailedHandler = 
        MessageHandler<_>(fun m -> 
            try 
                m.Message
                |> f1 XTestOutcome.Failed
                |> XTestResult.AddFailureInfo m.Message
                |> f2
            with _ -> ())
    
    let testCaseSkippedHandler = 
        MessageHandler<_>(fun m -> 
            try 
                m.Message
                |> f1 XTestOutcome.Skipped
                |> f2
            with _ -> ())
    
    let testAssemblyFinishedHandler = 
        MessageHandler<_>(ignore
                          >> finished.Set
                          >> ignore)
    
    do 
        i.Execution.add_TestPassedEvent (testCasePassedHandler)
        i.Execution.add_TestFailedEvent (testCaseFailedHandler)
        i.Execution.add_TestSkippedEvent (testCaseSkippedHandler)
        i.Execution.add_TestAssemblyFinishedEvent (testAssemblyFinishedHandler)
    
    member __.WaitForCompletion() = finished.WaitOne() |> ignore
    
    interface IExecutionSink with
        member __.ExecutionSummary : ExecutionSummary = ExecutionSummary()
        member __.Finished : ManualResetEvent = finished
        member __.OnMessageWithTypes(message : IMessageSinkMessage, messageTypes : Collections.Generic.HashSet<string>) : bool = 
            base.OnMessageWithTypes(message, messageTypes)
    
    interface IDisposable with
        member __.Dispose() = 
            i.Execution.remove_TestAssemblyFinishedEvent (testAssemblyFinishedHandler)
            i.Execution.remove_TestSkippedEvent (testCaseSkippedHandler)
            i.Execution.remove_TestFailedEvent (testCaseFailedHandler)
            i.Execution.remove_TestPassedEvent (testCasePassedHandler)
            finished.Dispose()
            base.Dispose()

type XUnitTestExecutor() = 
    let messageLogged = Event<_>()
    let testCompleted = Event<_>()
    let toXTestResult sfn outcome = XTestResult.FromITestResultMessage sfn outcome
    
    let runTests (source, tcs : seq<XTestCase>) = 
        let config = ConfigReader.Load(source, null)
        use sip = new NullSourceInformationProvider()
        use xfc = 
            new XunitFrontController(config.AppDomainOrDefault, source, null, config.ShadowCopyOrDefault, null, sip, 
                                     null)
        
        let tcs = 
            tcs
            |> Seq.map (fun tc -> tc.TestCase |> xfc.Deserialize, tc)
            |> Seq.toArray // NOTE: PARTHO: Force the enumeration other it gets enumerated from the other appdomain
        
        let tcMap = 
            tcs
            |> Seq.map (fun (x, y) -> x.UniqueID, y)
            |> Prelude.roDict
        
        use execSink = new TestExecutionSink(toXTestResult tcMap, testCompleted.Trigger)
        xfc.RunTests(tcs |> Array.map fst, execSink, TestFrameworkOptions.ForExecution(config))
        execSink.WaitForCompletion()
    
    interface IXTestExecutor with
        member __.ExtensionUri : XExtensionUri = Constants.extensionUri
        member it.Id : string = it.GetType().FullName
        
        member __.RunTests(tests : seq<XTestCase>) : unit = 
            tests
            |> Seq.groupBy (fun t -> t.Source.ToUpperInvariant())
            |> Seq.iter runTests
        
        member __.MessageLogged : IEvent<XTestMessageLevel * string> = messageLogged.Publish
        member __.TestExecuted : IEvent<XTestResult> = testCompleted.Publish
        member __.Cancel() : unit = failwith "Not implemented yet"
