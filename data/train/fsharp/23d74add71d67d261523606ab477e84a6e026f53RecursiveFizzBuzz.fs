module RecursiveFizzBuzz

let PrintFizz x = 
    if x % 3 = 0 then "Fizz"
    else ""

let PrintBuzz x y =
    if x % 5 = 0 then y + "Buzz"
    else y
    
let PrintNumber (x:int) y =
    if y = "" then x.ToString()
    else y
    
let ProcessFizzBuzzNumber x =
    PrintFizz x |> PrintBuzz x |> PrintNumber x


let rec RecursiveFizzBuzz start max =
    if start < max 
    then (ProcessFizzBuzzNumber start) + "\n" + RecursiveFizzBuzz (start+1) max
    else (ProcessFizzBuzzNumber start)


let rec TailRecursiveFizzBuzz start max acc =
    if start <= max 
    then TailRecursiveFizzBuzz (start+1) max 
            (acc + (if acc = "" then "" else "\n") + (ProcessFizzBuzzNumber start))
    else acc