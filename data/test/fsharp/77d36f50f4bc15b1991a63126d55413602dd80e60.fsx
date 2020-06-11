open System.Linq

let indicesToDrop = [2; 3; 5; 7; 11; 13; 17]

let myArray = Array2D.init 30 20 (+)
let array = myArray

let copyCol length (newArray : _ [,]) (originalArray : _ [,]) newIndex originalIndex =
    for i = 0 to length - 1 do
        newArray.[i, newIndex] <- originalArray.[i, originalIndex]
        
let filterCols array indicesToDrop =
    let rows = Array2D.length1 array
    let cols = Array2D.length2 array
    let indices = [0..cols-1].Except indicesToDrop |> List.ofSeq

    let newArray = Array2D.zeroCreate rows (List.length indices)
    indices |> List.iteri (copyCol rows newArray array)
    newArray
    
filterCols myArray indicesToDrop 