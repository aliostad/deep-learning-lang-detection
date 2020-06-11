module Action.Harvest
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory
open Action.Helpers
(*
    TODOs:
    - WATCH OUT for hostile creeps, make sure to stay of ranged attacks
*)

let run(creep: Creep, memory: CreepMemory) =
    let homeSpawn = unbox<Spawn> (Globals.Game.getObjectById(memory.spawnId))
    let spawnMemory = MemoryInSpawn.get homeSpawn
    let hostilCreepsInRoom = 
        let hostiles = creep.room.find(Globals.FIND_HOSTILE_CREEPS, filter<Creep>(fun c -> c.getActiveBodyparts(Globals.ATTACK) = 0.))
        hostiles.Count > 0
    
    let isEmergency = 
        spawnMemory.areHostileCreepsInRoom || hostilCreepsInRoom

    let goToFlagIfInstructed lastresult =
        match memory.actionFlag with
        | Some flagName ->
            let flag = unbox<Flag>(Globals.Game.flags?(flagName))
            let flagMem = MemoryInFlag.get flag
            locateFlag flag flagMem.actionRadius lastresult
        | None -> lastresult

    let harvest() =
        beginAction creep
        |> pickupDroppedResources
        |> doUnless isEmergency goToFlagIfInstructed
        |> doUnless isEmergency harvestEnergySources
        |> doWhen isEmergency (locateSpawnRoom homeSpawn)
        |> doWhen isEmergency withdrawEnergyFromContainer
        |> endAction memory

    let transfer() = 
        beginAction creep
        |> locateSpawnRoom homeSpawn
        |> transferEnergyToStructures
        |> transferEnergyToContainers (Globals.RESOURCE_ENERGY, 20000.)
        |> transferEnergyToTowers
        |> upgradeController
        |> endAction memory

    match ((MemoryInCreep.creepEnergy creep), memory.lastAction) with
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


