type RecordType0 = {
    a: int;
    b: string;
    c: float
}

type RecordType1 = { a: string; b: string }

// record type with mutable field:
type MutableRecord = { mutable x: int; s: string }

// implicit typing determine correct record type:
let myRecord0 = { a = 5; c = 7.; b = "hello" }
let myRecord1 = { a = "Huey"; b = "Dewey" }

// explicit typing:
let myRecord2:RecordType0 = { b = "whatevs" ; a = 42; c = 3.14 }

(* Records are efficient immutable data structures.
We can't change a value but we can copy a record with
a difference in the copy:*)
let myRecord3 = { myRecord2 with b = "lol"; a = 13 }
let myRecord4 = { myRecord2 with b = "bye" }

let mutableRecord = { x = 5; s = "yo" }
mutableRecord.x <- 1 // mutate field

printfn "%A" myRecord0
printfn "%A" myRecord1
printfn "%A" myRecord2
printfn "%A" myRecord3
printfn "%A" myRecord4
printfn "%A" mutableRecord

// pattern match on record:
match myRecord3 with
| { b = "whatevs"} -> "yay"
| { c = 3.14 } -> "also yay"
| _ -> "boo"
|> printfn "%s" // cmd: also yay
