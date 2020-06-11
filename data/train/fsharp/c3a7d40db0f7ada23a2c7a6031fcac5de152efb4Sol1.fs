module Sol1

let grid d = Array.create (d*d) 0
                
let sumR (grd:int array) d r =
     [0..d-1]|>List.map (fun i-> grd.[i+r*d])|>List.sum
    
let sumC (grd:int array) d c = 
    [0..d-1]|>List.map (fun i-> grd.[c+i*d])|>List.sum
    
let sumD (grd:int array) d =
    [0..d-1]|>List.map (fun i-> grd.[i+i*d])|>List.sum

let sumRD (grd:int array) d =
    [0..d-1]|>List.map (fun i-> grd.[(i+1)*d-i-1])|>List.sum
    
let test = [|6; 3; 3; 0; 5; 0; 4; 3; 0; 7; 1; 4; 1; 2; 4; 5|]

let isValid (grd:int array) d =
    let sd = sumD grd d
    sd = sumRD grd d &&
    sd = sumR grd d 0 &&
    sd = sumC grd d 0 &&
    ([1..d-1]|>List.forall (fun i -> sumR grd d i = sd)) &&
    ([1..d-1]|>List.forall (fun i -> sumC grd d i = sd))

let search d =
    let startGrd = grid d
    let rec doSearch l (current:int array)=        
        if l<d*d then                       
            seq{
             for i in 0..9 do
                let copy = Array.copy(current)                                                                              
                copy.SetValue(i,l)                     
                yield! doSearch (l+1) copy
           }
        else
            //if isValid current d then printfn "%A" current 
            seq{if isValid current d then yield current}
    doSearch 0 startGrd
    
let sol n = search n|>Seq.length

open System.Diagnostics
open System
let executeAndTime f = 
    Console.WriteLine ("Enter x:")
    let sw = Stopwatch.StartNew()
    let res = Console.ReadLine() |> Int32.Parse |> f 
    sw.Stop()
    res.ToString(),sw.Elapsed    
    

let main=
    let res,time=executeAndTime sol
    printfn "Solution=%s Duration=%.2f" (res) (time.TotalSeconds)
    Console.ReadLine()
    