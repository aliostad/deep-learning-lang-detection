/// http://apfelmus.nfshost.com/blog/2010/06/01-gadts-video.html

/// So I did manage to get phantom types to work in the end. Brilliant.

type Expr<'a> =
    | I of int
    | B of bool
    | Add of Expr<int> * Expr<int>
    | Eq of Expr<int> * Expr<int>

let i x: Expr<int> = I x
let b x: Expr<bool> = B x
let add x y: Expr<int> = Add(x,y)
let eq x y: Expr<bool> = Eq(x,y)

let get_i =
    function
    | I x -> x
    | _ -> failwith "Not int"

let get_b =
    function
    | B x -> x
    | _ -> failwith "Not bool"

let rec eval: Expr<_> -> Expr<_> = 
    function
    | Add(e1,e2) ->
        let e1 = eval e1 |> get_i
        let e2 = eval e2 |> get_i
        I (e1 + e2)
    | Eq(e1,e2) -> 
        let e1 = eval e1 |> get_i
        let e2 = eval e2 |> get_i
        B (e1 = e2)
    | x -> x

let erase (x: Expr<_>): Expr<_> = // Erases the phantom parameter.
    match x with
    | Add(e1,e2) -> Add(e1,e2)
    | Eq(e1,e2) -> Eq(e1,e2)
    | I x -> I x
    | B x -> B x

let expr1 = (i 5 |> add (i 2)) |> eq (i 6)

let x = erase expr1 |> eval
