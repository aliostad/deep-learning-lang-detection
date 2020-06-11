module Update

open State
open ItemPickup
open Explorer
open Initialization

let updateVisited next state =
    {state with Visited = next |> state.Visited.Add |> Set.union state.Visible}

let updateVisible locations state =
    {state with Visible = locations}

let updateLock next state =
    if next |> state.Locks.Contains then
        {state with Locks=next |> state.Locks.Remove}
        |> changeCounter Keys -1
    else
        state

let updateInventory eventHandler next state =
    match state.Items |> Map.tryFind next with
    | Some Treasure -> state |> pickupTreasure eventHandler next
    | Some Trap -> state |> pickupTrap eventHandler next
    | Some Key -> state |> pickupKey eventHandler next
    | Some Sword -> state |> pickupSword eventHandler next
    | Some Shield -> state |> pickupShield eventHandler next
    | Some Potion -> state |> pickupPotion eventHandler next
    | Some Hourglass -> state |> pickupHourglass eventHandler next
    | Some LoveInterest -> state |> pickupLoveInterest eventHandler next
    | Some ItemType.Amulet -> state |> pickupAmulet eventHandler next
    | Some Exit -> state |> pickupExit eventHandler next
    | None -> state
    |> pickupItem next

let updateState eventHandler next explorer =
    explorer.State
    |> updateVisited next
    |> updateVisible ((next, explorer.Orientation, explorer.Maze) |> visibleLocations)
    |> updateInventory eventHandler next



