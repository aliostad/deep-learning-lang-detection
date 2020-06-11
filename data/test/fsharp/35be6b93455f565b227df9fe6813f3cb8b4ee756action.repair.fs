module Action.Repair
open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Model.Domain
open Manage.Memory.MemoryInCreep
open Action.Helpers

(*
    Todos:
    - find energy from alternate sources
    - immediately repair an item that's just been built - X
*)

let run(creep: Creep, memory: CreepMemory) =
    let harvest() =
        beginAction creep
        |> pickupDroppedResources
        |> harvestEnergySources
        |> endAction memory

    let repair () = 
        beginAction creep
        |> repairStructures
        |> repairWalls
        |> build
        |> upgradeController
        |> endAction memory

    match ((creepEnergy creep), memory.lastAction) with
    | (Empty, _)                    -> harvest()
    | (Full, _)                     -> repair()
    | (Energy _, lastAction)        ->
        match lastAction with
        | Harvesting -> harvest()
        | Moving action ->
            match action with
            | Harvesting -> harvest()
            | _ -> repair()
        | _ -> repair()
