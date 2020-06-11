#r "../node_modules/fable-core/Fable.Core.dll"
#load "../library/Fable.Import.Screeps.fs"
#load "./model.domain.fs"
#load "./manage.memory.fs"
#load "./manage.construction.fs"
#load "./manage.spawn.fs"
#load "./manage.flag.fs"
#load "./action.helpers.fs"
#load "./action.harvest.fs"
#load "./action.upgrade.fs"
#load "./action.build.fs"
#load "./action.repair.fs"
#load "./action.guard.fs"
#load "./action.attack.fs"
#load "./action.claim.fs"
#load "./action.pioneer.fs"
#load "./action.transport.fs"
#load "./action.miner.fs"
#load "./action.tower.fs"

open System
open System.Collections.Generic
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain


let creepDispatcher name =
    match unbox Globals.Game.creeps?(name) with
    | Some c -> 
        let creep = c :> Creep
        let memory = Manage.Memory.MemoryInCreep.get creep
        let action =
            match memory.role with
            | Harvest -> Action.Harvest.run
            | Upgrade -> Action.Upgrade.run
            | Build -> Action.Build.run
            | Repair -> Action.Repair.run
            | Guard -> Action.Guard.run
            | Attacker -> Action.Attack.run
            | Claimer -> Action.Claim.run
            | Pioneer -> Action.Pioneer.run
            | Transport -> Action.Transport.run
            | Miner -> Action.Miner.run
            | NoRole -> ignore
        // printfn "dispatching %s to %A" creep.name memory.role
        action(creep, memory)
    | None -> ()

let spawnDispatcher name =
    match unbox Globals.Game.spawns?(name) with
    | Some spawn ->
        SpawnManager.run(spawn, Manage.Memory.MemoryInSpawn.get spawn)
    | None -> ()

let roomDispatcher name = 
    match unbox Globals.Game.rooms?(name) with
    | Some room -> Action.Tower.run (room)
    | None -> ()

let flagDispatcher creepKeys name =
    match unbox Globals.Game.flags?(name) with
    | Some flag -> Manage.Flag.run creepKeys flag
    | None -> ()

let loop() =
    Manage.Memory.GameTick.checkMemory()
    //Manage.Construction.GameTick.run (Manage.Memory.MemoryInGame.get())
    let creepKeys = getKeys Globals.Game.creeps
    getKeys Globals.Game.flags |> List.iter (flagDispatcher creepKeys)
    getKeys Globals.Game.spawns |> List.iter spawnDispatcher
    creepKeys |> List.iter creepDispatcher
    getKeys Globals.Game.rooms |> List.iter roomDispatcher 
     

// Init the game memory if necessary
match unbox Globals.Memory?game with
| Some g -> ()
| None ->
    Manage.Memory.MemoryInGame.set(
        {  creepCount = 0 })