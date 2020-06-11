module Action.Helpers
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory

(*
    Private Stuff
*)
let private energyStructures = new ResizeArray<string>[|Globals.STRUCTURE_SPAWN; Globals.STRUCTURE_EXTENSION; |]
let private resourceContainers = new ResizeArray<string>[|Globals.STRUCTURE_CONTAINER; Globals.STRUCTURE_STORAGE; |]

[<Emit("_.sum($0.store) < $0.storeCapacity")>]
let private resourceContainerNotFull (r: StructureStorage): bool = jsNative

let private resourceContainerHasSome (r: StructureContainer) resourceType =
    let resource =
        getKeys r.store 
        |> List.map (fun key -> (key, unbox<float> (r.store?(key)))) 
        |> List.filter (fun (key, amount) -> key = resourceType && amount > 0.)
    not (List.isEmpty resource)

let private findClosest<'T> (find: float) (f: obj) (pos: RoomPosition) =
    Some (pos.findClosestByPath<'T>(find, f))

let private findClosestActiveSources pos = 
    findClosest<Source> Globals.FIND_SOURCES_ACTIVE (filter<Source>(fun _ -> true)) pos

let private findClosestEnergyStructure pos = 
    let structureFilter = filter<EnergyStructure>(fun s -> 
        energyStructures.Contains(s.structureType) && s.energy < s.energyCapacity)
    findClosest<Structure> Globals.FIND_STRUCTURES structureFilter pos

let private findClosestEnergyContainer pos (resourceType: string, capAmount: float) = 
    let containerFilter = filter<StructureStorage>(fun r ->
        resourceContainers.Contains(r.structureType) 
        && resourceContainerNotFull r
        && r.store.Item(resourceType) < capAmount)
    findClosest<Storage> Globals.FIND_STRUCTURES containerFilter pos

let private findClosestTower pos = 
    let towerFilter = filter<Tower>(fun r ->
        r.structureType = Globals.STRUCTURE_TOWER && r.energy < r.energyCapacity)
    findClosest<Structure> Globals.FIND_STRUCTURES towerFilter pos

let private findClosestContainerWithSome pos resourceType =
    let containerFilter = filter<StructureContainer>(fun r ->
        resourceContainers.Contains(r.structureType) && resourceContainerHasSome r resourceType )
    findClosest<Structure> Globals.FIND_STRUCTURES containerFilter pos

(*
    Public Methods
*)
let doUnless condition action result =
    if not condition then
        action result
    else result

let doWhen condition action result =
    if condition then
        action result
    else result
let beginAction (creep: Creep): CreepActionResult =
    //printfn "%s beginning action.."
    Pass (creep, Idle)

let endAction memory (lastresult: CreepActionResult) =
    match lastresult with
    | Success (creep, action) ->
        // printfn "%s is %A " creep.name action 
        MemoryInCreep.set creep { memory with lastAction = action }
    | Pass (creep, action) -> ()
    | Failure r -> printfn "Failure code reported: %f" r

(* You can ALWAYS upgrade your controller *)
let upgradeController (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let memory = (MemoryInCreep.get creep)
        let controller = unbox<Controller> (Globals.Game.getObjectById(memory.controllerId))
        match (creep.upgradeController(controller)) with
        | r when r = Globals.OK -> Success (creep, Upgrading)
        | r when r = Globals.ERR_NOT_IN_RANGE ->
            creep.moveTo(U2.Case2 (box controller)) |> ignore
            Success (creep, Moving (Upgrading))
        | r -> Failure r
    | result -> result

let pickupDroppedResources (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match findClosest<Resource> Globals.FIND_DROPPED_RESOURCES (filter<Resource>(fun resource -> resource.resourceType = Globals.RESOURCE_ENERGY)) creep.pos with
        | Some target ->
            match creep.pickup(target) with
            | r when r = Globals.OK -> Success (creep, Harvesting)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case1 target.pos) |> ignore
                Success (creep, Moving Harvesting)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let harvestEnergySources (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match findClosestActiveSources creep.pos with
        | Some target ->
            match creep.harvest(U2.Case1 target) with
            | r when r = Globals.OK -> Success (creep, Harvesting)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case1 target.pos) |> ignore
                Success (creep, Moving Harvesting)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let withdrawEnergyFromContainer (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match (findClosestContainerWithSome creep.pos Globals.RESOURCE_ENERGY) with
        | Some target ->
            match creep.withdraw(target, Globals.RESOURCE_ENERGY) with
            | r when r = Globals.OK -> Success (creep, Harvesting)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case1 target.pos) |> ignore
                Success (creep, Moving Harvesting)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let dropNon (resourceType: string) (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        (getKeys creep.carry)
        |> List.filter (fun key -> key <> resourceType)
        |> List.iter (fun key -> creep.drop(key) |> ignore)
        Pass (creep, Idle)
    | result -> result

let transferEnergyToStructures (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match findClosestEnergyStructure creep.pos with
        | Some structure ->
            match (creep.transfer(U3.Case3 structure, Globals.RESOURCE_ENERGY)) with
            | r when r = Globals.OK -> Success (creep, Transferring)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box structure)) |> ignore
                Success (creep, Moving Transferring)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let transferEnergyToContainers capAmount (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match findClosestEnergyContainer creep.pos capAmount with
        | Some storage ->
            match (creep.transfer(U3.Case3 ((box storage) :?> Structure), Globals.RESOURCE_ENERGY)) with
            | r when r = Globals.OK -> Success (creep, Transferring)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box storage)) |> ignore
                Success (creep, Moving Transferring)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let transferEnergyToTowers (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match findClosestTower creep.pos with
        | Some tower ->
            match (creep.transfer(U3.Case3 tower, Globals.RESOURCE_ENERGY)) with
            | r when r = Globals.OK -> Success (creep, Transferring)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box tower)) |> ignore
                Success (creep, Moving Transferring)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let build (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match creep.pos.findClosestByPath(Globals.FIND_CONSTRUCTION_SITES) with
        | Some target ->
            match (creep.build(target)) with
            | r when r = Globals.OK -> Success (creep, Building ({ x = target.pos.x; y = target.pos.y; roomName = target.pos.roomName; }))
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box target)) |> ignore
                Success (creep, Moving (Building ({ x = target.pos.x; y = target.pos.y; roomName = target.pos.roomName; })))
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let quickRepair (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Building pos) ->
        let structure = 
            creep.room.lookForAt<Structure>(Globals.LOOK_STRUCTURES, (U2.Case1 (roomPosition(pos.x, pos.y, pos.roomName))))
            |> Seq.toList
            |> List.map (fun s -> printfn "look found a: %A" s; s)
            |> List.filter (fun s -> s.hits < s.hitsMax)
            |> List.tryHead
        match structure with
        | Some s ->
            printfn "%s attempting quick repair" creep.name
            match (creep.repair(U2.Case2 s)) with
            | r when r = Globals.OK -> Success (creep, Building (pos))
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let repairStructures (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match unbox (creep.pos.findClosestByPath<Structure>(Globals.FIND_STRUCTURES, filter<Structure>(fun s -> s.hits < s.hitsMax && s.structureType <> Globals.STRUCTURE_WALL))) with
        | Some s ->
            // printfn "%s attempting quick repair" creep.name
            match (creep.repair(U2.Case2 s)) with
            | r when r = Globals.OK -> Success (creep, Repairing)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box s)) |> ignore
                Success (creep, Moving (Repairing))
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

/// Goal 1: repair walls wth hits under 5000
/// Goal 2: the minimum hit goes up with the controller level
let repairWalls (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let controllerLevel = match creep.room.controller with | null -> 5000. | ctrlr -> ctrlr.level
        let minHits = 5000. * Math.Pow(controllerLevel, 2.)
        match unbox (creep.pos.findClosestByPath<Structure>(Globals.FIND_STRUCTURES, filter<Structure>(fun s -> s.hits < minHits && s.structureType = Globals.STRUCTURE_WALL))) with
        | Some s ->
            // printfn "%s attempting quick repair" creep.name
            match (creep.repair(U2.Case2 s)) with
            | r when r = Globals.OK -> Success (creep, Repairing)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box s)) |> ignore
                Success (creep, Moving (Repairing))
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result


let defendHostiles (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match unbox (creep.pos.findClosestByPath<Creep>(Globals.FIND_HOSTILE_CREEPS, filter<Creep>(fun c -> not (alliesList.Contains(c.owner.username))))) with
        | Some enemy ->
            match creep.attack(enemy) with
            | r when r = Globals.OK -> Success (creep, Defending)
            | r when r = Globals.ERR_NO_BODYPART ->
                // TODO: figure out how to fall back on another body
                Success (creep, Defending)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box enemy)) |> ignore
                Success (creep, Moving Defending)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let healFriends (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match unbox (creep.pos.findClosestByRange<Creep>(Globals.FIND_MY_CREEPS), filter<Creep>(fun c -> c.hits < c.hitsMax)) with
        | Some friend ->
            match creep.heal(friend) with
            | r when r = Globals.OK -> Success (creep, Defending)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case1 friend.pos) |> ignore
                Success (creep, Moving Defending)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let healSelf (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        if creep.hits < creep.hitsMax then
            match creep.heal(creep) with
            | r when r = Globals.OK -> Success (creep, Defending)
            | r -> Failure r
        else Pass (creep, Idle)
    | result -> result

let patrol (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let homeSpawn = unbox<Spawn> (Globals.Game.getObjectById(MemoryInCreep.get(creep).spawnId))
        // TODO: patrole the outer .. inner? .. wall.
        let flag = getFlags() |> List.filter (fun f -> f.name.StartsWith("Guard") && f.room.name = homeSpawn.room.name) |> List.tryHead
        match flag with
        | Some flag ->
            creep.moveTo(U2.Case1 flag.pos) |> ignore
            Success(creep, Moving Defending)
        | None -> Pass (creep, Idle)
    | result -> result

let locateFlag (targetFlag: Flag) (radius: float) (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let range = creep.pos.getRangeTo(U2.Case1 targetFlag.pos)
        if range > radius then
            match creep.moveTo(U2.Case1 targetFlag.pos) with
            | r when r = Globals.OK -> Success(creep, Moving Idle)
            | r -> Failure r
        else
            Pass (creep, Idle)
    | result -> result

let locateSpawnRoom (spawn: Spawn) (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        if creep.room.name = spawn.pos.roomName
        then Pass(creep, Idle)
        else
            match creep.moveByPath(U3.Case1 (creep.pos.findPathTo(U2.Case1 spawn.pos))) with
            | r when r = Globals.OK -> Success(creep, Moving Attacking)
            | r -> Failure r
    | result -> result
let locateRoom targetRoom (lastresult: CreepActionResult) =
    let withinBounds (x, y) =
        x < 45. && x > 1. && y > 1. && y < 45. 
    match lastresult with
    | Pass (creep, Idle) ->
        if creep.room.name = targetRoom.roomName && withinBounds (creep.pos.x, creep.pos.y)
        then 
            Pass(creep, Idle)
        else
            match creep.moveByPath(U3.Case1 (creep.pos.findPathTo(U2.Case1 (roomPosition(targetRoom.x, targetRoom.y, targetRoom.roomName))))) with
            | r when r = Globals.OK -> Success(creep, Moving Attacking)
            | r -> Failure r
    | result -> result

let attackHostileCreeps (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match unbox (creep.pos.findClosestByPath<Creep>(Globals.FIND_HOSTILE_CREEPS, filter<Creep>(fun c -> not (alliesList.Contains(c.owner.username))))) with
        | Some enemy ->
            match creep.attack(enemy) with
            | r when r = Globals.OK -> Success (creep, Defending)
            | r when r = Globals.ERR_NO_BODYPART ->
                // TODO: figure out how to fall back on another body
                Success (creep, Defending)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box enemy)) |> ignore
                Success (creep, Moving Defending)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let attackHostileStructures (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        match unbox (creep.pos.findClosestByPath<Structure>(Globals.FIND_HOSTILE_STRUCTURES, filter<Structure>(fun s -> s.structureType <> Globals.STRUCTURE_WALL))) with
        | Some enemy ->
            match creep.attack(enemy) with
            | r when r = Globals.OK -> Success (creep, Defending)
            | r when r = Globals.ERR_NO_BODYPART ->
                // TODO: figure out how to fall back on another body
                Success (creep, Defending)
            | r when r = Globals.ERR_NOT_IN_RANGE ->
                creep.moveTo(U2.Case2 (box enemy)) |> ignore
                Success (creep, Moving Defending)
            | r -> Failure r
        | None -> Pass (creep, Idle)
    | result -> result

let attackController (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let target = creep.room.controller
        // match (isNull target.owner), target.my with
        // | false, true -> Success(creep, Idle)
        // | false, false -> Success(creep, Idle)
        // | true, _ ->
        match creep.attackController(creep.room.controller) with
        | r when r = Globals.OK -> Success(creep, Claiming)
        | r when r = Globals.ERR_NOT_IN_RANGE ->
            creep.moveTo(U2.Case2 (box target)) |> ignore
            Success (creep, Moving Claiming)
        | r -> Failure r
    | result -> result

let claimController (lastresult: CreepActionResult) =
    match lastresult with
    | Pass (creep, Idle) ->
        let target = creep.room.controller
        // match (isNull target.owner), target.my with
        // | false, true -> Success(creep, Idle)
        // | false, false -> Success(creep, Idle)
        // | true, _ ->
        match creep.claimController(creep.room.controller) with
        | r when r = Globals.OK -> Success(creep, Claiming)
        | r when r = Globals.ERR_NOT_IN_RANGE ->
            creep.moveTo(U2.Case2 (box target)) |> ignore
            Success (creep, Moving Claiming)
        | r when r = Globals.ERR_GCL_NOT_ENOUGH ->
            // can't claim this yet..
            Pass (creep, Idle)
        | r -> Failure r
    | result -> result
