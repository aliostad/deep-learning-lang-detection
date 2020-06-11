module Manage.Construction
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory

type BoxArea = {
    top: float;
    left: float;
    bottom: float;
    right: float;
}

let defaultToString x =
    match x with
    | Some y -> y
    | None -> ""

let constructionItemStatus item =
    let pos = roomPosition (item.position.x, item.position.y, item.position.roomName)
    let whatsHere = pos.look()
    let hasConstructionSite = whatsHere |> Seq.exists (fun r -> r.``type`` = "constructionSite")
    let hasStructure = whatsHere |> Seq.exists (fun res -> 
        res.``type`` = "structure"
        && res.structure.IsSome
        && res.structure.Value.structureType = item.structureType)
    //printfn "construction status: %b %b %A" hasConstructionSite hasStructure whatsHere 
    match hasConstructionSite, hasStructure with
    | false, false -> Unconstructed
    | false, true -> Completed
    | true, _ -> Inprogress

let pathToTuple (path: PathStep seq) = 
    path |> Seq.map (fun res -> (res.x, res.y))

let queueConstruction (spawn: Spawn) (structure: string) (path : (float * float) seq) =
    path |> Seq.iter (fun (x,y) -> Memory.ConstructionMemory.enqueue spawn { position = {x = x; y = y; roomName = spawn.room.name}; structureType = structure;})

let adjacentPositions (x, y) =
    [
        (x - 1., y - 1.); (x, y - 1.); (x + 1., y - 1.);
        (x - 1., y);  (x + 1., y);
        (x - 1., y + 1.); (x, y + 1.); (x + 1., y + 1.);
        ]
let adjacentBox (x, y) =
    {
        top = y - 1.;
        left = x - 1.;
        bottom = y + 1.;
        right = x + 1.;}
(*
Construction Helpers
- determine walls to be built around the Room
- determine placement of the spawn?

idea: list of construction projects to complete in order
 - roads around the spawn
 - roads to each source
 - roads to the controller
 - extensions along the roads
 - walls around the perimeter
 - ramparts close to entrances
 - roads to exits
 - roads to sources in other rooms
 - roads to minerals

*)
module Projects =
    let isPositionAvailable (room: Room) (x, y) =
        // check to make sure there's no structure and only plain or swamp terrain
        room.lookAt(x, y)
        |> Seq.forall
            (fun res -> 
                res.terrain.IsSome && (
                    (defaultToString res.terrain) = "plain" || (defaultToString res.terrain) = "swamp"
                ))

    let createRoadsAround (spawn: Spawn) (pos: RoomPosition) =
        let room = unbox<Room>(Globals.Game.rooms?(pos.roomName))
        adjacentPositions (pos.x, pos.y)
        |> Seq.filter (isPositionAvailable room)     
        |> queueConstruction spawn Globals.STRUCTURE_ROAD

    let getSourcePositionsInRoom (room: Room) =
        room.find<Source>(Globals.FIND_SOURCES_ACTIVE)
        |> Seq.map (fun s -> s.pos)

    /// Goal 1: create walls within 1 square of all 4 edges - DONE
    /// Goal 2: create walls on the outer edges that block off exits
    /// Goal 3: leave gaps for Ramparts that allow my creeps to pass through
    let createOuterWalls (spawn: Spawn) (room: Room) =
        let wallPositions = 
            unbox<ResizeArray<LookAtResultWithPos>> (box (room.lookAtArea(0.,0.,49.,49., true)))
            |> Seq.filter (fun res -> 
                isPositionAvailable room (res.x, res.y)
                && (
                    (res.x = 4. && res.y >= 4. && res.y <= 45.)
                    ||
                    (res.x = 45. && res.y >= 4. && res.y <= 45.)
                    ||
                    (res.y = 4. && res.x >= 4. && res.x <= 45.)
                    || 
                    (res.y = 45. && res.x >= 4. && res.x <= 45.)
                ))
            |> Seq.map (fun res -> (res.x, res.y))
        //printfn "proposed positions: %A" wallPositions
        wallPositions |> queueConstruction spawn Globals.STRUCTURE_WALL

    let createRoadsFromPosToSources (spawn: Spawn) (pos: RoomPosition) =
        let room = unbox<Room>(Globals.Game.rooms?(pos.roomName))
        let findPathOpts = 
            createObj [
                "ignoreCreeps" ==> true
                "ignoreRoads" ==> false
                ] :?> FindPathOpts
        getSourcePositionsInRoom room
        |> Seq.collect (fun spos -> pos.findPathTo(U2.Case1 spos, findPathOpts))
        |> pathToTuple
        |> Seq.filter (isPositionAvailable room)
        |> queueConstruction spawn Globals.STRUCTURE_ROAD

    /// Find places to build x extensions
    /// Optimal: along sides of roads -- get path to sources, look for places to build extensions
    let createExtensions (spawn: Spawn) x =
        printfn "Queuing %i extensions" x
        let findPathOpts = 
            createObj [
                "ignoreCreeps" ==> true
                "ignoreRoads" ==> false
                ] :?> FindPathOpts
        let pathsteps =
            getSourcePositionsInRoom spawn.room
            |> Seq.collect (fun s -> spawn.pos.findPathTo(U2.Case2 (box s), findPathOpts))

        printfn "Path: %A" pathsteps
        let onPath (x, y) = pathsteps |> Seq.exists (fun p -> p.x = x && p.y = y)
        let hasStructure (x, y) structurePositions = 
            structurePositions |> Seq.exists (fun (px, py) -> px = x && py = y)

        pathsteps
        |> Seq.collect (fun pos ->
            let area = adjacentBox (pos.x, pos.y)
            printfn "path area: %A" area
            let areaList = unbox<ResizeArray<LookAtResultWithPos>> (box (spawn.room.lookAtArea(area.top, area.left, area.bottom, area.right, true)))
            let structurePositions = 
                areaList 
                |> Seq.filter (fun res -> res.``type`` = Globals.LOOK_STRUCTURES) 
                |> Seq.map (fun res -> (res.x, res.y))
            //printfn "area list: %A" areaList
            //printfn "structure list: %A" structurePositions
                        
            // create a list of positions around the path that have terrain and no other structures
            let extensionList =
                areaList
                |> Seq.filter (fun res -> 
                    (not (onPath(res.x, res.y)))
                    && (not (hasStructure (res.x, res.y) structurePositions)) 
                    && (res.``type`` = Globals.LOOK_TERRAIN)
                    && ((defaultToString res.terrain) = "plain" || (defaultToString res.terrain) = "swamp")
                    )
                |> Seq.map (fun res -> (res.x, res.y))
            printfn "extension list: %A" extensionList
            extensionList)
        |> Seq.take x
        |> (queueConstruction spawn Globals.STRUCTURE_EXTENSION)

    /// build storage containers

    /// build towers

    /// build ramparts

module GameTick =

    let projectList = [
        (fun (spawn: Spawn) _ -> Projects.createRoadsFromPosToSources spawn spawn.pos; true);
        (fun (spawn: Spawn) _ -> Projects.createRoadsAround spawn spawn.pos; true);
        (fun (spawn: Spawn) _ -> Projects.getSourcePositionsInRoom spawn.room |> Seq.iter (Projects.createRoadsAround spawn); true);
        (fun (spawn: Spawn) level -> if level >= 2. then Projects.createExtensions spawn 5; true else false);
        (fun (spawn: Spawn) _ -> Projects.createRoadsFromPosToSources spawn spawn.room.controller.pos; true);
        (fun (spawn: Spawn) level -> if level >= 3. then Projects.createExtensions spawn 5; true else false);
        // TODO: build tower
        (fun (spawn: Spawn) _ -> Projects.createOuterWalls spawn spawn.room; true);
        (fun (spawn: Spawn) level -> if level >= 4. then Projects.createExtensions spawn 5; true else false);
        (fun (spawn: Spawn) level -> if level >= 5. then Projects.createExtensions spawn 5; true else false);
        (fun (spawn: Spawn) level -> if level >= 6. then Projects.createExtensions spawn 5; true else false);
        (fun (spawn: Spawn) level -> if level >= 7. then Projects.createExtensions spawn 5; true else false);
        (fun (spawn: Spawn) level -> if level >= 8. then Projects.createExtensions spawn 5; true else false);
        ]

    let checkConstruction (memory: SpawnMemory) (spawn: Spawn) =
        let constructionLevel = memory.lastConstructionLevel
        if constructionLevel < projectList.Length then
            let controllerLevel = spawn.room.controller.level
            let nextBuilder = projectList.Item(memory.lastConstructionLevel)
            match nextBuilder spawn controllerLevel with
            | true -> MemoryInSpawn.set spawn { memory with lastConstructionLevel = constructionLevel + 1 }
            | false -> ()
        spawn
    
    let rec handleConstruction (spawn: Spawn) item =
        match constructionItemStatus item with
        | Unconstructed ->
            let room = unbox<Room>(Globals.Game.rooms?(item.position.roomName))
            room.createConstructionSite(item.position.x, item.position.y, item.structureType) |> printfn "%s at %A result: %f" item.structureType item.position
        | Completed -> 
            match Memory.ConstructionMemory.dequeue(spawn) with
            | Some item -> handleConstruction spawn item
            | None -> () 
        | Inprogress -> ()
    
    let run (spawn: Spawn) (spawnMemory: SpawnMemory) =
        // check for items in the queue
        match spawnMemory.constructionItem with
        | Some item ->
            // check if it needs a construction site or if it has already been built
            handleConstruction spawn item
        | None ->
            // check if there's anything in the queue
            match Memory.ConstructionMemory.dequeue(spawn) with
            | Some item -> handleConstruction spawn item
            | None -> () 