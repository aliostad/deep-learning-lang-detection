module Manage.Memory
open System
open System.Collections.Generic
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain

let private getMemoryObject (object) (name: string) defaultValue =
    match unbox object?(name) with
    | Some result -> box result
    | None -> box defaultValue

let private logDelete name =
    printfn "deleting %s" name
    name

module MemoryInGame =
    let get() =
        { creepCount = unbox<int> (getMemoryObject (Globals.Memory.Item("game")) "creepCount" 0) }
    let set (memory: GameMemory) =
        Globals.Memory?game <- memory


module MemoryInFlag =
    let get (flag: Flag) = 
        { 
            actionRole = unbox<RoleType> (getMemoryObject flag.memory "actionRole" NoRole)
            actionCreepCount = unbox<int> (getMemoryObject flag.memory "actionCreepCount" 0)
            actionRadius = unbox<float> (getMemoryObject flag.memory "actionRadius" 0.)
            actionSpawnId = unbox<string> (getMemoryObject flag.memory "actionSpawnId" "")
            currentCreepCount = unbox<int> (getMemoryObject flag.memory "currentCreepCount" 0)
            }
    
    let set (flag: Flag) (memory: FlagMemory) =
        flag.memory?actionRole <- memory.actionRole
        flag.memory?actionCreepCount <- memory.actionCreepCount
        flag.memory?actionRadius <- memory.actionRadius
        flag.memory?actionSpawnId <- memory.actionSpawnId
        flag.memory?currentCreepCount <- memory.currentCreepCount

    [<Emit("delete Memory.flags[$0]")>]
    let deleteFlagMemory name = jsNative
    let clearDeadFlagMems (flagKeys: string list) =
        // check for dead flag memories..
        let keys = ResizeArray<string>(flagKeys)
        getKeys Globals.Memory.flags
        |> List.filter (keys.Contains >> not)
        |> List.iter (logDelete >> deleteFlagMemory)
        flagKeys

module MemoryInCreep =
    (*
        Todos:
        - check for and set global priority flags such as:
            - attacked structures
            - ??
    *)
    let get (creep: Creep) =
        let controllerId = unbox<string> (getMemoryObject creep.memory "controllerId" "")
        let spawnId = unbox<string> (getMemoryObject creep.memory "spawnId" "")
        let role = unbox<RoleType> (getMemoryObject creep.memory "role" Harvest)
        let lastAction = unbox<CreepAction> (getMemoryObject creep.memory "lastAction" Idle)
        let actionFlag = unbox<string option> (getMemoryObject creep.memory "actionFlag" None)
        {
            controllerId = controllerId
            spawnId = spawnId
            actionFlag = actionFlag
            role = role
            lastAction = lastAction }

    let set (creep: Creep) (memory: CreepMemory) =
        let {controllerId=c; spawnId=s; role=r; lastAction=la} = memory
        creep.memory?controllerId <- c
        creep.memory?spawnId <- s
        creep.memory?role <- r
        creep.memory?lastAction <- la
        creep.memory?actionFlag <- memory.actionFlag

    let creepEnergy (creep: Creep) =
        match creep.carry.energy with
        | Some energy when energy = creep.carryCapacity -> Full
        | Some energy when energy > 0. -> Energy(energy)
        | _ -> Empty

    [<Emit("delete Memory.creeps[$0]")>]
    let deleteCreepMemory name = jsNative
    let clearDeadCreepMems (creepKeys: string list) =
        // check for dead creep memories..
        let keys = ResizeArray<string>(creepKeys)
        getKeys Globals.Memory.creeps
        |> List.filter (keys.Contains >> not)
        |> List.iter (logDelete >> deleteCreepMemory)
        creepKeys
    
    let setCurrentCreepCount (creepKeys: string list) =
        MemoryInGame.set({ MemoryInGame.get() with creepCount = creepKeys.Length})
        creepKeys

module MemoryInSpawn =
    let get (spawn: Spawn) =
        { 
            lastRoleItem = unbox<int> (getMemoryObject spawn.memory "lastRoleItem" 0)
            lastConstructionLevel =  unbox<int> (getMemoryObject spawn.memory "lastConstructionLevel" 0)
            spawnCreepCount = unbox<int> (getMemoryObject spawn.memory "spawnCreepCount" 0)
            areHostileCreepsInRoom = unbox<bool> (getMemoryObject spawn.memory "areHostileCreepsInRoom" false)
            constructionQueue = unbox<ConstructionItem list> (getMemoryObject (Globals.Memory.Item("game")) "constructionQueue" [])
            constructionItem = unbox<ConstructionItem option> (getMemoryObject (Globals.Memory.Item("game")) "constructionItem" None)
            }

    let set (spawn: Spawn) (memory: SpawnMemory) =
        let {lastRoleItem = r; lastConstructionLevel = lcl} = memory
        spawn.memory?lastRoleItem <- memory.lastRoleItem
        spawn.memory?lastConstructionLevel <- memory.lastConstructionLevel
        spawn.memory?spawnCreepCount <- memory.spawnCreepCount
        spawn.memory?areHostileCreepsInRoom <- memory.areHostileCreepsInRoom
        spawn.memory?constructionQueue <- memory.constructionQueue
        spawn.memory?constructionItem <- memory.constructionItem

    // Count the creeps assigned to a spawn that are NOT assigned to flags
    let getCreepCount (spawn: Spawn) =
        getKeys Globals.Game.creeps
        |> List.map (fun name -> unbox<Creep> (Globals.Game.creeps?(name)))
        |> List.filter (fun c ->
            let memory = MemoryInCreep.get c
            let noFlag = match memory.actionFlag with | Some flag -> false | None -> true 
            memory.spawnId = spawn.id && noFlag)
        |> List.length

    let getRoomFlags (spawn: Spawn) =
        // Find if there any hostile creeps with attack parts or ranged attacks
        let hostileCreepsInRoom = spawn.room.find(Globals.FIND_HOSTILE_CREEPS, filter<Creep>(fun c -> c.getActiveBodyparts(Globals.ATTACK) = 0.))
        (hostileCreepsInRoom.Count > 0)


    [<Emit("delete Memory.spawns[$0]")>]
    let deleteSpawnMemory name = jsNative
    let clearDeadSpawnMems (spawnKeys: string list) =
        let keys = ResizeArray<string>(spawnKeys)
        // check for dead spawn memories..
        getKeys Globals.Memory.spawns
        |> List.filter (keys.Contains >> not)
        |> List.iter (logDelete >> deleteSpawnMemory)
        spawnKeys
    
    let setSpawnGlobals (spawnKeys: string list) =
        let setGlobals (spawn: Spawn) =
            let roomFlags = getRoomFlags spawn
            let creepCount = getCreepCount spawn
            set spawn ({ get(spawn) with areHostileCreepsInRoom = roomFlags; spawnCreepCount = creepCount; })
    
        spawnKeys
        |> List.map (fun key -> unbox<Spawn>(Globals.Game.spawns?(key)))
        |> List.iter setGlobals

module ConstructionMemory =
    (*
        Set up a construction Q.  
        1. Init
        2. Add items
        3. Get next item 
    *)
    let create (spawn: Spawn) (items: ConstructionItem list) =
        MemoryInSpawn.set spawn ({ MemoryInSpawn.get(spawn: Spawn) with constructionItem = Some items.Head; constructionQueue = items.Tail })
    let enqueue (spawn: Spawn) (item: ConstructionItem) =
        let spawnMemory = MemoryInSpawn.get(spawn: Spawn)
        MemoryInSpawn.set spawn ({ spawnMemory with constructionQueue = item :: spawnMemory.constructionQueue })
    let dequeue (spawn: Spawn) =
        let spawnMemory = MemoryInSpawn.get(spawn: Spawn)
        match spawnMemory.constructionQueue with 
        | [] -> 
            MemoryInSpawn.set spawn ({ spawnMemory with constructionItem = None })
            None
        | hd :: tail ->
            MemoryInSpawn.set spawn ({ spawnMemory with constructionItem = Some hd; constructionQueue = tail })
            Some hd

module GameTick =
    let updateGlobals (spawnKeys, creepKeys, flagKeys) =
        MemoryInCreep.setCurrentCreepCount creepKeys |> ignore
        MemoryInSpawn.setSpawnGlobals spawnKeys
        (spawnKeys, creepKeys, flagKeys)
    let clearUnusedMemories (spawnKeys, creepKeys, flagKeys) =
        MemoryInSpawn.clearDeadSpawnMems spawnKeys |> ignore
        MemoryInCreep.clearDeadCreepMems creepKeys |> ignore
        MemoryInFlag.clearDeadFlagMems flagKeys |> ignore
        (spawnKeys, creepKeys, flagKeys)
    let checkMemory () =
        let creepKeys = getKeys Globals.Game.creeps
        let spawnKeys = getKeys Globals.Game.spawns
        let flagKeys = getKeys Globals.Game.flags

        (spawnKeys, creepKeys, flagKeys)
        |> updateGlobals
        |> clearUnusedMemories
        |> ignore 
        
        