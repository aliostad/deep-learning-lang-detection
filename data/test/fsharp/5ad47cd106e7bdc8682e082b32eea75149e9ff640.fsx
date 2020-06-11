// define in engine
type ICritter =
        abstract member DoTalk : ICritter*string -> unit
        abstract member Talk : Event<string> with get

//
type Npc(name) =
    let talk = new Event<string>()
    interface ICritter with
        member self.DoTalk(other, phrase) =
            printfn "%s says '%s' to %s"  name phrase "some other npc"
            other.Talk.Trigger(phrase)
        member self.Talk with get() = talk
    override self.ToString() = name

// in script engine
type Action =
    | Talk of ICritter*ICritter*string

let mutable actions = List.empty

let talk (phrase: string) (npc: ICritter) (player: ICritter) handler =
    actions <- Talk(player, npc, phrase) :: actions
    npc.Talk.Publish
    |> Event.filter (fun s -> s = phrase)
    |> Event.add handler

// then, in script
let player = Npc("player")
let npc = Npc("ginger")

player |> talk "Hello" npc
<| fun s ->
    printfn "handler!"

