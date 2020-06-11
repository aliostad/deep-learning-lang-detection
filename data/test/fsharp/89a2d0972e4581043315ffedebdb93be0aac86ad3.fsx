// Note that this is incorrect. 

open System
open System.Linq

module Seq =
    let catchExceptions handler (sequence: _ seq) =
        let e = sequence.GetEnumerator()
        let evaluateNext () = 
            try Some (e.Current)
            with ex -> handler ex 
        seq { while e.MoveNext() do
                  match evaluateNext() with
                  | Some (item) -> yield item 
                  | None -> () }

// Won't work because e.MoveNext() is actually where the exception would be thrown.
// So I tried:

let catchExceptions handler (sequence: _ seq) =
    let e = sequence.GetEnumerator()
    let safeMoveNext() = 
        try
            e.MoveNext() 
        with ex -> 
            handler ex
            true
    seq { 
        while safeMoveNext() do
            yield e.Current
    }

// This is closer, but also doesn't work.  
// It turns out that if e.MoveNext() throws an exception it does not 
// advance to the next element.  This makes it effectively call the handler
// over and over.

// Ah well, better luck next time :)

 