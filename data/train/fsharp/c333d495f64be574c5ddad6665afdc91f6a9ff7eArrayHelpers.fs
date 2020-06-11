module ArrayHelpers

let inline private blit source sourceStart targetStart count target =
    if count > 0 then
        Array.blit source sourceStart target targetStart count
        target
    else
        target

let inline private set value index arr = 
    Array.set arr index value
    arr

let inline put value index arr =
    arr
    |> Array.copy
    |> set value index

let insert value index arr =
    arr
    |> Array.length
    |> (+) 1
    |> Array.zeroCreate
    |> blit arr 0 0 index
    |> set value index
    |> blit arr (index + 1) (index + 1) (Array.length arr - index)