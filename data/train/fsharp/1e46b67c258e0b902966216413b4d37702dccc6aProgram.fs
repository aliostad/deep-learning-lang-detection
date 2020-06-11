open runner
open guts
open calculator

context "PoC"
once (fun _ -> start calculator.name calculator.path)
before clear

"type a random number" &&& fun _ ->    
    let random = System.Random().Next(100, 10000).ToString()    
    enter random
    results == random

"clear works" &&& fun _ ->    
    enter "1234"
    results == "1234"
    clear ()
    results == "0"

"adding 1 and 2 is 3" &&& fun _ ->
    add [1; 2]
    results == "3"

"adding 1 and 2 and 3 and 4 is 10" &&& fun _ ->
    add [1; 2; 3; 4]
    results == "10"

"multiplying 6 and 9 and 2 is 108" &&& fun _ ->
    multiply [6; 9; 2]
    results == "108"

"copy 133 then clear then paste and results is 133" &&& fun _ ->
    enter "133"
    click ">Edit>Copy" //made up psuedo selector for menu items
    clear ()
    click ">Edit>Paste"
    results == "133"

run ()

System.Console.ReadKey() |> ignore

quit ()