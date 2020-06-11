(* Some operations (map, fold, copy) with binary search trees
(expectation: 3,5 h; reality: 5 h)
by Sokolova Polina *)

type Tree<'a> = Nil | Node of 'a * Tree<'a> * Tree<'a> 

let rec insert a t =
    match t with
    | Nil           -> Node(a, Nil, Nil)
    | Node(c, L, R) -> match compare a c with
                       | x when x < 0  -> Node(c, insert a L, R)
                       | x when x > 0  -> Node(c, L, insert a R)
                       | _             -> t

let rec findInRight t =
    match t with
    | Nil             -> 0
    | Node(c, Nil, _) -> c
    | Node(_, L  , _) -> findInRight L

let rec findInLeft t =
    match t with
    | Nil             -> 0
    | Node(c, _, Nil) -> c
    | Node(_, _, R  ) -> findInLeft R

let rec remove a t =
    match t with
    | Nil           -> Nil
    | Node(c, L, R) -> match compare a c with
                       | x when x < 0  -> Node(c, remove a L, R)
                       | x when x > 0  -> Node(c, L, remove a R)
                       | _             -> match (L, R) with
                                          | Nil, Nil             -> Nil
                                          | L  , Nil             -> L
                                          | Nil, R               -> R
                                          | L  , Node(_, Nil, _) ->
                                              Node(findInLeft L, remove (findInLeft L) L, R)
                                          | _  , _               ->
                                              Node(findInRight R, L, remove (findInRight R) R)

let rec CLRprint t =
    match t with
    | Nil           -> printf ""
    | Node(c, L, R) -> printf "%d " c
                       CLRprint L
                       CLRprint R

let rec LCRprint t =
    match t with
    | Nil           -> printf ""
    | Node(c, L, R) -> LCRprint L
                       printf "%d " c
                       LCRprint R

let rec LRCprint t =
    match t with
    | Nil           -> printf ""
    | Node(c, L, R) -> LRCprint L
                       LRCprint R
                       printf "%d " c

let rec map f t = 
    match t with
    | Nil           -> Nil
    | Node(c, L, R) -> Node(f c, map f L, map f R)

let rec fold f a t =
    match t with
    | Nil           -> a
    | Node(c, L, R) -> fold f (fold f (f a c) L) R 

let rec inline sum t = 
    fold (+) Unchecked.defaultof<'A> t 

let min t =
    fold (fun a b ->
        match a with
        | None   -> Some b
        | Some a -> Some (min a b)) None t

let copy t =
    fold (fun tree x -> insert x tree) Nil t 

[<EntryPoint>]
let main args =
    let myTree = Node(8,Node(3,Node(1,Nil,Nil),Node(6,Node(4,Nil,Nil),Node(7,Nil,Nil))),Node(10,Nil,(Node(14,Node(13,Nil,Nil),Nil))))
    let myTree2 = Node(4.0,Node(3.0,Node(1.0,Nil,Nil),Nil),Node(9.0,Node(7.0, Node(5.0, Nil, Nil), Nil),Node(12.0,Nil, Node(13.0,Nil,Nil))))
    let myTree3 = Nil
    let myTree4 = Node("b",Node("a",Nil,Nil),Node("c",Nil,Nil))
    printfn "1. myTree: %A\n" myTree
    printfn "map (increase by 1):   %A\n" (map (fun x -> (x + 1)) myTree)
    printfn "fold (mutliplication): %A" (fold (fun acc x -> x * acc) 1 myTree)
    printfn "sum:  %A" (sum myTree)
    printfn "min:  %A\n" (min myTree)
    printfn "copy of myTree: %A" (copy myTree)
    printf "\n\n"
    printfn "2. myTree2: %A\n" myTree2
    printfn "map (increase by 1.5): %A\n" (map (fun x -> (x + 1.5)) myTree2)
    printfn "fold (multiplication): %A" (fold (fun acc x -> x * acc) 1.0 myTree2)
    printfn "sum:  %A" (sum myTree2)
    printfn "min:  %A\n" (min myTree2)
    printfn "copy of myTree2: %A" (copy myTree2)
    printf "\n\n"
    printfn "3. myTree3: %A" myTree3
    printfn "map (increase by 1):   %A" (map (fun x -> (x + 1)) myTree3)
    printfn "fold (multiplication): %A" (fold (fun acc x -> x * acc) 1 myTree3)
    printfn "sum:  %A" (sum myTree3)
    printfn "min:  %A" (min myTree3)
    printfn "copy of myTree3: %A" (copy myTree3)
    printf "\n\n"
    printfn "4. myTree4: %A" myTree4
    printfn "min:  %A" (min myTree4)
    printfn "copy of myTree4: %A" (copy myTree4)
    0 