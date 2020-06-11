namespace Allgorithms

open Allgorithms.Extensions

module Combinatorics =
    let permutations (A : int array) =
        let A' = Array.copy A
        let rec permutations' k = seq {
            if k = A.Length then yield Array.copy A'
            else
                for i = k to A.Length-1 do
                    Array.swap A' i k
                    yield! permutations' (k+1)
                    Array.swap A' i k
        }
        permutations' 0

    /// Generates the sequence of all the combinations one can make from the array A with k elements.
    /// Example: choose [| 1; 2; 3 |] 2 yields [| 1; 2 |]; [| 1; 3 |]; [| 2; 3 |]
    let choose (A : int array) k =
        let result = Array.zeroCreate<int> k
        let rec choose' s result_i = seq {
            if result_i = k then yield Array.copy result
            else
                for i = s to A.Length-1 do
                    result.[result_i] <- A.[i]
                    yield! choose' (i+1) (result_i+1)
        }
        choose' 0 0

    let powerset (A: int array) =
        let A' = Array.map Some A
        
        let rec powerset' k = seq {
            if k = A'.Length then
                yield Array.choose id A'
            else
                let v = A'.[k].Value
                yield! powerset' (k+1)
                A'.[k] <- None
                yield! powerset' (k+1)
                A'.[k] <- Some(v)
        }
        powerset' 0

    let cartesian_product (arrays : 'a array array) =
        let positions = Array.zeroCreate<'a> arrays.Length
        let rec cartesian_product' k = seq {
            if k = arrays.Length then yield Array.copy positions
            else
                for i = 0 to arrays.[k].Length-1 do
                    positions.[k] <- arrays.[k].[i]
                    yield! cartesian_product' (k+1)
        }
        cartesian_product' 0
        
    let cyclic_permutations (array : int array) =
        let result = Array.copy array
        let rec cyclic_permutations' k = seq {
            if k = result.Length then yield Array.copy result
            else
                for i = k to result.Length-1 do
                    Array.dislodge result i k
                    yield! cyclic_permutations' (k+1)
                    Array.dislodge result i k
        }
        cyclic_permutations' 0
