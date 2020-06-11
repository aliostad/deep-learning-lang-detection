namespace FancyFS.Hosting.ASPNET

open System
open System.Threading
open System.Threading.Tasks
open System.Web

open FancyFS.Core
open FancyFS.Core.PipelineModule
open FancyFS.Core.RequestResponseModule
open FancyFS.Hosting.ASPNET.PipelineLocators
open FancyFS.Hosting.ASPNET.RequestResponseMappers

[<AbstractClass>]
type HttpAsyncHandler () as x =

    let CreateTask context = 
        let wrapper = HttpContextWrapper context
        let task = x.ProcessRequestAsync (wrapper)
        task

    abstract member IsReusable : bool with get

    abstract member ProcessRequestAsync : HttpContextBase -> Task

    interface IHttpAsyncHandler with
        
        member this.BeginProcessRequest (context:HttpContext, cb:AsyncCallback, extraData:obj) =
            let task = CreateTask context
            let continuationFun = fun (ar:Task) (state:obj) -> let callback = state :?> AsyncCallback
                                                               callback.Invoke(ar)
            let t = task.ContinueWith(continuationFun, cb)
            if task.Status = TaskStatus.Created then task.Start() else ()
            task :> IAsyncResult

        member this.EndProcessRequest (result) =
            let res = result :?> Task
            res.Wait()
            res.Dispose()

        member this.ProcessRequest (context) =
            let task = CreateTask (context)
            if task.Status = TaskStatus.Created then task.RunSynchronously() else task.Wait()
            ()

        member this.IsReusable
            with get () = x.IsReusable


type FancyRequestHandler () =
    inherit HttpAsyncHandler ()

    override x.IsReusable
        with get () = false

    override x.ProcessRequestAsync context =
        let pipeline = PipelineLocation.Pipeline
        let request = ConvertRequest context
        let output = PipelineModule.ExecutePipelineAsync pipeline request DefaultResponse
        (async {
            let! req, resp = output
            CreateResponse resp context
        } |> Async.StartAsTask) :> Task
