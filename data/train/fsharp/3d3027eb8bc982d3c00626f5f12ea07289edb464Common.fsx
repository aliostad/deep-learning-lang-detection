open System
open System.IO
open System.Diagnostics
open Microsoft.FSharp.Reflection

Directory.SetCurrentDirectory __SOURCE_DIRECTORY__

module Union = 
    let toString (v: 'a) =
        let (case, _) = FSharpValue.GetUnionFields(v, typeof<'a>) 
        case.Name

type Result<'a> = Success of 'a | Failure of string option

let toLower(s: string) = s.ToLower()
let toStringLower(o: obj) = o.ToString() |> toLower
let (@@) fst snd = Path.Combine(fst, snd)

let private printColored color message = 
    let cmdColor = Console.ForegroundColor
    Console.ForegroundColor <- color
    printfn "%s" message
    Console.ForegroundColor <- cmdColor

let printInfo message = printColored ConsoleColor.DarkGray message
let printWarn message = printColored ConsoleColor.DarkYellow message
let printSuccess message = printColored ConsoleColor.DarkGreen message 
let printError message = printColored ConsoleColor.DarkRed message
    
let failure message = 
    printError message
    exit 0

let normalizePath relativeRoot path =
    try
        path
        |> Environment.ExpandEnvironmentVariables
        |> (fun p -> if Path.IsPathRooted p then p else relativeRoot @@ p)
        |> Path.GetFullPath
        |> (fun p -> p.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar))
    with
        | :? System.Security.SecurityException
        | :? System.NotSupportedException 
        | :? System.IO.PathTooLongException as ex ->
          raise <| new System.IO.IOException (sprintf "Can't normalize path '%s'." path, ex)

let startProcess(fileName, args, startNewShell) =
    let procInfo = new ProcessStartInfo()
    procInfo.FileName <- fileName
    procInfo.Arguments <- args
    procInfo.UseShellExecute <- startNewShell
    Process.Start(procInfo)

let startProcessInDir(dirPath, fileName, args, startNewShell) = 
    if not (Directory.Exists dirPath) then 
        failwith <| sprintf "Directory doesn't exist '%s'" dirPath
    
    let processFilePath = dirPath @@ fileName
    if not (File.Exists processFilePath) then
        failwith <| sprintf "File doesn't exist '%s'" processFilePath

    let currentDirectory = Directory.GetCurrentDirectory()
    Directory.SetCurrentDirectory (dirPath)
    
    try
        startProcess(processFilePath, args, startNewShell) 
    finally
        Directory.SetCurrentDirectory(currentDirectory)
