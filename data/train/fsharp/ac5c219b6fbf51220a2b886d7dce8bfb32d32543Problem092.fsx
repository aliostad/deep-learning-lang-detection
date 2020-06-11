let max = 10000000

// build up a cache for all the numbers from 1 to 10 million
let cache = Array.init (max+1) (fun n -> 
    match n with 
    | 0 | 1 -> Some(false)
    | 89 -> Some(true)
    | _ -> None)

// define function to add the square of the digits in a number
let addSquaredDigits n =
    n.ToString().ToCharArray() 
    |> Array.sumBy (fun c -> pown (int(c.ToString())) 2)

// define function to take an initial number n and generate its number chain until
// it gets to a number whose subsequent chain ends with 1 or 89, which means that
// all previous numbers will also end in the same number
let processChain n = 
    let rec processChainRec n (list: int list) =
        if cache.[n] = None then processChainRec (addSquaredDigits n) (list@[n])
        else list |> List.iter (fun n' -> cache.[n'] <- cache.[n])
            
    processChainRec n []
    
// go through all the numbers from 2 to 10 million using the above function
[2..10000000] |> List.iter processChain

// how many numbers whose number chain ends with 89?
let answer = cache |> Array.filter (fun n -> n = Some(true)) |> Array.length