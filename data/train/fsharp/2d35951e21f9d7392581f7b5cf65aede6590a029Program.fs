open Autofac
open HtmlAgilityPack
open Lacjam
open Lacjam.Core
open Lacjam.Core.Jobs
open Lacjam.Core.Runtime
open Lacjam.Core.Scheduling
open Lacjam.Core.Settings
open Lacjam.Core.Utility
open Lacjam.Integration
open NServiceBus
open NServiceBus
open NServiceBus.Features
open NServiceBus.Features
open NServiceBus.ObjectBuilder
open NServiceBus.ObjectBuilder.Common
open Quartz
open Quartz.Impl
open Quartz.Spi
open System
open System.IO
open System.Linq
open System.Net
open System.Net.Http
open System.Text
open System.Reflection

[<EntryPoint>]
let main argv = 
    printfn "%A" argv    
    do System.Net.ServicePointManager.ServerCertificateValidationCallback <- (fun _ _ _ _ -> true) //four underscores (and seven years ago?)

    let configureBus =   
                     Configure.Transactions.Enable() |> ignore
                     Configure.Serialization.Json() |> ignore
                     Configure.ScaleOut(fun a-> a.UseSingleBrokerQueue() |> ignore) 
                     
                     try
                          //let asses = AppDomain.CurrentDomain.GetAssemblies().Where(fun (b:Reflection.Assembly)->b.GetName().Name.ToLowerInvariant().StartsWith("lacjam.messages"))
                       
                          let tys =  [typedefof<NServiceBus.IMessage>]
                          Configure.With()
                            .DefineEndpointName("lacjam.servicebus")
                            //.LicensePath((IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory.ToLowerInvariant(), "license.xml")))
                           // .AutofacBuilder(Ioc) 
                            .Log4Net()                 
                            .InMemorySagaPersister()
                            .InMemoryFaultManagement()
                            .InMemorySubscriptionStorage()
                            .UseInMemoryTimeoutPersister()  
                            .UseTransport<Msmq>()
                           // .DoNotCreateQueues()
                            .PurgeOnStartup(true)
                            .UnicastBus() |> ignore
                     with | ex -> printfn "%A" ex


    let log = Ioc.Resolve<ILogWriter>()
    let js = Ioc.Resolve<IJobScheduler>()
    let sb = new StringBuilder()
    let meta = js.Scheduler.GetMetaData()
    sb.AppendLine("-- Quartz MetaData --")  |> ignore
    sb.AppendLine("NumberOfJobsExecuted : " + meta.NumberOfJobsExecuted.ToString()) |> ignore
    sb.AppendLine("Started : " + meta.Started.ToString()) |> ignore
    sb.AppendLine("RunningSince : " + meta.RunningSince.ToString())    |> ignore
    sb.AppendLine("SchedulerInstanceId : " + meta.SchedulerInstanceId.ToString())  |> ignore
    sb.AppendLine("ThreadPoolSize : " + meta.ThreadPoolSize.ToString()) |> ignore
    sb.AppendLine("InStandbyMode : " + meta.InStandbyMode.ToString())  |> ignore 
    sb.AppendLine("InStandbyMode : " + meta.ToString())  |> ignore 
    sb.AppendLine("GetCurrentlyExecutingJobs ")  |> ignore 


    let groupMatcher = Quartz.Impl.Matchers.GroupMatcher<TriggerKey>.AnyGroup()
    let keys = js.Scheduler.GetTriggerKeys(groupMatcher) 
    keys |> Seq.iter(fun key -> 
                        let tr = js.Scheduler.GetTrigger(key)
                        let spi = tr :?> Spi.IOperableTrigger
                        let times = TriggerUtils.ComputeFireTimes(spi, null,10)
                        log.Write(Debug(tr.ToString()))
                        log.Write(Debug("Next 10 fire times scheduled for..."))
                        for time in times do
                            log.Write(Debug(time.ToLocalTime().ToString()))
                        ) |> ignore

    let jobs = js.Scheduler.GetCurrentlyExecutingJobs()
    for job in jobs do
        sb.AppendLine(job.JobDetail.Key.Name)    |> ignore 

    let jobGroupsNames = js.Scheduler.GetJobGroupNames()
    for jobGroupName in jobGroupsNames do
        let groupMatcher = Quartz.Impl.Matchers.GroupMatcher<JobKey>.GroupContains(jobGroupName)
        let keys = js.Scheduler.GetJobKeys(groupMatcher) 
        for jobKey in keys do
            let detail = js.Scheduler.GetJobDetail(jobKey);
            let triggers = js.Scheduler.GetTriggersOfJob(jobKey);
            sb.AppendLine(jobKey.Name) |> ignore 
            sb.AppendLine(detail.Description)   |> ignore 
            for trig in triggers do
                sb.AppendLine(trig.Key.Group + " " + trig.Key.Name)   |> ignore 
                let nextFireTime = trig.GetNextFireTimeUtc()
                if (nextFireTime.HasValue) then
                    sb.AppendLine(nextFireTime.Value.LocalDateTime.ToString()) |> ignore

    Console.WriteLine(sb.ToString())

//    let stock = StockPrice.Handler(Ioc.Resolve<ILogWriter>(), Ioc.Resolve<IBus>()) :> IHandleMessages<StockPrice.Job>
//    let job = StockPrice.Job()
//    job.StockSymbol <- "WBC"
//    stock.Handle(job)

    Console.ReadLine()  |> ignore
    0 // return an integer exit code