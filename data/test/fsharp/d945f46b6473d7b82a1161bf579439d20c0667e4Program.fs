// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open Microsoft.Azure.WebJobs
open ParseCVREmails.Lib
open System.Configuration
open System.Text.RegularExpressions
open System.Runtime.InteropServices
open System.Net
open System.Net.Http
open System.IO
open System.Threading.Tasks

let findUrl text = 
    let r = new Regex("kan hentes her: (.*)?For at", RegexOptions.Singleline)
    let m = r.Match(text)
    m.Groups.[1].Value

//let Download ([<QueueTriggerAttribute(queueName="test")>] downloadUrl : string, [<Blob("downloaded-files/download", FileAccess.Write)>]output : System.IO.Stream) = 
 
let Download ([<QueueTriggerAttribute(queueName="downloads")>] downloadUrl : string, binder : IBinder ) = 
    async {
        let output = binder.Bind<Stream>(new BlobAttribute("downloaded-files/"+(downloadUrl.Split([|'/'|]) |> Seq.last),FileAccess.Write))
        let handler = new HttpClientHandler()
        handler.Credentials <- new NetworkCredential(ConfigurationManager.AppSettings.["CvrUserName"], ConfigurationManager.AppSettings.["CvrPassword"])
        use client = new HttpClient(handler)
        let! r = client.GetStreamAsync(downloadUrl) |> Async.AwaitTask
        do! r.CopyToAsync(output) |> Async.AwaitIAsyncResult |> Async.Ignore
    }    
       

let ProcessMessage ([<QueueTriggerAttribute(queueName = "emails")>] message : EmailData, [<QueueAttribute(queueName="downloads")>] [<Out>] downloads : byref<string>)  =
    let url = findUrl message.Text 
    downloads <- url


[<EntryPoint>]
let main argv = 
    printfn "%A" argv
    use jobHost = new JobHost()
    jobHost.RunAndBlock()
    0 // return an integer exit code
