/// Helper to manage depth first search of a problem.
/// next_f generates new states, and done_f test for the 
/// end of the search.
let solve next_f done_f initial =
    let rec go state =
        seq {
            if done_f state then
               yield state
            else
               for state' in next_f state do
                   yield! go state'
            }
    go initial


let one_to_nine () =
    let next_f (number, digits, idx) =
        let idx' = idx + 1
        seq {
            for d in digits do
               let number' = number * 10 + d
               if number' % idx' = 0 then
                   yield number', Set.remove d digits, idx'
            }

    let done_f (_, _, idx) = idx = 9

    solve next_f done_f (0, Set.ofList [1..9], 0)
    |> Seq.map (fun (num, _, _) -> num)
    |> Seq.head

printfn "solution: %A" (one_to_nine())
