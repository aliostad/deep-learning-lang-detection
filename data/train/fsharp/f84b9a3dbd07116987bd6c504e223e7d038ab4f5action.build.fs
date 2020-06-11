module Action.Build
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory
open Action.Helpers

(*
    Todos:
    - fix quickRepair of Ramparts
*)
let run(creep: Creep, memory: CreepMemory) =
    let homeSpawn = unbox<Spawn> (Globals.Game.getObjectById(memory.spawnId))
    let spawnMemory = MemoryInSpawn.get homeSpawn
    let isEmergency = spawnMemory.areHostileCreepsInRoom

    let harvest() =
        beginAction creep
        |> pickupDroppedResources
        |> doUnless isEmergency harvestEnergySources
        |> doWhen isEmergency withdrawEnergyFromContainer
        |> endAction memory

    let build() = 
        beginAction creep
        |> build    
        |> repairStructures
        |> doUnless isEmergency upgradeController
        |> doWhen isEmergency repairWalls
        |> endAction memory

    let repairNewStructure (existingAction) =
        (Pass (creep, existingAction))
        |> quickRepair
        |> endAction memory

    match ((MemoryInCreep.creepEnergy creep), memory.lastAction) with
    | (Empty, _)                    -> harvest()
    | (Full, _)                     -> build()
    | (Energy _, lastAction)        ->
        match lastAction with
        | Building pos -> 
            // if the thing we were just building is no longer a construction site, attempt a quick repair on any structures that were built
            let thing = creep.room.lookForAt<ConstructionSite>(Globals.LOOK_CONSTRUCTION_SITES, U2.Case1 (roomPosition (pos.x, pos.y, pos.roomName)))
            if thing.Count > 0
            then build()
            else repairNewStructure(lastAction)
        | Harvesting -> harvest()
        | Moving action ->
            match action with
            | Harvesting -> harvest()
            | _ -> build()
        | _ -> build()
