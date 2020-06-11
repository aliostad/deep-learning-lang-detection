namespace NBlast.Api.Async

open System.Diagnostics
open NBlast.Api.Models
open FluentScheduler
open NBlast.Storage
open NBlast.Storage.Core.Index
open NBlast.Storage.Core.Extensions


type QueueProcessingTask(queueKeeper: IIndexingQueueKeeper, 
                         storageWriter: IStorageWriter,
                         ?indexingLimit: int) =
    
    static let logger = NLog.LogManager.GetCurrentClassLogger()

    member private me.ProcessModels (models: seq<LogModel>) =
        let sw = new Stopwatch() 
        sw.Start()

        models |> Seq.toList |> Seq.map (fun model ->
            new LogDocument(model.Sender, 
                            model.Message, 
                            model.Logger, 
                            model.Level,
                            model.ErrorOp,
                            model.CreatedAtOp) :> IStorageDocument
        ) |> storageWriter.InsertMany

        sw.Stop()
        logger.Debug("Import process has took {0} msec(s)", sw.ElapsedMilliseconds)

    interface ITask with 
        member me.Execute() =
            let count = queueKeeper.Count()
            if (count > 0) then
                logger.Debug("Scheduled task executed, queue contains {0} element(s)", count)
                queueKeeper.ConsumeMany(Some (indexingLimit |? 400)) |> me.ProcessModels |> ignore  

