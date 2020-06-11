namespace MBrace.AWS.Runtime

open System
open System.Runtime.Serialization

open MBrace.FsPickler

open FSharp.AWS.DynamoDB

open MBrace.Core
open MBrace.Core.Internals
open MBrace.Runtime
open MBrace.Runtime.Utils
open MBrace.Runtime.Components
open MBrace.AWS
open MBrace.AWS.Runtime.Utilities

[<Sealed; AutoSerializable(false)>]
type CloudProcessManager private (clusterId : ClusterId, logger : ISystemLogger) =

    static let getProcKey procId = TableKey.Range procId

    let processTable = clusterId.GetRuntimeTable<CloudProcessRecord>()
    let workItemTable = clusterId.GetRuntimeTable<WorkItemRecord>()

    interface ICloudProcessManager with
        member __.ClearProcess(procId: string) = async {
            let deleteProc() = async {
                let procKey = getProcKey procId
                let! proc = processTable.DeleteItemAsync(procKey)
                let info = proc.ToCloudProcessInfo(clusterId)
                info.CancellationTokenSource.Cancel()
                return ()
            }

            let deleteWorkItems() = async {
                let! items = workItemTable.QueryAsync(getWorkItemsByProcessQuery procId)
                do!
                    items
                    |> Seq.map workItemTable.Template.ExtractKey
                    |> Seq.chunksOf 25
                    |> Seq.map workItemTable.BatchDeleteItemsAsync
                    |> Async.Parallel
                    |> Async.Ignore
            }

            let! _ = Async.Parallel [deleteProc() ; deleteWorkItems()]
            return ()
        }
        
        member __.ClearAllProcesses() = async {
            let this = __ :> ICloudProcessManager
            let! records = processTable.QueryAsync(procHashKeyCondition)
            do!
                records
                |> Seq.map (fun r -> this.ClearProcess(r.Id))
                |> Async.Parallel
                |> Async.Ignore
        }
        
        member __.StartProcess(info: CloudProcessInfo) = async {
            let taskId = guid()
            logger.LogInfof "Creating cloud process %A" taskId
            let record = CloudProcessRecord.CreateNew(taskId, info)
            let! _ = processTable.PutItemAsync(record, precondition = itemDoesNotExist)
            let tcs = new CloudProcessEntry(clusterId, taskId, info)
            return tcs :> ICloudProcessEntry
        }
        
        member __.GetAllProcesses() = async {
            let! records = processTable.QueryAsync(procHashKeyCondition)
            return records 
                   |> Seq.map(fun r ->
                        new CloudProcessEntry(clusterId, r.Id, r.ToCloudProcessInfo(clusterId)) 
                        :> ICloudProcessEntry) 
                   |> Seq.toArray
        }
        
        member __.TryGetProcessById(procId: string) = async {
            try
                let! record = processTable.GetItemAsync(getProcKey procId)
                let entry = new CloudProcessEntry(clusterId, procId, record.ToCloudProcessInfo(clusterId))
                return Some (entry :> _)

            with :? ResourceNotFoundException -> return None
        }

    static member Create(clusterId : ClusterId, logger) = 
        new CloudProcessManager(clusterId, logger)