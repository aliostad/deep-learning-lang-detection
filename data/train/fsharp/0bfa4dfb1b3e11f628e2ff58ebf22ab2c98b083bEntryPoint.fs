open FSharp.Configuration
open Mq.Core
open Mq.Coordinator

type Config = YamlConfig<"Config.example.yml">


[<EntryPoint>]
let main argv = 
    let config : Config = Configuration.get ()
    let getCurrentTasks = fun () -> ExecutorRequests.getCurrentTasks (config.Agents |> Seq.map string |> List.ofSeq)
    let stopTask = ExecutorRequests.stopTask >> Async.ignore
    let stopper = Coordination.stop getCurrentTasks stopTask
    let authorize = ApiRequests.tryAuthorize config.PostgRest.Tasks
    let handler = Handler.handle authorize stopper

    let suaveConfig = { Suave.Web.defaultConfig with 
                            logger = Mq.Core.Suave.Logging.nlogLogger
                            bindings = [Suave.Http.HttpBinding.mkSimple Suave.Http.Protocol.HTTP "0.0.0.0" config.Api.Port] }
    Suave.Web.startWebServer suaveConfig handler 
    printfn "%A" argv
    0 // return an integer exit code
