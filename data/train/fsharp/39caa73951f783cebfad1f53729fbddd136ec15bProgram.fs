module Program

open System
open Compute

//-------------------------------------------------------------------------------------------------

let taskdefs =
    [ EpsilonGreedyProcess { Q1 = 0.0; Alpha = OneOverK; Epsilon = 0.00 }
      EpsilonGreedyProcess { Q1 = 0.0; Alpha = OneOverK; Epsilon = 0.01 }
      EpsilonGreedyProcess { Q1 = 0.0; Alpha = OneOverK; Epsilon = 0.10 } ]

let randomng = Random()
let outcomes =
    taskdefs |> List.map (fun (taskdef) -> taskdef, Compute.computeResults taskdef randomng)

let map selection =
    outcomes |> List.map (fun (taskdef, results) -> taskdef, results |> Array.map selection)

Chart.renderAverageReward @"..\..\..\AverageReward.png" (map (fun x -> x.AverageReward))
Chart.renderOptimalAction @"..\..\..\OptimalAction.png" (map (fun x -> x.OptimalAction))
