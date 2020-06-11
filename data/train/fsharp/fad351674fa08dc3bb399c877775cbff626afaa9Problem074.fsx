open System.Collections.Generic
 
// factorial function
let factorial n = if n = 0 then 1 else [1..n] |> List.reduce (fun acc x -> acc * x)

// create a cache of sorts to help improve performance and prepopulate them
let factorials, terms = new Dictionary<int, int>(), new Dictionary<int, int>()
terms.Add(169, 3)
terms.Add(871, 2)
terms.Add(872, 2)
[0..9] |> List.iter (fun n -> factorials.[n] <- factorial n)

// get the digits of a number into an array
let getDigits n = n.ToString().ToCharArray() |> Array.map (fun c -> int(c.ToString()))
 
// get the sum of the factorials of a number's digits
let getDigitsFactorialSum n = getDigits(n) |> Array.sumBy (fun n -> factorials.[n])

// define function to take an initial number n and generate its number chain until
// it gets to a number whose subsequent chain ends with 1 or 89, which means that
// all previous numbers will also end in the same number
let processChain n = 
    let rec processChainRec n (list: int list) =
        if terms.ContainsKey(n) 
        then
            let totalLen = list.Length + terms.[n] 
            list |> List.iteri (fun i n' -> terms.[n'] <- (totalLen - i))
        else
            // does this number exist in the current list?
            let index = List.tryFindIndex (fun n' -> n' = n) list

            // if the number doesn't exist in the list then continue
            if index = None 
            then processChainRec (getDigitsFactorialSum n) (list@[n])
            else 
                // otherwise, we're done
                [0..(Option.get index)] 
                |> List.map (fun i -> list.[i]) 
                |> List.iteri (fun i n' -> terms.[n'] <- list.Length - i)

    processChainRec n []

let answer = 
    [2..1000000] |> List.iter processChain
    terms |> Seq.filter (fun kvp -> kvp.Value = 60) |> Seq.length