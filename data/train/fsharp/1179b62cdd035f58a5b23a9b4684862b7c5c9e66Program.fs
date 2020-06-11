open System

type Result = 
    | Ok 
    | Err 

let str xs = new String( List.toArray xs)

let rec parse acc = 
    function
        | '.' :: rest -> parse ('0'::acc)  rest
        | '-' :: '.' :: rest -> parse ('1'::acc)  rest
        | '-' :: '-' :: rest -> parse ('2'::acc)  rest
        | [] -> Ok, str <| List.rev acc 
        | x -> Err, str <| x
    
        

    
let process' (s:string) = 
    s.ToCharArray() 
    |> Array.toList 
    |> parse []
    
    |> function
        | Ok, r -> printfn "%A - расшифровано : %s" s r
        | Err, er -> printfn "%A - не удалось распознать %s" s er

[<EntryPoint>]
do
    process' ".-.--"
    process' "--."
    process' "-..-.--"
    while true do
        printf "Введите строку > " 
        let s = Console.ReadLine().Trim()
        if s = "q" then exit(0)
        process' s

        

    
