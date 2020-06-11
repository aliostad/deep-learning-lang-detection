type State = S1 | S2 | S3 | S23 | Unknown
type TransitionFunction = LW | LR | R | W | U
type Transition = State * TransitionFunction

let startingState = (S1, LW)
let finalState = S1

let test1 = [(S1, LW); (S23, R); (S23, U)] // 0
let test2 = test1 @ [(S23, U)] // -1
let test3 = startingState :: [] // -1
let test4 = startingState :: [(S23, LR); (S3, U)] // 0

let transition state fn =
    match state with
    | S1 -> (match fn with
        | LW -> S23
        | _ -> S1)
    | S2 -> (match fn with
        | R | W -> S2
        | U -> S1
        | _ -> Unknown)
    | S3 -> (match fn with
        | R | LR -> S3
        | U -> S1
        | _ -> Unknown)
    | S23 -> (match fn with
        | R -> S23
        | U -> S1
        | W -> S2
        | LR -> S3
        | _ -> Unknown)

let rec processDFA stateList =
    match stateList with
    | x :: ((y :: _) as xs) -> 
        let trans = transition (fst x) (snd x) 
        if trans <> fst y || trans = Unknown then -1 
        else processDFA xs
    | x :: [] -> if transition (fst x) (snd x) <> finalState then -1 else 0
    | _ -> -1

[<EntryPoint>]
let main argv = 
    assert (processDFA test1 = 0)
    assert (processDFA test2 = -1)
    assert (processDFA test3 = -1)
    assert (processDFA test4 = 0)
    0