module Pather.Commands.Load

open CommandLine
open Pather
open System.IO

[<Verb("load", HelpText = "Load given path set into calling process")>]
type Args = {
  [<Option('f', "file", Required = true, HelpText = "Input file")>]File: string; 
  [<Option('g', "group", Default  = "default", HelpText = "Name of group that will be load")>]Group: string;
  [<Option('m', "mode", Default = PathSet.MergeKind.Append, HelpText = "Pathset merge mode")>]Mode: PathSet.MergeKind;
}

let execute (args: Args) =    
    let input = File.ReadAllText args.File
    let file = match PathsFile.parse input with
                | PathsFile.Success(f) -> f
                | PathsFile.Failure(m) -> failwith m

    let group = file.Item(args.Group)
    
    let targetProcessId = RemoteProcess.parentProcessId ()

    let initialPathSet = RemoteProcess.readPathSet targetProcessId

    let updatedPathSet = initialPathSet |> PathSet.merge group args.Mode
    
    RemoteProcess.setPath targetProcessId updatedPathSet

    ()