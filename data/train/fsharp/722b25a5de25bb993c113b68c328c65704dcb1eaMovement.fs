module Movement

open Explorer
open State
open Update
open Notifications
open Initialization
open Constants

let mustUnlock next (explorer: Explorer<Cardinal.Direction, State>) =
    next
    |> explorer.State.Locks.Contains

let unlockLocation eventHandler next explorer =
    PlaySound UnlockDoor
    |> eventHandler
    {explorer with State = explorer.State |> updateLock next |> changeCounter DoorsUnlocked 1}

let mustFight next (explorer: Explorer<Cardinal.Direction, State>) =
    next
    |> explorer.State.Monsters.ContainsKey

let addMonsterDamage next damage (state: State) =
    let monsterInstance = state.Monsters.[next]
    let descriptor = Monsters.descriptors.[monsterInstance.Type]
    if monsterInstance.Damage + damage >= descriptor.Health then
        {state with Monsters = state.Monsters |> Map.remove next}
        |> incrementKills monsterInstance.Type
    else
        {state with Monsters = state.Monsters |> Map.add next {monsterInstance with Damage = monsterInstance.Damage + damage} }

let getMonsterStats next state =
    let monsterInstance = state.Monsters.[next]
    let descriptor = Monsters.descriptors.[monsterInstance.Type]
    (descriptor.Attack, descriptor.Defense)

let getPlayerStats state =
    (state |> getCounter Attack, state |> getCounter Defense)

let calculateDamage attack defense =
    if attack > defense then 
        attack - defense 
    else 
        0

let adjustPlayerDefense defense attack savingThrow=
    if defense > 0 && Utility.random.Next(savingThrow) < attack then 
        defense - 1 
    else 
        defense

let takePlayerDamage damage state =
    if ((state |> getCounter Wounds) + damage) >= (state |> getCounter Health) then
        if state |> getCounter Potions > 0 then
            (DrinkPotion |> PlaySound, (state |> changeCounter Potions -1 |> setCounter Wounds 0))
        else
            (Death |> PlaySound, (state |> setCounter Wounds (state |> getCounter Health)))
    else
        (Fight |> PlaySound, (state |> changeCounter Wounds damage))

let fightLocation eventHandler next (explorer: Explorer<Cardinal.Direction, State>) =
    let playerAttack, playerDefense = explorer.State |> getPlayerStats
    let monsterAttack, monsterDefense = explorer.State |> getMonsterStats next
    let monsterDamage = calculateDamage playerAttack monsterDefense
    let playerDamage = calculateDamage monsterAttack playerDefense
    let newPlayerDefense = adjustPlayerDefense playerDefense monsterAttack (explorer.State |> getCounter DefenseSavingThrow)
    let sfx, damagedState = explorer.State |> takePlayerDamage playerDamage
    sfx |> eventHandler
    {explorer with 
        State = 
            damagedState
            |> setCounter Defense newPlayerDefense 
            |> addMonsterDamage next monsterDamage}

let canEnter next (explorer: Explorer<Cardinal.Direction, State>) =
    let canGo = next |> explorer.Maze.[explorer.Position].Contains
    let isLocked = explorer |> mustUnlock next
    let hasKey = explorer.State |> getCounter Keys > 0
    canGo && if isLocked then hasKey else true

let enterLocation eventHandler next explorer =
    {explorer with 
        Position = next; 
        State = explorer |> updateState eventHandler next}

let moveAction eventHandler (explorer: Explorer<Cardinal.Direction, State>) = 
    let next =
        explorer.Orientation
        |> Cardinal.walk explorer.Position
    if explorer |> canEnter next then
        if explorer |> mustUnlock next then
            explorer
            |> unlockLocation eventHandler next
        elif explorer |> mustFight next then
            explorer
            |> fightLocation eventHandler next
        else
            explorer
            |> enterLocation eventHandler next
    else
        Blocked |> PlaySound |> eventHandler
        explorer

let turnAction eventHandler direction explorer = 
    {explorer with Orientation = direction; State={explorer.State with Visited = explorer.State.Visited |> Set.union explorer.State.Visible; Visible = visibleLocations(explorer.Position, direction, explorer.Maze)}}
