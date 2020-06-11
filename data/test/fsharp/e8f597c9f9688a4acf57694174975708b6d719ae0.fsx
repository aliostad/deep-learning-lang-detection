open System
open System.Collections.Generic

// event handler
type Handler = (unit->unit)

// imitates dialog system
let Dialogs = new Dictionary<string*string, Handler>()
// imitates killing events
let Kills = new Dictionary<string, Handler>()

type Player() =
    member x.GiveXP n = 
        printfn "Gained %d experience points" n
    member x.StartQuest(quest) =
        printfn "Starting quest '%s'" quest
    // simulating players actions
    member x.TalkTo(npc, node) =
        Dialogs.[npc, node]()
    member x.Kill(npc) =
        Kills.[npc]()

type Event =
    | Talk of Player * string * string // player talks with npc using given node
    | Kill of Player * string // player kills npc
type Quest = 
    | Phase of Event * Handler
    | Nothing

type QuestBuilder() =
    member x.Bind(v : Event, f) = 
        match v with
        | Talk(player, npc, node) -> 
            printfn "Player needs to talk with %s using node %s" npc node
            Dialogs.[(npc, node)] <- f // assign handler to dialog
            Talk(player, npc, node), f // or we could use that return type to do that?
        | Kill(player, npc) -> 
            printfn "Player needs to kill %s" npc
            Kills.[npc] <- f
            Kill(player, npc), f
        |> ignore
    member x.Zero() = 
        printfn "Zero"
        ()


let talk player npc node = Talk(player, npc, node)
let kill player npc = Kill(player, npc)
    
let quest = new QuestBuilder()

let beast = quest {
    let player = new Player()

    do! talk player "Rudolf" "KillBeast" // this is the beginning, we require player to talk with an npc using specified dialog node
    player.StartQuest("Beast") // and then, the rest will be called when player does this
    
    do! kill player "Beast" // so, when he talks to that npc, this piece is executed, and it attaches the rest, as the handler for kill event
    player.GiveXP(100) // and then, when monster is killed, this is executed
}

// let's simulate player
let player = new Player()
player.TalkTo("Rudolf", "KillBeast")
player.Kill("Beast")