module Action.Miner
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory
open Action.Helpers

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

    beginAction creep
    |> doUnless isEmergency goToFlagIfInstructed
    |> doUnless isEmergency harvestEnergySources
    |> doWhen isEmergency (locateSpawnRoom homeSpawn)
    |> endAction memory
