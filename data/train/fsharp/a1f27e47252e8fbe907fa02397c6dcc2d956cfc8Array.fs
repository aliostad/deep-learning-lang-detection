namespace Microsoft.FSharp.Collections
//[<AutoOpen>] //doesn't seem to work
module Array =
    ///Swap (mutate) the values at the first (i) and second (j) indices
    let swap i j (arr:_[]) =
        let iValue = arr.[i]
        arr.[i] <- arr.[j]
        arr.[j] <- iValue

    let rotateRangeInPlace rangeStart rangeLength startWithinRange (arr:_[]) =
        //input: rangeStart = 2, rangeLength = 5, startWithinRange = 2, arr = [|1;2;3;4;5;6;7;8;9|]
        System.Array.Reverse(arr, rangeStart, startWithinRange) //[|1;2;4;3;5;6;7;8;9|]
        System.Array.Reverse(arr, rangeStart + startWithinRange, rangeLength - startWithinRange) //[|1;2;4;3;7;6;5;8;9|]
        System.Array.Reverse(arr, rangeStart, rangeLength) //[|1;2;5;6;7;3;4;8;9|]

    let rotateInPlace startIndex (arr:_[]) =
        rotateRangeInPlace 0 arr.Length startIndex arr

    let rotate start (arr:_[]) =
        let arr' = Array.copy arr
        rotateInPlace start arr'
        arr'

    //todo: improve implementation
    let rotateRange rangeStart rangeLength startWithinRange (arr:_[]) = 
        let arr' = Array.copy arr
        rotateRangeInPlace rangeStart rangeLength startWithinRange arr'
        arr'