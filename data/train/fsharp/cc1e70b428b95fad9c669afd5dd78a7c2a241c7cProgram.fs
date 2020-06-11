module Tree

type Tree<'a> =
    | Tree of 'a * Tree<'a> * Tree<'a>
    | Tip of 'a

type ContinuationStep<'a> =
    | Finished
    | Step of 'a * (unit -> ContinuationStep<'a>)

let rec linearize binTree cont =
    match binTree with
    | Tip x -> Step (x, fun () -> cont())
    | Tree (x, l, r) -> Step (x, (fun () -> linearize l (fun () -> linearize r cont)))

/// tree traversal using tail recursion
let iter f binTree =
    let steps = linearize binTree (fun () -> Finished)
    let rec processSteps step =
        match step with
        | Finished -> ()
        | Step (x, getNext) -> f x
                               processSteps (getNext())
    processSteps steps

/// records all tree nodes in a list
let toList binTree =
    let steps = linearize binTree (fun () -> Finished)
    let rec processSteps step acc =
        match step with
        | Finished -> List.rev acc
        | Step (x, getNext) -> processSteps (getNext()) (x :: acc)
    processSteps steps []

/// calculates the sum of all nodes in the tree
let sumTree binTree =
    let steps = linearize binTree (fun () -> Finished)
    let rec processSteps step acc =
        match step with
        | Finished -> acc
        | Step (x, getNext) -> processSteps (getNext()) (acc + x)
    processSteps steps 0

/// generates a tree of given depth
let rec generateTree n acc =
    match n with
    | 0 -> acc
    | _ -> generateTree (n - 1) (Tree (n, acc, acc))

/// tree.Map
let rec map f binTree=
    match binTree with
    | Tip x -> Tip <| f x
    | Tree (x, left, right) -> Tree (f x, map f left, map f right)

let tree = 
    Tree(
        1,
        Tree (2, Tip 3, Tip 4),
        Tip 5
        )
