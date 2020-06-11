module Action.Transport
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory.MemoryInCreep
open Action.Helpers

/// Goal: look to transport energy from storage to towers when under attack

let run(creep: Creep, memory: CreepMemory) =
    let harvest() =
        beginAction creep
        |> pickupDroppedResources
        |> withdrawEnergyFromContainer
        |> endAction memory

    let transfer() = 
        beginAction creep
        |> transferEnergyToTowers
        |> transferEnergyToContainers (Globals.RESOURCE_ENERGY, 1000000.)
        |> endAction memory

    match ((creepEnergy creep), memory.lastAction) with
    | (Empty, _)    -> harvest()
    | (Full, _)     -> transfer() // only takes a single tick to transfer
    | (Energy _, lastaction) ->
        match lastaction with
        | Harvesting -> harvest()
        | Moving action ->
            match action with
            | Harvesting -> harvest()
            | _ -> transfer()
        | _ -> transfer()