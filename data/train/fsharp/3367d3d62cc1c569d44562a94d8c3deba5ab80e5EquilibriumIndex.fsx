(*
    Equilibrium index of an array is an index such that the sum of elements at lower indexes is equal to the sum of elements at higher indexes. 
    For example, in an array A:
    A[0] = -7, A[1] = 1, A[2] = 5, A[3] = 2, A[4] = -4, A[5] = 3, A[6]=0

    3 is an equilibrium index, because:
    A[0] + A[1] + A[2] = A[4] + A[5] + A[6]

    6 is also an equilibrium index, because sum of zero elements is zero, i.e., A[0] + A[1] + A[2] + A[3] + A[4] + A[5]=0
*)

/// Method 1: Is O(n)
let equilibriumIndex (input : int[]) =
    let sum = ref (input |> Seq.sum)

    seq {
        let acc = ref 0

        for i = 0 to input.Length-1 do
            let n = input.[i]
            if !sum - n = !acc then yield i
      
            sum := !sum - n
            acc := !acc + n
    }
    |> Seq.toArray

/// Method 2: Is O(n)
let equilibriumIndex2 (arry:int[]) =
    let front = Array.copy arry
    let rear  = Array.copy arry

    // compute a running sum from the front
    for i = 1 to arry.Length-1 do
        front.[i] <- front.[i] + front.[i-1]

    // compute running some from the rear
    for i in arry.Length-2 .. -1 .. 0 do
        rear.[i] <- rear.[i] + rear.[i+1]

    { 0..arry.Length-1 }
    |> Seq.filter (fun idx -> front.[idx] = rear.[idx])
    |> Seq.toArray

let arr = [| -7; 1; 5; 2; -4; 3; 0 |]
equilibriumIndex arr
equilibriumIndex2 arr
