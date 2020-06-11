type BinaryTree =
    | Node of int * BinaryTree * BinaryTree
    | Empty

let rec printInOrder tree =
    match tree with
    | Node (data, left, right) ->
        printInOrder left
        printfn "Node %d" data
        printInOrder right
    | Empty -> ()

let binTree =
    Node(2, 
        Node(1, Empty, Empty),
        Node(4, 
            Node(3, Empty, Empty),
            Node(5, Empty, Empty)
        )
    )

type Continuation<'a> =
    | Done
    | Step of 'a * (unit -> Continuation<'a>)


let iter f binTree =
    let rec linearize binTree cont =
        match binTree with
        | Empty -> cont()
        | Node(x, l, r) ->
            Step(x, (fun () -> linearize l (fun() -> linearize r cont)))

    let steps = linearize binTree (fun() -> Done) 

    let rec processSteps step =
        match step with
        | Done -> ()
        | Step(x, getNext) ->
            f x
            processSteps <| getNext()

    processSteps steps
        

iter (fun data -> printfn "%d" data) binTree 
