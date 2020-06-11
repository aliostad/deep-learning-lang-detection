module internal ATG.Geometry.Measurements.Algorithms.Cluster


//varianceSplitPosition :: (Floating b, Ord b) => Int -> (a -> b) -> (a -> b) -> [a] -> Int
let varianceSplitPosition tips lF rF list =
    let n = Array.length list

    let var s s2 k =
        let d = float (max 1 k)
        in (s2 / d) - (s / d) * (s / d)

    let rec process' x i l' l2' r' r2' d =
        let lvar = var l' l2' i
        let rvar = var r' r2' (n - i)
        let nd = (lvar + rvar, i) :: d
        match x with
            | []            -> nd
            | (xi :: restX) ->
                let l = lF xi
                let r = rF xi
                in process' restX (i + 1) (l' + l) (l2' + l * l) (r' - r) (r2' - r * r) nd

    let weights =
        let right = Array.map rF list
        let initialR' = Array.sum right
        let initialR2' = Array.sumBy (fun d -> pown d 2) right
        process' (List.ofArray list) 0 0.0 0.0 initialR' initialR2' []

    let (_, index) =
        List.min <|
            if n > 2 * tips
                then weights |> List.take (n - tips) |> List.skip tips
                else weights

    index


let varianceSplit tips lF rF list =
    Array.splitAt (varianceSplitPosition tips lF rF list) list
