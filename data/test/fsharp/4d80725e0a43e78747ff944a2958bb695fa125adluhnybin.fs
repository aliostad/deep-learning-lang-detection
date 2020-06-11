module LuhnyBin

open System
open System.IO

let IsNumber x =
    match x with
    | (x) when x >= 0 && x < 10 -> true
    | _ -> false
    
    
let GetNumberOfDigits numbers =
    Array.fold (fun acc el ->
        match IsNumber el with
        | true -> acc + 1
        | _ -> acc) 0 numbers
            
            
let TryAddDouble number =
    match number * 2 with
    | (x) when x >= 10 -> 1 + (x - 10)
    | (x) -> x          
            
            
let Double numbers remainder =
    Array.mapi (fun i x ->
        match (i % 2, remainder) with
        | (0, 0) -> TryAddDouble x
        | (0, _) | (_, 0) -> x
        | _ -> TryAddDouble x) numbers 

                
let CalculateSum numbers =
    Array.sum (Double numbers (numbers.Length % 2))
 
                     
let LuhnCheck numbers =
    let filtered = Array.filter (IsNumber) numbers
    match filtered.Length with
    | (x) when x <= 16 ->
        let sum = CalculateSum filtered
        match sum % 10 with
        | 0 -> true
        | _ -> false
    | _ -> false
    
    
let FormatValidLuhn numbers first last =
    Array.mapi (fun i x ->
            match i with
            | _ when i >= first && i <= last ->
                match IsNumber x with
                | true -> int 'X' - int '0'
                | _ -> x
            | _ -> x) numbers
        
        
let FindFirstNumberIndex numbers =
    Array.findIndex (fun x -> IsNumber x) numbers    

                
let rec Process x =
    match x with
    | (numbers : int[], _, first, _, _, newNumbers) when first >= numbers.Length - 1 ->
        newNumbers
    
    | (numbers, 14, first, last, acc, newNumbers : int[]) when last = numbers.Length - 1 && acc < 14 ->
        match LuhnCheck numbers.[first..last] with
        | true -> Process (numbers, 16, first + 1, first + 1, 0, FormatValidLuhn newNumbers first last)  
        | _ -> newNumbers
        
    | (numbers, digits, first, last, acc, newNumbers) when last = numbers.Length - 1 && acc < digits ->
        match LuhnCheck numbers.[first..last] with
        | true -> Process (numbers, 16, first + 1, first + 1, 0, FormatValidLuhn newNumbers first last)  
        | _ -> Process (numbers, digits - 1, first, first, 0, newNumbers)

    | (numbers, digits : int, first, last, acc, newNumbers) when acc = digits ->
        match LuhnCheck numbers.[first..last] with
        | true ->
            Process (numbers, 16, first + 1, first + 1, 0, FormatValidLuhn newNumbers first last)         
        | _ ->
            match digits with
            | 14 -> Process (numbers, 16, first + 1, first + 1, 0, newNumbers)
            | _ -> Process (numbers, digits - 1, first, first, 0, newNumbers)
               
    | (numbers, digits, first, last, acc, newNumbers) when digits > acc && IsNumber numbers.[last + 1] ->
        Process (numbers, digits, first, last + 1, acc + 1, newNumbers)
        
    | (numbers, digits, first, last, acc, newNumbers) ->
        Process (numbers, digits, first, last + 1, acc, newNumbers)


let Check numbers =
    let digits = GetNumberOfDigits numbers
    match digits with
    | (x) when x >= 14 ->
        let first = FindFirstNumberIndex numbers
        Process (numbers, 16, first, first, 0, numbers)
    | _ -> numbers


let ProcessLineFeed (input : string) : string =
    let intMap = Array.map (fun x -> int x - int '0') (input.ToCharArray ())  
    let chars = Array.map (fun x -> char (x + int '0')) (Check intMap)
    String.Concat chars


[<EntryPoint>]
let main args = 
    let stream = new StreamReader (Console.OpenStandardInput ())
    while not stream.EndOfStream do
        stdout.WriteLine(ProcessLineFeed (stream.ReadLine ()))
    0
