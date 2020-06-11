module Manage.Flag
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory

(* 
Goals:
    - flags used to dispatch certain types of creeps to specific locations
    - quick create a flag {some name}_{RoleType}_{NumCreeps}_{Radius}_{SpawnName}_{EnergyMax}
        * ActionFlag_Attacker_2_5_SonOfTorgo -> send two attackers from SonOfTorgo to this location within 5 squares
        * ResourceFlag_Harvest_1_2_BorkTest -> send one harvester from BorkTest to this location within 2 squares 
        * GuardHereWithOneGuard_Guard_1_2_BorkTest -> go guard!
        * Resurrect_Pioneer_1_20_SonOfTorgo -> help to pioneer within a 20 square radius
        * KeepTowersFueled_Transport_1_4_BorkTest -> go keep the towers fueled up by grabbing energy from containers and refueling
        * KeepMiningSource_Miner_1_2_SonOfTorgo
    - params:
        - role
        - count
        - radius
        - spawnName
        - energyMax
    - spawning: 
        - the selected spawn should prioritize based on flags
        - needs to know the count of creeps assigned to a flag
        - flag is attached to creeps memory which spawned
    - creeps:
        - check for flag in memory, get targets from flag
*)


let parseFlagName (name: string) (creepCounter: string -> int) =
    let parts = name.Split('_')
    if parts.Length = 5 then
        let flagname = parts.[0]
        let actionRole = roleFromString parts.[1]
        let count = int (parts.[2])
        let radius = float (parts.[3])
        let actionSpawn = unbox<Spawn> (Globals.Game.spawns?(parts.[4]))
        let currentCreeps = creepCounter name
        Some { 
                actionRole = actionRole.Value
                actionCreepCount = int count
                actionRadius = float radius
                actionSpawnId = actionSpawn.id
                currentCreepCount = currentCreeps }
    else 
        None

let run (creepKeys: string list) (flag: Flag) =
    // count creeps with actionflags
    let creepsWithThisFlag flagName = 
        creepKeys 
        |> List.map (fun key -> unbox<Creep>(Globals.Game.creeps?(key)) |>  MemoryInCreep.get)
        |> List.filter (fun mem -> 
            match mem.actionFlag with
            | Some name when name = flagName -> true
            | _ -> false)
        |> List.length
    
    // update flag memory
    match parseFlagName flag.name creepsWithThisFlag with
    | Some flagmemory ->
        MemoryInFlag.set flag flagmemory
    | None -> ()
        // printfn "Failed to parse flag, %s" flag.name

    ()