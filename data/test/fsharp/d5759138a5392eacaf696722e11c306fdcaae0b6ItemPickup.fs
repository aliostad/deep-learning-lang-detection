module ItemPickup

open State
open Notifications
open Constants

let pickupItem next state =
    {state with Items = next |> state.Items.Remove}

let pickupTreasure eventHandler next state =
    PlaySound AcquireLoot
    |> eventHandler
    state
    |> changeCounter Loot 1

let pickupTrap eventHandler next state =
    PlaySound TriggerTrap
    |> eventHandler
    let woundedState = 
        state
        |> changeCounter Wounds 1
        |> changeCounter TrapsSprung 1
    if (woundedState |> getCounter Wounds ) >= (woundedState |> getCounter Health) && (woundedState |> getCounter Potions) > 0 then
        woundedState
        |> changeCounter Potions -1
        |> setCounter Wounds 0
    else
        woundedState

let pickupKey eventHandler next state =
    PlaySound AcquireKey
    |> eventHandler
    state
    |> changeCounter Keys 1
    |> changeCounter KeysAcquired 1

let pickupSword eventHandler next state =
    PlaySound AcquireSword
    |> eventHandler
    state
    |> changeCounter Attack 1
    |> changeCounter SwordsAcquired 1

let pickupShield eventHandler next state =
    PlaySound AcquireShield
    |> eventHandler
    state
    |> changeCounter Defense 1
    |> changeCounter ShieldsAcquired 1

let pickupPotion eventHandler next state =
    PlaySound AcquirePotion
    |> eventHandler
    state
    |> changeCounter Potions 1
    |> changeCounter PotionsAcquired 1

let pickupHourglass eventHandler next state =
    PlaySound AcquireHourglass
    |> eventHandler
    {state with EndTime = (state |> getCounter TimeBonus) |> float |> state.EndTime.AddSeconds}
    |> changeCounter HourglassesAcquired 1


let pickupLoveInterest eventHandler next state =
    LoveInterest |> PlaySound |> eventHandler
    state
    |> changeCounter Health (state |> getCounter Health)

let pickupAmulet eventHandler next state =
    Amulet |> PlaySound |> eventHandler
    state
    |> setCounter CounterType.Amulet 1

let pickupExit eventHandler next state =
    Exit |> PlaySound |> eventHandler
    state
    |> setCounter CounterType.Stairs 1



