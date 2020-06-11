#load "../packages/FsLab/FsLab.fsx"

open System
open MathNet.Numerics.Random
open MathNet.Numerics.Distributions
open XPlot.GoogleCharts

type Action = 
    | One
    | Two

let rng = MersenneTwister()
let choices = [|One; Two|]

let getOtherAction act =
    match act with
    | One -> Two
    | Two -> One

type ActionCountInfo = Map<Action, int>
type RewardSumInfo = Map<Action, float>
type ProbabilityInfo = Map<Action, float>

let getActionCount (actCount:ActionCountInfo) act = 
    match actCount.TryFind act with
    | Some(value) -> value
    | None -> 0

let getRewardSum (rwdSum:RewardSumInfo) act = 
    match rwdSum.TryFind act with
    | Some(value) -> value
    | None -> 0.0

let getProbability (probInfo:ProbabilityInfo) act = Map.find act probInfo

type LearningAlgorithm = 
    | Supervised of ActionCountInfo
    | ActionValue of float * RewardSumInfo * ActionCountInfo
    | LinearReward of bool * float * ProbabilityInfo

let initAlgorithm algo =
    match algo with
    | Supervised(_) -> Supervised(Map.empty)
    | ActionValue(eps, _, _) -> ActionValue(eps, Map.empty, Map.empty)
    | LinearReward(doInaction, alpha, probMaps) -> LinearReward(doInaction, alpha, Map.empty |> Map.add One 0.5 |> Map.add Two 0.5)

let getAction algo = 
    match algo with
    | Supervised(actionCount) -> 
        let counts = Array.map (fun v -> getActionCount actionCount v) choices
        if counts.[0] = counts.[1] then choices.[rng.Next(choices.Length)]
        else Array.maxBy (fun v -> getActionCount actionCount v) choices
    | ActionValue(eps, qsum, qnum) -> 
        if rng.NextDouble() < eps then choices.[rng.Next(choices.Length)]
        else 
            let qs = Array.fold (fun (map:RewardSumInfo) v -> 
                                    let sum = getRewardSum qsum v
                                    let count = getActionCount qnum v
                                    let q = if count = 0 then 0.0 else sum / (float count)
                                    map.Add(v, q)) Map.empty choices
            let qValues = Array.map (fun v -> getRewardSum qs v) choices
            if qValues.[0] < 1e-5 && qValues.[1] < 1e-5 then choices.[rng.Next(choices.Length)]
            else Array.maxBy (fun v -> getRewardSum qs v) choices
    | LinearReward(_, _, pis) -> 
        let probArray = Array.map (fun v -> getProbability pis v) choices
        choices.[Multinomial.Sample(rng, probArray, 1) |> Array.findIndex (fun v -> v=1)]

let updateAlgorithm algo action reward = 
    match algo with
    | Supervised(actionCount) ->
        let actionToUpdate = if reward > 0.0 then action else getOtherAction action
        let currentCount = getActionCount actionCount actionToUpdate
        Supervised(actionCount.Add(actionToUpdate, currentCount + 1))
    | ActionValue(eps, qsum, qnum) ->
        let currentReward = getRewardSum qsum action
        let currentCount = getActionCount qnum action
        ActionValue(eps, qsum.Add(action, currentReward+reward), qnum.Add(action, currentCount+1))
    | LinearReward(doInaction, alpha, pis) ->
        let actionSuccess = if reward > 0.0 then action else getOtherAction action
        let actionFailed = getOtherAction actionSuccess
        let doUpdate = not doInaction || actionSuccess = action
        let currSuccProb = getProbability pis actionSuccess
        let newSuccProb = currSuccProb + alpha * (1.0 - currSuccProb)
        LinearReward(doInaction, alpha, pis |> Map.add actionSuccess newSuccProb |> Map.add actionFailed (1.0 - newSuccProb))

let nPlays = 500
let nTasks = 2000

let processTask algo (probsMap:ProbabilityInfo) pickedMaxAction taskIdx =
    let bestAction = Array.maxBy (fun act -> getProbability probsMap act) choices
    // let _ = printfn "task %d; best arm %d" taskIdx bestArmIdx
    let processPlay playAlgo playIdx =
        let action = getAction playAlgo
        let _ = if action = bestAction then Array.set (Array.get pickedMaxAction playIdx) taskIdx true else ()
        let reward = if rng.NextDouble() < getProbability probsMap action then 1.0 else 0.0
        // let _ = printfn "task: %d; play: %d; reward: %g" taskIdx playIdx reward
        updateAlgorithm playAlgo action reward
    let _ = Array.fold processPlay (initAlgorithm algo) (seq { 0 .. (nPlays-1) } |> Seq.toArray)
    ()

let processAlgorithm (probsMap:ProbabilityInfo) algo =
    let pickedMaxAction = Array.init nPlays (fun _ -> Array.create nTasks false)
    let _ = Array.Parallel.map (processTask algo probsMap pickedMaxAction) (seq { 0 .. (nTasks-1) } |> Seq.toArray)
    pickedMaxAction

let processSupervised probsMap = processAlgorithm probsMap (Supervised(Map.empty))
let processActionValue eps probsMap = processAlgorithm probsMap (ActionValue(eps, Map.empty, Map.empty))
let processLinearReward doInaction alpha probsMap = processAlgorithm probsMap (LinearReward(doInaction, alpha, Map.empty))

let probsB = [|0.9; 0.8|]
let probsA = [|0.2; 0.1|]

let probsMapA = Map.empty |> Map.add One probsA.[0] |> Map.add Two probsA.[1]
let probsMapB = Map.empty |> Map.add One probsB.[0] |> Map.add Two probsB.[1]

let rsltA_Supervised = processSupervised probsMapA |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltB_Supervised = processSupervised probsMapB |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltA_ActionValue = processActionValue 0.1 probsMapA |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltB_ActionValue = processActionValue 0.1 probsMapB |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltA_LRI = processLinearReward true 0.1 probsMapA |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltB_LRI = processLinearReward true 0.1 probsMapB |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltA_LRP = processLinearReward false 0.1 probsMapA |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))
let rsltB_LRP = processLinearReward false 0.1 probsMapB |> Array.Parallel.mapi (fun i arr -> (i, Array.averageBy (fun v -> if v then 1.0 else 0.0) arr))

let getOptions title = 
    Options
        ( title = title, 
          legend = Legend(position="bottom"))

[rsltA_Supervised; rsltA_ActionValue; rsltA_LRI; rsltA_LRP]
|> Chart.Line
|> Chart.WithOptions (getOptions "Binary Bandit A")
|> Chart.WithLabels ["Supervised"; "ActionValue"; "LR_I"; "LR_P"]

[rsltB_Supervised; rsltB_ActionValue; rsltB_LRI; rsltB_LRP]
|> Chart.Line
|> Chart.WithOptions (getOptions "Binary Bandit B")
|> Chart.WithLabels ["Supervised"; "ActionValue"; "LR_I"; "LR_P"]