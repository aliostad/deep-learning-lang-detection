module Action.Claim
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory
open Action.Helpers



/// Goal 1: head to the target room and attack everything
// TODO: figure out why the locatRoom function isn't working quite right
let run(creep: Creep, memory: CreepMemory) =
    let relocate lastresult =
        match memory.actionFlag with
        | Some flagName ->
            let flag = unbox<Flag>(Globals.Game.flags?(flagName))
            let flagMem = MemoryInFlag.get flag
            locateFlag flag flagMem.actionRadius lastresult
        | None -> 
            lastresult

    beginAction creep
    |> relocate
    //|> attackController
    |> claimController
    //|> reserveController
    |> endAction memory
