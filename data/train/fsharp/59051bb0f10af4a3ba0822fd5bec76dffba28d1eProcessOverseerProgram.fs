module ProcessOverseer.Program

open System
open System.Diagnostics

let private usage<'a>() =
    eprintfn "usage:"
    eprintfn "  processOverseer <exitCodes> start exe <args>"
    eprintfn "or:"
    eprintfn "  processOverseer <exitCodes> attach processID exe <args>"
    System.Environment.Exit(-1)
    Unchecked.defaultof<'a>

let private escapeArgument(arg: string) =
    if arg.StartsWith("\"") && arg.EndsWith("\"") then arg
    else sprintf "\"%s\"" arg

let private makeCommandLine args = String.Join(" ", Seq.map escapeArgument args)

let attach (exitCodes: seq<int>) (pid: int) exe (args: seq<string>) =
    let modulePath = System.Reflection.Assembly.GetExecutingAssembly().Location
    let procArgs =
        Seq.concat [
            Seq.map string exitCodes
            seq ["attach"; string pid; exe]
            args]
        |> makeCommandLine
    let startInfo = ProcessStartInfo(modulePath, procArgs, UseShellExecute = false)
    Process.Start(startInfo)

[<EntryPoint>]
let private main argv =
    if argv.Length = 0  then
        usage()
    else
    let argv, exitCodes =
        let exitCodes =
            argv
            |> Seq.map(fun arg -> Int32.TryParse(arg))
            |> Seq.takeWhile fst
            |> Seq.map snd
            |> List.ofSeq
        let argvRest = Array.sub argv exitCodes.Length (argv.Length - exitCodes.Length)
            
        argvRest, if exitCodes = [] then [0] else exitCodes

    let overseer =
        match argv.[0] with
        | "start" ->
            if argv.Length = 1 then usage()
            let exe = argv.[1]
            let args = String.Join(" ",  Seq.skip 2 argv |> Seq.map escapeArgument)
            ProcessOverseer.Start(exitCodes, exe, args)
        | "attach" ->
            if argv.Length < 3 then usage()
            let pid = Process.GetProcessById(int argv.[1])
            let exe = argv.[2]
            let args = String.Join(" ",  Seq.skip 3 argv |> Seq.map escapeArgument)
            new ProcessOverseer(exitCodes, pid, exe, args)
        | _ ->
            usage()
    
    overseer.Run()

    0 // return an integer exit code
