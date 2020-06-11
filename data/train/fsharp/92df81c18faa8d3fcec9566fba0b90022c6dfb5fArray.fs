module Array

open System

let inline insert index value (array: _[]) =
    let rs = Array.zeroCreate (array.Length + 1)
    if index > 0 then Array.Copy(array, 0, rs, 0, index)
    rs.[index] <- value
    if array.Length > index then Array.Copy(array, index, rs, index + 1, array.Length - index)
    rs

let inline shuffle (array: _[]) =
    let r = Random()
    for i = 0 to array.Length - 1 do
        let k = r.Next(i, array.Length - 1)
        let temp = array.[k]
        array.[k] <- array.[i]
        array.[i] <- temp

let inline toHash (array: int[]) =
    let mutable hash = 1
    for x in array do
        hash <- hash + x
        hash <- hash + (hash <<< 10)
        hash <- hash ^^^ (hash >>> 6)
    hash <- hash + (hash <<< 3)
    hash <- hash ^^^ (hash >>> 11)
    hash <- hash + (hash <<< 15)
    hash