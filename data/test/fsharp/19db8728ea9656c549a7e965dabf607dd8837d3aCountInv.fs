module CountInv

/// Specializing to int [] doesn't improve running time.
/// Eliminating slicing has little influence.
let count a =
    /// Assuming that arr1 and arr2 are sorted.
    let mergeAndCountSplitInv (arr1: _ []) (arr2: _ []) n n1 n2 =
        let rec mergeAndCountSplitInv' (arr: _ []) count k i j =
            if k = n then arr, count
            elif i = n1 then
                for j0 in j..n2-1 do // Copy all remaining elements in arr2
                    arr.[k+j0-j] <- arr2.[j0]
                arr, count
            elif j = n2 then
                for i0 in i..n1-1 do // Copy all remaining elements in arr1
                    arr.[k+i0-i] <- arr1.[i0]
                arr, count
            elif arr1.[i] < arr2.[j] then 
                arr.[k] <- arr1.[i]
                mergeAndCountSplitInv' arr count (k+1) (i+1) j
            else // Copy an element from 2nd array, increase inversion counter
                arr.[k] <- arr2.[j]
                mergeAndCountSplitInv' arr (count+int64(n1-i)) (k+1) i (j+1)
            
        let arr = Array.zeroCreate n
        mergeAndCountSplitInv' arr 0L 0 0 0

    let rec sortAndCount (arr: _ []) = function
        | 0 | 1 -> arr, 0L
        | n -> let arr1, x = sortAndCount arr.[0..n/2-1] (n/2)
               let arr2, y = sortAndCount arr.[n/2..] (n-n/2)
               let arr', z = mergeAndCountSplitInv arr1 arr2 n (n/2) (n-n/2)
               arr', x + y + z
        
    sortAndCount a a.Length |> snd

/// This version is worse since cache locality is bad.
let count2 a =
    let countSplitInv (arr1: _ []) (arr2: _ []) n n1 n2 =
        let rec countSplitInv' count k i j =
            if k = n || i = n1 || j = n2 then count
            elif arr1.[i] < arr2.[j] then                 
                countSplitInv' count (k+1) (i+1) j
            else // Copy from 2nd array, increase inversion counter                
                countSplitInv' (count+int64(n1-i)) (k+1) i (j+1)
            
        countSplitInv' 0L 0 0 0

    let rec count' (arr: _ []) = function
        | 0 | 1 -> 0L
        | n -> let arr1 = arr.[0..n/2-1]
               let x = count' arr1 (n/2)
               Array.sortInPlace arr1

               let arr2 = arr.[n/2..]
               let y = count' arr2 (n-n/2)
               Array.sortInPlace arr2
               
               let z = countSplitInv arr1 arr2 n (n/2) (n-n/2)
               x + y + z
        
    count' a a.Length