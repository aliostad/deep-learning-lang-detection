(* Tasks 14-19
   Time: expectation 3h
         reality 4h 
       Kuzmina Elizaveta*)
          
type Tree<'A> = Nil | T of Tree<'A> * 'A * Tree<'A>
let rec insert x t =
  match t with
  | Nil -> T (Nil, x, Nil)
  | T (L, a, R) -> if x < a then T (insert x L, a, R) 
                   elif x = a then T (L,a , R)
                   else T (L, a, insert x R)
let rec bigOne t =
  match t with
  | Nil -> 0
  | T (L, a, R) -> if R = Nil then a
                   else bigOne R                    
let rec delete x t =
  match t with 
  | Nil -> Nil
  | T (L, a, R) -> if x < a then T (delete x L, a, R)
                   elif x > a then T (L, a, delete x R)
                        else match L, R with
                             | Nil, Nil -> Nil
                             | Nil, T1-> T1 
                             | T1, Nil -> T1
                             | T1, T (l, b, r) -> if l = Nil then T (T1, b, r)
                                                   else T (delete (bigOne T1) T1, bigOne T1, R)
let rec printLCR t =
  match t with
  | Nil -> printf ""
  | T (L, a, R) -> printLCR L
                   printf "%A " a
                   printLCR R 
let rec printLRC t =
  match t with
  | Nil -> printf ""
  | T (L, a, R) -> printLRC L
                   printLRC R
                   printf "%A " a 
let rec printCLR t =
  match t with
  | Nil -> printf ""
  | T (L, a, R) -> printf "%A " a 
                   printCLR L
                   printCLR R
let rec mapTree f t =
  match t with 
  | Nil -> Nil
  | T (L, a, R) -> T (mapTree f L, f a, mapTree f R)
let rec foldTree f a t =
  match t with 
  | Nil -> a
  | T (L, b, R) -> foldTree f (foldTree f (f a b) L) R 
let sumTree t = foldTree (fun x y -> x + y) 0 t
let minOpt x y =  
  match x with 
  | None -> Some y
  | Some x -> Some (min x y)
let minTree t = foldTree minOpt None t
let rec copyTree t = foldTree (fun t x -> insert x t) Nil t
[<EntryPoint>]
let main args =
  let t = insert 1 Nil
  let t = insert 9 t
  let t = insert 4 t
  let t = insert 3 t
  let t = insert 21 t
  let t = insert 7 t
  printf "My tree LCR: "
  printLCR t
  let t = delete 9 t
  printf "\nDelete 21: "
  printLCR t
  printf "\nsumTree: %A\n" (sumTree t)
  printf "minTree: "
  printf "%A\n" (minTree t)
  printf "copyTree: "
  printLCR (copyTree t)
  let k = T (Nil, 'a', Nil)
  let l = T (Nil, 'd', Nil)
  let m = T (k, 'f', l)
  printf "\nChar tree: "
  printLCR m
  0
    
    
    
    
    
    
    
