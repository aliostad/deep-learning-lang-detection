[<AutoOpen>]
module Nessos.MBrace.Runtime.Definitions.PublicTypes

open System
open Nessos.MBrace.Runtime

open Nessos.Vagrant

open Nessos.Thespian.ImemDb

open Nessos.MBrace.Utils

type Process = {
    ProcessId: ProcessId
    ClientId: Guid
    RequestId: RequestId
    Name: string
    Type: byte[]
    TypeName: string
    Initialized: DateTime 
    Created: DateTime option
    Started: DateTime option
    Completed: DateTime option
    TasksRecovered: int
    Dependencies : AssemblyId list
    Result: ExecuteResultImage option
    State: ProcessState
}

type ProcessMonitorDb = {
    Process: Table<Process>
} with static member Create() = { Process = Table.create <@ fun p -> p.ProcessId @> }

