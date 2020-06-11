// Finally done with the new library. It took me almost a week and writting the v4 and v5 wrapper took a little after that.

// Residual learning allows me to learn quite deep nets. It is a good technique.

// I've also tried batch normalization here, but found that it reduced the capacity of the network.

// Even after 300 iterations the thing keeps improving so maybe if I let it run for long enough, it will manage to memorize the entire 180k training set
// and pack it in only 15k parameters.
// There is no point to it though. This is good enough. I am really much more interested in the first 30 iterations than the rest.

#if INTERACTIVE
#r "../packages/FSharp.Charting.0.90.13/lib/net40/FSharp.Charting.dll"
#r "System.Windows.Forms.DataVisualization.dll"
#load "n_puzzle_3x3_builder.fsx"
#load "spiral_conv.fsx"
#endif
open PatternBuilder3x3
open SpiralV2

open System
open System.Collections.Generic
open FSharp.Charting

let inputs_targets =
    value_function
    |> Array.map (
        fun (l,r) ->
        d4M.createConstant(l.Length/81,81,1,1,l),
        d4M.createConstant(r.Length/32,32,1,1,r)
        )

let layers = 
    [|
    BNFullyConnectedLayer.create (81,32,1,1) relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet

    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet
    BNResidualFullyConnectedLayer.create (32,32,1,1) relu relu :> INNet

    BNFullyConnectedLayer.create (32,32,1,1) clipped_sigmoid :> INNet
    |]

81*32+32*32*14+32*32

let training_loop label data i =
    let increase_i_and_get_factor () = 
        let i' = !i
        i := i'+1
        1.0/(1.0 + float i')
    layers
    |> Array.fold (fun x layer -> layer.train x increase_i_and_get_factor) data
    |> fun x -> lazy get_accuracy label x, cross_entropy_cost label x

let training_loop_stochastic_depth label data i =
    let increase_i_and_get_factor () = 
        let i' = !i
        i := i'+1
        1.0/(1.0 + float i')
    layers
    |> Array.fold (fun x layer -> layer.train x increase_i_and_get_factor) data
    |> fun x -> lazy get_accuracy label x, cross_entropy_cost label x

let test learning_rate num_iters =
    [|
    let c = ref 0
    for i=1 to num_iters do
        let mutable er = 0.0f
        let mutable acc = 0.0f
        for input, label in inputs_targets do
            let acc',r = training_loop label input c // Forward step
            er <- er + !r.P
            acc <- acc'.Value + acc
            ObjectPool.Reset() // Resets all the adjoints from the top of the pointer in the object pool along with the pointers.
            layers |> Array.iter (fun x -> x.ResetAdjoints())
            //printfn "Squared error cost on the minibatch is %f at batch %i" !r.P j

            if !r.P |> Single.IsNaN then failwith "Nan!"

            r.A := 1.0f // Loads the 1.0f at the top
            while tape.Count > 0 do tape.Pop() |> fun x -> x() // The backpropagation step
            layers |> Array.iter (fun x -> x.SGD learning_rate) // Stochastic gradient descent.
        printfn "Error is %f. Accuracy is %i/%i on iteration %i." er (int acc) number_of_examples i
        yield int acc
    |]

#time
test 0.15f 10
//|> Chart.Line
//|> Chart.Show
#time