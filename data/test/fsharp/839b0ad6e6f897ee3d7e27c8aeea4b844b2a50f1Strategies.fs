namespace Eyas

module Strategies =
    open System

    type Feature = (string * int * int)     /// hostname, port, queue length
    let mutable private state_local_copy : Feature[] = [| |]    // could optionally be used as an optimization by different strategies

    /// Picks a server equally at random
    let RandomSpray (rand : Random) (msgNum : int) (state : Feature[]) =
        let index = rand.Next(state.Length)
        (index, 1./(float state.Length))


    let mutable private weightedRandom_CuttOffs = [| |]
    let mutable private weightedRandom_Ceiling = Int32.MinValue

    /// Picks a server with probability inversely proportional to queue length
    let WeightedRandom (rand : Random) (msgNum : int) (state : Feature[]) =
        let computePCutOffs = fun (queues) ->
            let weights = queues |> Array.mapi(fun index (h, p, q) -> (q + 1, index)) |> Array.sort
            let sumWeights = weights |> Array.sumBy(fun (w, index) -> w)
            weights
            |> Array.mapFold(fun lastSum (w, index) ->
                let cutOff = (lastSum + sumWeights - w)
                let probabilityOfSelection = (float (sumWeights - w)) / (float sumWeights * 2.0)
                ((cutOff, index, probabilityOfSelection), cutOff)) 0

        if state <> state_local_copy then
            let cutOffs, ceiling = computePCutOffs(state)
            weightedRandom_CuttOffs <- cutOffs
            weightedRandom_Ceiling <- ceiling
            state_local_copy <- state

        let r = rand.Next(weightedRandom_Ceiling)
        let _, index, probabilityOfSelection = Array.find(fun (cutOff, _, _) -> r < cutOff) weightedRandom_CuttOffs
        (index, probabilityOfSelection)


    /// Picks the server with the shortest queue length
    let ShortestQueue (msgNum : int) (state : Feature[]) =
        let server, port, _ = state |> Array.minBy (fun (_, _, qlen) -> qlen)
        let index = state |> Array.findIndex (fun (h, p, _) -> h = server && p = port)
        (index, 1.)