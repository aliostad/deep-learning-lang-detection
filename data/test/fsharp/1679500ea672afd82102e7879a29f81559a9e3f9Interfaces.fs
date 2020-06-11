namespace AutonomousServiceBus

module Interfaces =
    open System
    open System.Collections.Generic

    type ASBEventArgs(msg:Dictionary<string, obj>) =
        inherit EventArgs()
        member this.Message = msg
    type ASBEventDelegate =
        delegate of obj * ASBEventArgs -> unit

    type IEventProvider =
        inherit IDisposable
        abstract Initialize: unit -> unit
        [<CLIEvent>]
        abstract OnEvent: IEvent<ASBEventDelegate, ASBEventArgs>
        abstract Name : string

    type IProcessProvider =
        abstract Process: Dictionary<string, obj> -> unit

    type IRule =
        abstract EventProvider : IEventProvider with get
        abstract ProcessProvider : IProcessProvider with get

