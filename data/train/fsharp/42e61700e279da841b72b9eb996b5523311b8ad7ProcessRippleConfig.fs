module ProcessRippleConfig

open System.Text.RegularExpressions
open System.IO

type PaketConfig = {
        Framework : string
        Source : string
    }

let processDependency x =
    let refPattern = """<Dependency Name="(.+)" Version="(.+)" Mode="(.+)" .*/>"""
    let mode (str:string) =
        match str with
        | s when s.Contains("Fixed") -> " = "
        | s when s.Contains("Float") -> " >= "
        | _ -> failwith "something went wrong, mode is neither Fixed nor Float"

    let packageInfo =
        match Regex.Match(x, refPattern) with
        | v when v.Success ->
            let modeSymbol = mode v.Groups.[3].Value
            Some (v.Groups.[1].Value + modeSymbol + v.Groups.[2].Value)
        | _ -> failwith "something went wrong"
    "nuget " + packageInfo.Value

let processRippleConfig (slnPath:string) (config:PaketConfig) =
    let rippleConfigLines = File.ReadAllLines(Path.Combine( slnPath, "ripple.config"))
    let rec processRippleConfig' acc =
        seq{
            if acc = 0 then
                yield "framework: " + config.Framework
                yield "redirects: off"
                yield "source " + config.Source
                yield System.Environment.NewLine

            if acc < rippleConfigLines.Length then
                match rippleConfigLines.[acc] with
                | x when x.Contains("<Dependency Name=") ->
                    yield processDependency x
                | _ -> ()
                yield! (acc + 1) |> processRippleConfig'
        }
    0 |> processRippleConfig'