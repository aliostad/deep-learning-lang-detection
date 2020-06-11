module Action.Pioneer
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory
open Action.Helpers


/// Goal 1: head to the target room and start building
let run(creep: Creep, memory: CreepMemory) =
    // if creep is assigned a flag, relocate to the flag location, otherwise pass
    let relocate lastresult =
        match memory.actionFlag with
        | Some flagName ->
            let flag = unbox<Flag>(Globals.Game.flags?(flagName))
            let flagMem = MemoryInFlag.get flag
            locateFlag flag flagMem.actionRadius lastresult
        | None -> 
            lastresult

    let harvest() =
        beginAction creep
        |> relocate
        |> pickupDroppedResources
        |> withdrawEnergyFromContainer
        |> harvestEnergySources
        |> endAction memory

    let build() = 
        beginAction creep
        |> relocate
        |> build
        //|> repairStructures
        |> transferEnergyToStructures
        |> upgradeController
        |> endAction memory

    match ((MemoryInCreep.creepEnergy creep), memory.lastAction) with
    | (Empty, _)                    -> harvest()
    | (Full, _)                     -> build()
    | (Energy _, lastAction)        ->
        match lastAction with
        | Building pos -> build()
        | Harvesting -> harvest()
        | Moving action ->
            match action with
            | Building _ -> build()
            | Transferring -> build()
            | _ -> harvest()
        | _ -> build()
    