namespace CopyStacker.CollectionUtil

module Array =
    let zipWith(zipper: 'a -> 'b)(array: 'a[]): ('a * 'b)[] = Array.zip array (array |> Array.map(zipper))

module List =
    // FIXME: Currently O(n^2), can get this to O(n) using recursion (not sure it's worth it though, max n is low)    
    let getRange(start: int, count: int)(list: 'a list) = 
        match start, start + count with
            | first, last when first >= list.Length -> []
            | first, last when last >= list.Length -> [first..list.Length - 1]
            | first, last -> [first..last]
        |> List.map(fun x -> list.Item(x))
