#light

let words n = 
    match n with    
    | 0UL -> "zero"
    | 1UL -> "one"  
    | 2UL -> "two"  
    | 3UL -> "three"  
    | 4UL -> "four"  
    | 5UL -> "five"  
    | 6UL -> "six"  
    | 7UL -> "seven"  
    | 8UL -> "eight"  
    | 9UL -> "nine"  
    | 10UL -> "ten"  
    | 11UL -> "eleven"  
    | 12UL -> "twelve"  
    | 13UL -> "thirteen"  
    | 14UL -> "fourteen"  
    | 15UL -> "fifteen"  
    | 16UL -> "sixteen"  
    | 17UL -> "seventeen"  
    | 18UL -> "eighteen"  
    | 19UL -> "nineteen"  
    | 20UL -> "twenty"  
    | 30UL -> "thirty"  
    | 40UL -> "forty"  
    | 50UL -> "fifty"  
    | 60UL -> "sixty"  
    | 70UL -> "seventy"  
    | 80UL -> "eighty"  
    | 90UL -> "ninety"  
    | 100UL -> "hundred"  
    | 1000UL -> "thousand"  
    | 1000000UL -> "million"  
    | 1000000000UL -> "billion"  
    | 1000000000000UL -> "trillion"  
    | 1000000000000000UL -> "quadrillion"  
    | 1000000000000000000UL -> "quintillion"
    | _ -> failwith "bad argument" 
    
let rec convertToWord n =
    match n with
    | n when n < 20UL ->
        words n
    | n when 20UL <= n               && n < 100UL ->
        processTens n
    | n when 100UL <= n              && n < 1000UL ->    
        processHundreds n
    | n when 1000UL <= n             && n < 1000000UL ->        
        processLargeNumber 1000UL n
    | n when 1000000UL <= n          && n < 1000000000UL ->        
        processLargeNumber 1000000UL n        
    | n when 1000000000UL <= n       && n < 1000000000000UL ->        
        processLargeNumber 1000000000UL n        
    | n when 1000000000000UL <= n    && n < 1000000000000000UL ->        
        processLargeNumber 1000000000000UL n        
    | n when 1000000000000000UL <= n && n < 1000000000000000000UL ->        
        processLargeNumber 1000000000000000UL n        
    | _ ->
        processLargeNumber 1000000000000000000UL n 
and processTens n = 
    let tens = (n / 10UL) * 10UL
    let units = n % 10UL
    if units > 0UL
    then (words tens) + "-" + (words units)
    else (words tens)
and processHundreds n =
    let hundreds = n / 100UL
    let remainder = n % 100UL; 
    if remainder > 0UL
    then (words hundreds) + " " + (words 100UL) + " and " + (convertToWord remainder)
    else (words hundreds) + " " + (words 100UL)
and processLargeNumber base n = 
    let numberOfBaseUnits = n / base;  
    let remainder = n % base;  
    if remainder > 0UL
    then (convertToWord numberOfBaseUnits) + " " + (words base) + ", " + (convertToWord remainder) 
    else (convertToWord numberOfBaseUnits) + " " + (words base)
    
let answer =
    {1UL..1000UL} |> 
    Seq.map (fun v -> convertToWord v) |> 
    Seq.map (fun v -> v |> Seq.filter(fun c -> c>='a' && c <='z')) |>
    Seq.map (fun sc -> sc |> Seq.length) |>
    Seq.fold (+) 0

print_any answer