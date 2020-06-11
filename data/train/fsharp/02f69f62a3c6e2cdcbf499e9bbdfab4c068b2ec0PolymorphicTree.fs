type Tree<'A> = Nil | T of Tree<'A> * 'A * Tree<'A>

let rec add tr v = 
  match tr with
  |Nil -> T(Nil, v, Nil)
  |T(left, x, right) -> if (v > x) then T(left, x, (add right v))
                        else if (v <x) then T((add left v), x, right)
                        else T(left, x, right)

let rec mapTree f tr = 
  match tr with
  |Nil -> Nil
  |T(l, x, r) -> T(mapTree f l, f x, mapTree f r)

let rec foldTree f a tr =
  match tr with
  |Nil -> a
  |T(l,x,r) -> let b = f a x
               foldTree f (foldTree f b l) r

let sumTree tr = foldTree (+) 0 tr

let minOpt a b =
  match a with
  | None -> Some(b)
  | Some (a) -> Some (min a b)

let minTree tr = foldTree minOpt None tr

let copyTree tr = foldTree add Nil tr 



let rec LCR tr =
  match tr with
  |Nil -> printf ""
  |T(left, x, right) -> LCR left
                        printf"%A " x
                        LCR right
               
let rec LRC tr =
  match tr with
  |Nil -> printf ""
  |T(left, x, right) -> LRC left
                        LRC right
                        printf"%A " x
                       

let rec CLR tr =
  match tr with
  |Nil -> printf ""
  |T(left, x, right) -> printf"%A " x
                        CLR left
                        CLR right
                        
[<EntryPoint>]
let main argv = 
    let tr = (add(add(add(add(add(add Nil "f") "c") "b") "e") "d") "a")
    printfn"Polymorphic tree: "
    printfn"%A" tr
    printf"LCR: "
    LCR tr
    printfn""
    let tree = (add(add(add(add(add(add Nil 4) 2) 7) 1) 3) 5)
    printfn"Primary tree: "
    printfn"%A" tree
    printf"CLR: "
    CLR tree
    printfn""
    printfn"New tree with elements increase on 5: "
    printfn"%A " (mapTree (fun x -> x+5) tree)
    printf"CLR: "
    LCR (mapTree (fun x -> x+5) tree)
    printfn""
    printfn"Minimum of primary tree: "
    printfn"%A" (minTree tree)
    printfn"Sum of elements of primary tree: "
    printfn"%A" (sumTree tree)
    printfn"Copy of primary tree: "
    printfn"%A" (copyTree tree)
    printf"LRC: "
    LRC (copyTree tree)
    printfn""
    0 

