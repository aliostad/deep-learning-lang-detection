module CreepGrow.Util

open System

module Array =

    /// Prepends an item to an array.
    let cons head (tail : 'a[]) =
        let res = Array.zeroCreate (1 + tail.Length)
        res.[0] <- head
        Array.blit tail 0 res 1 tail.Length
        res

    /// Removes exactly one occurence of an item from an array. Do not use this function
    /// if the item is not in the array.
    let remove item (array : 'a[]) =
        let res = Array.zeroCreate (array.Length - 1)
        let rec copyRemove i =
            if array.[i] <> item then 
                res.[i] <- array.[i]
                copyRemove (i + 1)
            else Array.blit array (i + 1) res i (res.Length - i)
        copyRemove 0
        res

/// The mathematical constant, Pi.
let pi = Math.PI

/// A type that contains no information.
type [<Struct>] Empty =
    struct
    end

let inline isNull o = obj.ReferenceEquals (o, Unchecked.defaultof<_>)