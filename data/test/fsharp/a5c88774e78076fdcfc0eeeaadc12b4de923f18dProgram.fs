open System
open System.Diagnostics
open System.IO

let inline (||||>) (x1, x2, x3, x4) f = f x1 x2 x3 x4 

let retrieveUserInput () = 
    Console.ReadLine()

let askInputFile () = 
    Console.ForegroundColor <- ConsoleColor.White
    Console.Write "\n\tSample path : c:/Users/paulm/Desktop/test.mp4"
    Console.ResetColor()
    Console.Write "\n\n\tEnter the input (path + input file) : "
    Console.ForegroundColor <- ConsoleColor.Green
    let input = retrieveUserInput()
    Console.ResetColor()
    input

let askOutputExtension () = 
    Console.Write "\tEnter the output extension (avi, mkv, mp4 ...) : "
    Console.ForegroundColor <- ConsoleColor.Magenta
    let outputExtension = retrieveUserInput()
    Console.ResetColor()
    outputExtension

let askOutputFileName () = 
    Console.Write "\tEnter the output file name (without extension) : "
    Console.ForegroundColor <- ConsoleColor.Yellow
    let outputFileName = retrieveUserInput()
    Console.ResetColor()
    outputFileName

let askOutputFilePath () = 
    Console.Write "\tEnter the path where you would like to store the output : "
    Console.ForegroundColor <- ConsoleColor.Cyan
    let outputPath = retrieveUserInput()
    Console.ResetColor()
    outputPath

let initializeProcess inputFile extension = 
    ProcessStartInfo(
            FileName = sprintf "%s%s" __SOURCE_DIRECTORY__ @"\dist\ffmpeg.exe",
            Arguments = sprintf @"-i %s -f %s -" inputFile extension,
            UseShellExecute = false, 
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true)

let closeProcess (proc:Process) =
    proc.WaitForExit()
    proc.Close()
    proc

let getStream path outputFileName extension (proc:Process) = 
    try 
        let outputFilePath = sprintf "%s%s.%s" path outputFileName extension
        use stream = new MemoryStream()
        let buff:byte[] = Array.zeroCreate 1024
        let mutable i = 1
        while i > 0 do
            i <- proc.StandardOutput.BaseStream.Read(buff, 0, 1024)
            if i > 0 then stream.Write(buff, 0, i)
        use streamWritter = new FileStream(outputFilePath, FileMode.OpenOrCreate)
        stream.WriteTo streamWritter
        proc
    with 
    | ex ->
        Console.WriteLine ex
        proc

let startProcess (proc:Process) = 
    proc.Start() |> ignore
    proc

let handleProcess inputFile outputFileName extension path =
    Console.WriteLine "\n"
    new Process(StartInfo = initializeProcess inputFile extension) 
        |> startProcess
        |> getStream path outputFileName extension
        |> closeProcess  
        |> ignore

[<EntryPoint>]
let main argv = 
    Console.WriteLine "Starting Program ..."
    (askInputFile (), askOutputFileName (), askOutputExtension (), askOutputFilePath ()) ||||> handleProcess
    0
  