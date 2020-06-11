open System
open System.Diagnostics

let makePSI fileName arguments =
    ProcessStartInfo( 
        FileName = fileName,
        Arguments = arguments,
        UseShellExecute = false,
        CreateNoWindow = true,
        RedirectStandardInput = true,
        RedirectStandardOutput = true,
        RedirectStandardError = true
    )


let files = 
    Console.Write("Source Dir [default = current dir]: ")
    let dir = Console.ReadLine() |> fun s -> if String.IsNullOrWhiteSpace s then __SOURCE_DIRECTORY__ else s.Trim()
    System.IO.Directory.GetFiles(dir)

let compileProc = 
    let fileString= 
        files 
        |> Seq.filter (System.IO.Path.GetExtension >> ((=) ".erl") )
        |> Seq.reduce (fun acc file -> acc + " " + file)
    makePSI "erlc" ("+native " + fileString)

let run (psi:ProcessStartInfo) =
    use proc = Process.Start(psi)
    proc.WaitForExit()
    Console.WriteLine(proc.StandardOutput.ReadToEnd().Trim())
    Console.WriteLine(proc.StandardError.ReadToEnd().Trim())

run compileProc