module Rorit.BackgroundProcess

open System.IO
open System.Diagnostics
open System.Runtime.InteropServices

module Interop =
  [<DllImport("kernel32.dll")>]
  extern bool IsWow64Process(nativeint hProcess, bool& Wow64Process)

let private appFileName = System.AppDomain.CurrentDomain.FriendlyName

let GetIfExists() =
  try
    let thisPID = Process.GetCurrentProcess().Id
    Process.GetProcessesByName(Path.GetFileNameWithoutExtension(appFileName))
    |> Array.filter (fun p -> p.Id <> thisPID)
    |> Array.head |> Some
  with
  | :? System.ArgumentException -> None

let Exists() =
  GetIfExists() |> Option.isSome

let IsCompatible() =
  let compatible =
    let mutable isWow64Process = false
    if not <| Interop.IsWow64Process(Process.GetCurrentProcess().Handle, &isWow64Process) then
      Logger.Error <| sprintf "Unable to detect platform"
      false
    else
      if isWow64Process then Logger.Warn <| "Running 32-bit executable on x64 is unsupported."
      not <| isWow64Process
  compatible

let Kill() =
  GetIfExists()
  |> Option.iter (fun p ->
    p.Kill()
    Logger.PrintInfo <| sprintf "Killed rorit process.")

let CreateBackgroundProcess() =
  if Process.GetProcessesByName(Path.GetFileNameWithoutExtension(appFileName)).Length > 1 then
    Logger.PrintInfo "Rorit is already running, restarting..."
    Kill()

  Some <| new Process(
    StartInfo = new ProcessStartInfo(
      FileName = PathUtils.PathFromBaseDirectory appFileName,
      Arguments = (sprintf "--init %s" (if Logger.minLogLevel = Logger.LogLevel.Trace then "--trace" else "")),
      UseShellExecute = false,
      RedirectStandardOutput = true,
      RedirectStandardError = true,
      CreateNoWindow = true,
      WindowStyle = ProcessWindowStyle.Hidden),
    EnableRaisingEvents = true)

let Start() =
  if not <| IsCompatible() then
    Logger.Warn "Platform is incompatible."
    printf "Are you sure you want to continue? [y/N] "
    if System.Console.ReadLine().Trim().ToLower() <> "y" then System.Environment.Exit(1)

  try
    match CreateBackgroundProcess() with
    | Some p ->
      Logger.PrintInfo <| sprintf "Starting background process..."
      p.Start() |> fun success -> if not success then Logger.Error "Background process did not start"
    | None ->
      Logger.Error "Could not create background process"
  with
  | :? System.ComponentModel.Win32Exception as ex -> Logger.Error ex.Message
