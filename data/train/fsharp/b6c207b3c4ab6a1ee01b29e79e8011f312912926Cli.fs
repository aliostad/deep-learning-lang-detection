module Cli
  open Argu
  open System

  type Version = {
    Assembly: string
    File: string
  }

  type Config = {
    Version: Version
    Solution: string
  }

  type Arguments =
    | [<Mandatory>] Version of string
    | FileVersion of string
    | [<Mandatory>] Solution of string
  with
    interface IArgParserTemplate with
      member x.Usage =
        match x with
        | Version _ -> "specify an assembly version string."
        | FileVersion _ -> "specify an assembly file version string."
        | Solution _ -> "specify a solution file path."

  let parseArguments (argv: string[]) =
    let errorHandler = ProcessExiter(colorizer = function ErrorCode.HelpText -> None | _ -> Some ConsoleColor.Red)
    let parser = ArgumentParser.Create<Arguments>(errorHandler = errorHandler)
    let results = parser.Parse argv

    let version = {
      Assembly = results.GetResult <@ Version @>
      File = results.GetResult(<@ FileVersion @>, defaultValue = results.GetResult <@ Version @>)
    }

    { Version = version; Solution = results.GetResult <@ Solution @> }
