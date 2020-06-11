namespace RubicsCube.Core

module Utils = 
    let createJ w h getIndex (face: Face) = 
        let array = Array2D.zeroCreate w h
        for i in [0; w - 1] do 
            for j in [0; h - 1] do
                let x, y = getIndex i j
                array.[x, y] <- face.[i, j]
        array

    let rotateFaceLeft (x: Face): Face =
        let ind i j = x.[j, 2 - i]
        Array2D.init 3 3 ind

    let rotateFaceRight (x: Face): Face = 
        let ind i j = x.[2 - j, i]
        Array2D.init 3 3 ind


    let reverseTuple (a, b) = 
        (b, a)

    let replaceOrCopy (newFace, direction: Direction) index face =
        let rightIndex = int direction

        match index with
        | x when x = rightIndex -> newFace
        | _ -> Array2D.copy face

    let next ind = (ind + 1) % 4
    let prev ind = (ind - 1 + 4) % 4

    let map f (x, y) = 
        (f x, f y)

    let addItem ((x, y) as t) f =
        (x, y, f t)

    let times t item = 
        List.init t (fun _ -> item)
            
    let nextSide ind = ind % 4 + 1

    let map3 f (x, y, z) = 
        (f x, f y, f z)

    let pipeAssert f message x = 
        if f x then
            failwith (message x)
        else 
            x

    let pipePrint x = 
        printf "%A" x
        x
