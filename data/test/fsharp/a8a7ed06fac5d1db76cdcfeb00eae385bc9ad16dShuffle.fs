namespace GitHub.Lventre.GiftLottery

open System

module Shuffle =

    /// Knuth shuffle algorithm
    let private knuthShuffle (lst:array<'a>) =
        if lst.Length < 2 then failwith "Arrays must contain at least 2 items to be shuffled."
        let copy = Array.copy lst
        let Swap i j =                                              // Standard swap
            let item = copy.[i]
            copy.[i] <- copy.[j]
            copy.[j] <- item
        let rnd = new Random()
        let ln = copy.Length
        [0..(ln - 2)]                                               // For all indices except the last
        |> Seq.iter (fun i -> Swap i (rnd.Next(i, ln)))             // swap th item at the index with a random one following it (or itself)
        copy

    /// Ensures all items in original array differ in the shuffled array.
    let private ensureShuffled (orig:array<'a>) (shuffled:array<'a>) =
        if orig.Length <> shuffled.Length then failwith "Original and shuffled arrays have different length!"
        Array.forall2 (fun o s -> o <> s) orig shuffled

    /// Shuffles an array
    let shuffle arr =
        let rec shuffle' (oth:array<'a>) =
            let shuf = knuthShuffle oth
            if not <| ensureShuffled oth shuf then shuffle' oth
            else shuf
        shuffle' arr