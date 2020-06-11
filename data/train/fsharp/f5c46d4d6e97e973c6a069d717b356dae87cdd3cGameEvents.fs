[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module MAG.GameEvents

open MAG
open MAG.Events
open MAG.Game
open Chessie.ErrorHandling

let processCreated (c : GameCreated) game =
    match game with
    | Nothing ->
        Game.create c.Id c.Seed c.Players
    | _ ->
        fail ``Game already exists``

let private (|IsStance|_|) game =
    match game with
    | InProgress { Phase = Stance } -> Some ()
    | _ -> None

let private updatePlayer p card game =
    match game with
    | IsStance ->
        swapPlayer {
            p with
                Hand = p.Hand |> List.filter ((<>) card)
                Stance = card::p.Stance
        } game
    | _ ->
        swapPlayer {
            p with
                Hand = p.Hand |> List.filter ((<>) card)
                Stance = p.Stance |> List.filter ((<>) card)
                Discards = card::p.Discards
        } game

let processPlayed (played : CardMoved) game =
    trial {
        let newGame =
            match game with
            | Start init ->
                Start { init with InitiativeCards = (played.Player, played.Card)::init.InitiativeCards }
            | InProgress ({ Phase = Respond (target, attack, cards) } as openGame) ->
                InProgress { openGame with Phase = Respond (target, attack, played.Card::cards) }
            | InProgress ({ Phase = Play (Some target, cards)} as openGame) ->
                InProgress { openGame with Phase = Play (Some target, played.Card::cards) }
            | _ ->
                game

        return!
            newGame
            |> getPlayer played.Player
            >>= (fun p -> updatePlayer p played.Card newGame)
    }

let processDrawn (drawn : CardMoved) game =
    trial {
        let! p = getPlayer drawn.Player game
        let newGame =
            match game with
            | Start init ->
                Start { init with InitiativeCards = [] }
            | _ -> game
        return!
            swapPlayer {
                p with
                    Hand = drawn.Card::p.Hand
                    Deck = p.Deck |> List.filter ((<>) drawn.Card)
            } newGame
    }

let processDamageTaken (damage : DamageTaken) game =
    trial {
        let! p =
            getPlayer damage.Player game
            |> lift (fun p -> { p with Life = p.Life - damage.Damage })
        return!
            swapPlayer p game
    }

let processKnockedDown target game =
    trial {
        let! p =
            getPlayer target game
            |> lift (fun p -> { p with
                                    Stance = [] 
                                    Discards = List.concat [p.Stance;p.Discards]})
        return!
            swapPlayer p game
    }

let processTarget target game =
    match game with
    | InProgress ({ Phase = Play (None, []) } as openGame) ->
        InProgress { openGame with Phase = Play (Some target, []) }
        |> ok
    | _ ->
        fail ``Unexpected error``

let processPhaseComplete game =
    trial {
        match game with
        | InProgress ({ Phase = Stance } as openGame) ->
            let! next = nextPlayer game
            return InProgress { openGame with Turn = next; Phase = Play (None, []) }
        | InProgress ({ Phase = Play (Some target, cards) } as openGame) ->
            let! action = Card.toAction openGame.Turn cards
            return InProgress { openGame with Phase = Respond (target, action, []) }
        | InProgress ({ Phase = Respond (target, attack, cards)  } as openGame) ->
            match cards with
            | [] ->
                let! winner = existsWinner game
                match winner with
                | Some winner ->
                    let! players = getPlayers game
                    return Complete {
                        Winner = winner.Name
                        Id = openGame.Id
                        Seed = openGame.Seed
                        Players = players
                    }
                | None ->
                    let! p = getPlayer openGame.Turn game
                    if p.Life <= 0 then            
                        let! next = nextPlayer game
                        return
                            InProgress
                                { openGame with
                                    Turn = next
                                    Phase = Play (None, []) }
                    else
                        return InProgress { openGame with Phase = Stance }
            | _ ->
                let! counter = Card.toAction target cards
                match counter.Damage with
                | i when i <= 0<damage> ->
                    return InProgress { openGame with Phase = Stance }
                | _ ->
                    return InProgress { openGame with Phase = Respond(attack.Originator, counter, []) }
        | InProgress ({ Phase = Play _} as openGame) ->
            return InProgress { openGame with Phase = Stance }
        | _ ->
            return! fail ``Unexpected error``
    }

let processTurnStarted player game =
    trial {
        match game with
        | Start init ->
            let! order =
                init.InitiativeCards
                |> Game.orderInitiative 
                |> lift (List.map fst)
            return
                InProgress {
                    Id = init.Id
                    Players = init.Players
                    TurnOrder = order
                    Turn = player
                    Phase = Play (None, [])
                    Seed = init.Seed
                }
        | InProgress og ->
            return InProgress { og with Turn = player; Phase = Play (None, [])}
        | _ ->
            return! fail ``Unexpected error``
    }
    

let processCommandRecieved cmd game =
    ok game

let processEvent game event =
    match event with
    | Created c ->
        processCreated c game
    | Played cm ->
        processPlayed cm game
    | Drawn cm ->
        processDrawn cm game
    | DamageTaken dt ->
        processDamageTaken dt game
    | KnockedDown target ->
        processKnockedDown target.Target game
    | Target target ->
        processTarget target.Target game
    | PhaseComplete _ ->
        processPhaseComplete game
    | TurnStarted t ->
        processTurnStarted t.Player game
    | CommandRecieved cmd ->
        processCommandRecieved cmd game
