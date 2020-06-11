module Restful

// idea: 
// hit main service subject by subject, break subject into pages
// digest records show up, hit citation service
// digest citations
// as citations show up, analyze them
open System
open System.Net
open System.Xml
open System.IO
open Microsoft.FSharp.Control.WebExtensions

[<AbstractClass>]
type ParallelProcessorCallbacks() = 
    abstract member OnDocument:XmlDocument -> unit
    abstract member OnNode:XmlNode -> unit

type ParallelProcessor(callbacks:ParallelProcessorCallbacks) = 
    member me.Callbacks = callbacks

    member me.InvokePoxWebRequest(url:string) =
        let uri = new System.Uri(url)
        let webClient = new WebClient()
        webClient.OpenRead(uri)

    static member InvokePoxWebRequestWithCredentials(url:string, credentials) =
        let uri = new System.Uri(url)
        let webClient = new WebClient()
        webClient.Credentials <- credentials
        webClient.OpenRead(uri)

    /// Processes Xml document in parallel for multicore / recursive async / db / io calls
    member me.ParallelProcessXmlAsync(reader:XmlReader) =
        let doc = new XmlDocument();

        // Make a list of processing the nodes
        let rec readAll x = 
            let node = doc.ReadNode(reader)
            match node with
                | null -> [async { me.Callbacks.OnDocument doc |> ignore }]
                | _ -> async { me.Callbacks.OnNode node |> ignore } :: readAll x
        readAll () 

    /// Processes Xml document in parallel for multicore / recursive async / db / io calls
    member me.ParallelProcessXml(reader:XmlReader) =
        me.ParallelProcessXmlAsync(reader)
        |> Async.Parallel 
        |> Async.RunSynchronously
        |> ignore

    /// Calls restful service, expecting POX result and processes document nodes in parallel for multicore / recursive async / db / io calls    
    member me.ProcessAsync(uri:string) = 
        me.ParallelProcessXmlAsync(XmlReader.Create(me.InvokePoxWebRequest(uri)))

    member me.ProcessAsyncWithCredentials(uri:string, credentials) = 
        me.ParallelProcessXmlAsync(XmlReader.Create(ParallelProcessor.InvokePoxWebRequestWithCredentials(uri, credentials)))

    /// Calls restful service, expecting POX result and processes document nodes in parallel for multicore / recursive async / db / io calls
    member me.Process(uri:string) =
        me.ProcessAsync(uri)
        |> Async.Parallel 
        |> Async.RunSynchronously
        |> ignore

    /// Calls restful service, expecting POX result and processes document nodes in parallel for multicore / recursive async / db / io calls
    member me.ProcessWithCredentials(uri:string, credentials) =
        me.ProcessAsyncWithCredentials(uri, credentials)
        |> Async.Parallel 
        |> Async.RunSynchronously
        |> ignore

