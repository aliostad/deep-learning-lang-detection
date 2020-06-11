module Game

open Types

let StartNew() =
  { IsEnded = false
    Frame = 0
    Breathing = Breathing.Initialize
    Work = Work.Initialize
    Energy = Energy.Initialize
    AvailableActions = [Inhale Start; Exhale Start] }

let rec Advance input gameData =
  match input with
  | [] ->
    gameData
    |> Breathing.Advance
    |> Work.Advance
    |> Energy.Advance
    |> Core.Advance
  | x::xs ->
    gameData
    |> Breathing.ProcessInput x
    |> Work.ProcessInput x
    |> Energy.ProcessInput x
    |> Advance xs