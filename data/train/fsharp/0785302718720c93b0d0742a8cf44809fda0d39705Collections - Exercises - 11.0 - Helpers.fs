namespace Exercise11.Helpers 

module L = 
    // Helper functions most of which exist in the List library
    //------------------------------------------------------

    // more efficient than naiveRev
    let rev l = 
        let rec rev reversedElems = function
            | [] -> reversedElems
            | x::xs -> rev (x::reversedElems) xs
        
        rev [] l

    let filter predicate l =
        let rec filter filteredElems = function
            | [] -> rev filteredElems
            | x::xs -> 
                if predicate x 
                then filter (x::filteredElems) xs
                else filter filteredElems xs
        filter [] l

    let isEmpty  = function
        | [] -> true
        | _ -> false

    // let partition predicate l = 
    //     let rec partition = function
    //         | (l1,l2, []) -> (rev l1, rev l2)
    //         | (l1, l2, x::xs) ->
    //             if predicate x 
    //             then partition ((x::l1), l2, xs)
    //             else partition (l1, (x::l2 ), xs)
        
    //     partition ([], [], l)

    // let indexed l = 
    //     let rec indexed i indexedElems = function
    //         | [] -> rev indexedElems
    //         | x::xs -> indexed (i+1) ((i, x)::indexedElems) xs
        
    //     indexed 0 [] l

    // let iter iterator l = 
    //     let rec iter = function
    //         | [] -> ()
    //         | x::xs -> 
    //             iterator x
    //             iter xs

    //     iter l
        
    let map mapper l = 
        let rec map mappedElems = function
            | [] -> rev mappedElems
            | x::xs -> map ((mapper x)::mappedElems) xs
        
        map [] l

    let rec fold folder state  = function
    | [] -> state
    | x::xs -> fold folder (folder state x) xs
    
    // // Naive; non tail-recursive
    // let foldBackNaive folder l state = 
    //     let rec foldBack currentState = function
    //         | [] -> currentState
    //         | x::xs -> folder x (foldBack currentState xs)

    //     foldBack state l

    let length l = fold (fun count el -> count + 1) 0 l

    let at i l =          
        let rec at currentIndex  = function
            | [] -> None                  
            | x::xs ->
                if currentIndex = i 
                then Some x
                else at (currentIndex+1) xs
        at 0 l      

    let copy l =
        let rec copy res = function
            | [] -> rev res
            | x::xs -> copy (x::res) xs

        copy [] l

    let contains el l = not (isEmpty <| filter ((=) el) l)

    let intersect (l1, l2) = 
        let rec intersect commonElems = function
            | (x::xs, y::ys) -> 
                match (x, y) with
                | (sm, lg) when sm < lg -> intersect commonElems (xs, y::ys)
                | (lg, sm) when lg > sm -> intersect commonElems (x::xs, ys)
                | (eq1, eq2) -> intersect (eq1::commonElems) (xs, ys)
            | _ -> rev commonElems

        intersect ([]) (l1, l2)
    let unique l = 
        let rec unique res = function
            | [] -> rev res
            | x::xs -> 
                if contains x res 
                then unique res xs
                else unique (x::res) xs

        unique [] l
