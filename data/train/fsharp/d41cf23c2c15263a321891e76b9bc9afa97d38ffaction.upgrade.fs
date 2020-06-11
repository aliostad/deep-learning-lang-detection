module Action.Upgrade
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory.MemoryInCreep
open Action.Helpers

let run(creep: Creep, memory: CreepMemory) =
    let harvest() =
        beginAction creep
        |> pickupDroppedResources
        |> dropNon Globals.RESOURCE_ENERGY
        |> harvestEnergySources
        |> endAction memory

    let upgrade() =
        beginAction creep
        |> upgradeController
        |> endAction memory

    match ((creepEnergy creep), memory.lastAction) with
    | (Empty, _)                    -> harvest()
    | (Full, _)                     -> upgrade()
    | (Energy _, lastAction)        ->
        match lastAction with
        | Harvesting -> harvest()
        | Moving action ->
            match action with
            | Upgrading -> upgrade()
            | _ -> harvest()
        | _ -> upgrade()
