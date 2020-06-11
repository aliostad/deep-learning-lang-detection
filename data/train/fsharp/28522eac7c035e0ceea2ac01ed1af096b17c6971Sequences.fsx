(* Sequences, commonly called sequence expressions, are similar to lists:
    both data structures are used to represent an ordered collection of values. 
    However, unlike lists, elements in a sequence are computed as they are needed (or "lazily"), 
    rather than computed all at once. This gives sequences some interesting properties, 
    such as the capacity to represent infinite data structures. *)

seq {1..10}
seq {1..2..10}
seq {10..-1..0}
seq {for a in 1..10 do yield a, a*2, a*3}

let intList = 
    [for a in 1..10 do
        printfn "intList: %i" a
        yield a]

let intSeq = 
    seq {for a in 1..10 do
            printfn "intSeq: %i" a
            yield a}

Seq.nth 3 intSeq;;

//sequences are able to represent a data structure with an arbitrary number of elements
seq {0I..100000000000000000000I}

let allEvens = 
    let rec loop x = seq { yield x; yield! loop (x+2)}
    loop 0;;

for a in (Seq.take 5 allEvens) do
    printfn "%i" a

//Note: sequences are implemented as state machines by the F# compiler.
//In reality, they manage state interally and hold only the last generated item in memory at a time. 
//Memory usage is constant for creating and traversing sequences of any length.

