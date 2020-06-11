module is.mjuk.prime

let removeMultiples n list =
    (* Remove all integers that is divisible by n including n from list *)
    List.filter (fun x -> if x%n = 0 then false else true) list

let rec processCandidates candidates primes =
    (* Recursive function which eliminates candidates *)
    match candidates with
    | [] -> primes
    | x :: xs ->
        (processCandidates
            (removeMultiples x xs)
            (x :: primes))

let findPrimes n =
    (* Find the integers which are prime up to n *)
    match n with
    | n when n < 2 -> []
    | _ -> List.rev (processCandidates ([3..2..n]) ([2]))

[<EntryPoint>]
let main args =
    printfn "%A" (findPrimes 100)
    // Return 0 for success
    0

