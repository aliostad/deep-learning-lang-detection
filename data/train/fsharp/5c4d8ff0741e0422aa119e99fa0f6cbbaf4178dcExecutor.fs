module KeepCommand.Executor

open System
open System.Diagnostics

type private Message =
    | Info of string
    | Error of string

let private write message = 

    let write (msg:string) color =
        if not <| String.IsNullOrEmpty(msg) then
            Console.ForegroundColor <- color 
            Console.WriteLine(" {0}", msg)

    match message with
    | Info str -> write str ConsoleColor.White
    | Error str ->  write str ConsoleColor.Red

let executeCommand (cmd:string) args=
    Console.ForegroundColor <- ConsoleColor.White
    let info = ProcessStartInfo()
    info.FileName <- cmd.Trim()
    info.Arguments <- args
    info.UseShellExecute <- true

    let ps = new Process()
    ps.StartInfo <- info
    ps.Start() |> ignore
    
    ps.WaitForExit() |> ignore