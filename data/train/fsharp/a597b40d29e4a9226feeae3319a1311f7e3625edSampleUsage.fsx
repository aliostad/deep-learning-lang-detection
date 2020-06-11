// Usage example for the Qvitoo.Api.Client
#I "bin/Release"
#r "FParsec.dll"
#r "Aether.dll"
#r "HttpFs.dll"
#r "Hopac.Core.dll"
#r "Hopac.Platform.dll"
#r "Hopac.dll"
#r "Chiron.dll"
#r "NodaTime.dll"
#load "PublicApi.fs"

open Hopac
open Qvitoo.Api.Client

let conf =
  ()

let republishFromEconomic () =

  let targetInstances =
    Api.TargetInstances.getAll conf ()
    |> Stream.chooseFun (function | Choice1Of2 ti -> Some ti | _ -> None)
    |> Stream.filterFun (fun ti -> ti.key = "economic" || ti.key = "fortnox")
    |> Stream.foldFun (fun s t -> t :: s) []
    |> run

  let fortnox = targetInstances |> List.find (fun ti -> ti.key = "fortnox")
  let economic = targetInstances |> List.find (fun ti -> ti.key = "economic")

  Api.Receipts.getAll conf (fun r ->
    r.isPublished
    && Set.contains "economic" r.finishedTargets
    && not (Set.contains "fortnox" r.finishedTargets)
    && r.timestamp.Year = 2015)
  |> Stream.traverseM (fun r ->
    r
    |> Api.Receipts.enableTarget conf "fortnox"
    |> Api.bind (fun r ->
      r.targetInstances
      |> Map.find "economic"
      |> fun rti -> rti.settings
      |> Api.Receipts.configureTarget conf fortnox
      |> Api.map (fun _ -> r))
    |> Api.bind (fun r ->
      Api.Receipts.publish conf r))
  |> Stream.consumeFun (fun receipt ->
    printfn "Successfully published %A" receipt)
