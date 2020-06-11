[<AutoOpen>]
module Nessos.MBrace.Runtime.Definitions.ProcessDomainDb

open System
open System.Diagnostics

open Nessos.Vagrant

open Nessos.Thespian
open Nessos.Thespian.AsyncExtensions
open Nessos.Thespian.Remote.TcpProtocol
open Nessos.Thespian.Cluster
open Nessos.Thespian.ImemDb

open Nessos.MBrace.Runtime
open Nessos.MBrace.Utils
open Nessos.MBrace.Utils.String


[<CustomEquality; CustomComparison>]
type ProcessDomain = {
    Id: ProcessDomainId
    NodeManager: ReliableActorRef<NodeManager>
    LoadedAssemblies: Set<AssemblyId>
    Port: int option
    ClusterProxyManager: Actor<ClusterProxyManager> option
    // Atom generated as part of Thespian.Cluster's public API ; should be fixed
    ClusterProxyMap: Nessos.Thespian.Atom<Map<ActivationReference, ReliableActorRef<RawProxy>>> option
    KillF: unit -> unit
} with
    override x.Equals yobj =
        match yobj with
        | :? ProcessDomain as y ->
            (x.Id, x.NodeManager, x.LoadedAssemblies, x.Port, x.ClusterProxyManager) = (y.Id, y.NodeManager, y.LoadedAssemblies, y.Port, y.ClusterProxyManager)
        | _ -> false

    override x.GetHashCode() =
        hash (x.Id, x.NodeManager, x.LoadedAssemblies, x.Port)

    interface IComparable with
        override x.CompareTo yobj =
            match yobj with
            | :? ProcessDomain as y ->
                (box (x.Id, x.NodeManager, x.LoadedAssemblies, x.Port, x.ClusterProxyManager) :?> IComparable).CompareTo(
                    (y.Id, y.NodeManager, y.LoadedAssemblies, y.Port, y.ClusterProxyManager))
            | _ -> invalidArg "yobj" "Cannot compare values of different types."


type Process = {
    Id: ProcessId
    ProcessDomain: ProcessDomainId
}

type ProcessDomainDb = {
    ProcessDomain: Table<ProcessDomain>
    Process: Table<Process>
} with
    static member Create() = {
        ProcessDomain = Table.create <@ fun processDomain -> processDomain.Id @>
        Process = Table.create <@ fun cloudProcess -> cloudProcess.Id @>
    }

