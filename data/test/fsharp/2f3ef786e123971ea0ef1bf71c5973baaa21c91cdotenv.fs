namespace datNET

module DotEnv =
  open System.IO
  open System
  open Fake.EnvironmentHelper
  open Fake

  type Target =
    | User
    | Machine
    | Process

  type EnvVariableParams =
    {
      EnvFilePath : string
      Target : Target
    }

  type EnvVariable =
    {
      Name : string
      Value : string
    }

  let EnvVariableDefaultParams () =
    {
      EnvFilePath = ".env"
      Target = User
    }

  let private _getEnvVariableSetter target =
    match target with
    | User    -> setUserEnvironVar
    | Machine -> setMachineEnvironVar
    | Process -> setProcessEnvironVar

  let private _getTargetString target =
    match target with
    | User    -> "User"
    | Machine -> "Machine"
    | Process -> "Process"

  let private _splitEnvironmentVariable (kvp : string) : EnvVariable =
    match (kvp.Split([|'='|], 2, StringSplitOptions.None)) with
    | [|variable; value|] -> { Name = variable; Value = (value.Trim [|'"'|]) }
    | _ -> raise (FormatException(sprintf "Invalid env variable format for the following: %s" kvp))

  let private _printAndSetEnvVariable target envVariable =
    let setEnvironVar = _getEnvVariableSetter target
    tracefn "Setting the %s environment variable: %s" (_getTargetString target) envVariable.Name
    setEnvironVar envVariable.Name envVariable.Value

  let getEnvironmentVariables filePath =
    try
      File.ReadAllLines filePath
      |> Array.map _splitEnvironmentVariable
    with
    | _ -> Array.empty<EnvVariable>

  let setEnvironmentVariables mapParams =
    let parameters = EnvVariableDefaultParams() |> mapParams

    getEnvironmentVariables parameters.EnvFilePath
    |> Array.iter (fun envVariable -> (_printAndSetEnvVariable parameters.Target envVariable))