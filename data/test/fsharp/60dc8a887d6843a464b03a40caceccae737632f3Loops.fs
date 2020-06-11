module Loops //Location 344

let Item [] =

let processItems (items : Item []) = for i in 0 .. items.Length do let item = items.[i] in proc item

(* linked List example *)

let rec processItems proc = function | [] -> ()
                                     | head :: tail -> proc head; processItems tail


let rec processItems proc = function | [] -> ()
                                     | hd :: tl -> proc hd; processItems proc tl

(* This is implemented as List.iter *)
(* Generic versions are in Seq.iter *)


(* example *)
let data = ["Cats";"Dogs";"Mice";"Elephants"]
data |> List.iter (fun x -> printfn "item: %s" x)

(* example 2 *)
let data = ["Cats";"Dogs";"Mice";"Elephants"]
let rec processItems proc = function | [] -> ()
                                     | hd :: tl -> proc hd; processItems proc tl

data |> processItems(fun x -> printfn "item: %s" x)

(* Example 3 *)
let data =  [int16 1 ; int16 2; int16 3; int16 4; int16 5; int16 6; int16 7; int16 8; int16 9]
let rec processItems proc = function | [] -> ()
                                     | hd :: tl -> proc hd; processItems proc tl

data |> processItems(fun x -> printfn "item: %i " (x + int16 1))
