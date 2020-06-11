(*i5.4*)

///<summary>
///arraySortD takes an array and returns it sorted.
///</summary>
///<params name="l">
///Array
///</params>
///<returns>
///unit
///</returns>

let arraySortD (a : 'a []) =
    for i = 1 to a.Length - 1 do
        let mutable j = i
        while j >= 1 && a.[j] < a.[j-1] do
            let tmp = a.[j]
            a.[j] <- a.[j-1]
            a.[j-1] <- tmp
            j <- j - 1

printfn "    5i.4     arraySortD array"


let test1 = [|0.0; 0.0; 0.0; 0.0|]
arraySortD test1
printfn "Test1: %b" (test1 = [|0.0; 0.0; 0.0; 0.0|])

let test2 = [|1.5;8.5;3.5;5.5;4.5|]
arraySortD test2
printfn "Test2: %b" (test2 = [|1.5; 3.5; 4.5; 5.5; 8.5|])

let test3 = [||]
arraySortD test3
printfn "Test3: %b" (test3 = [||])

let test4 = [|"a"|]
arraySortD test4
printfn "Test4: %b" (test4 = [|"a"|])

let test5 = [|5; 4; 3; 2; 1; 1; 2; 3; 4; 5|]
arraySortD test5
printfn "Test5: %b" (test5 = [|1; 1; 2; 2; 3; 3; 4; 4; 5; 5|])

let test6 = [|'4'; '3'; '2'; '2'; '3'; '4'|]
arraySortD test6
printfn "Test6: %b" (test6 = [|'2'; '2'; '3'; '3'; '4'; '4'|])

let test7 = [|1;7;5;2;1|]
arraySortD test7
printfn "Test7: %b" (test7 = [|1;1;2;5;7|])

(*Another sort*)

//let arraySortD2 a =
//    let a = a |> Array.copy   // cant use the .copy library??!
//    for i=0 to a.Length-1 do     
//        for j = 1+i to a.Length-1 do
//            if a.[j] < a.[i] then
//                let tmp = a.[i]
//                a.[i] <- a.[j]
//                a.[j] <- tmp
