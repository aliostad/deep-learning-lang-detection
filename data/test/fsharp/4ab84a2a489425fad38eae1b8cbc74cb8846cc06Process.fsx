open System
open System.IO

open System.Diagnostics
open System.Text.RegularExpressions

type ProcessResult = { exitCode : int; stdout : string; stderr : string; output: string[] }

let executeProcessFrom(exe, args, path) =
    let psi = new System.Diagnostics.ProcessStartInfo(exe,args) 
    psi.UseShellExecute <- false
    // psi.RedirectStandardOutput <- true
    // psi.RedirectStandardError <- true
    // psi.RedirectStandardInput <- true
    //psi.CreateNoWindow <- true        
    psi.WorkingDirectory <- path
    let p = System.Diagnostics.Process.Start(psi) 
    let output = new System.Text.StringBuilder()
    let outputList = new System.Collections.Generic.List<string>();
    let error = new System.Text.StringBuilder()
    
    // p.OutputDataReceived.Add(fun args -> 
    //                             Console.WriteLine(args.Data)
    //                             output.Append(args.Data) |> ignore
    //                             outputList.Add(args.Data))
    // p.ErrorDataReceived.Add(fun args ->
    //                             Console.Error.WriteLine(args.Data)
    //                             error.Append(args.Data) |> ignore)
    //printfn "%s" ("starting process:"+exe + " with command "+ args + " in " + psi.WorkingDirectory)
    // p.BeginErrorReadLine()
    // p.BeginOutputReadLine()
    //let sw = new StreamWriter(p.StandardInput)
       

    //p.StandardInput.FlushAsync().ContinueWith(fun t -> t |> ignore) |> ignore
    //p.Start()
    p.WaitForExit()
    { exitCode = p.ExitCode; stdout = output.ToString(); stderr = error.ToString(); output = outputList.ToArray() }
let executeProcess (exe,args) =
    executeProcessFrom(exe, args, System.Environment.CurrentDirectory)


let shellExecute cmd =
    executeProcess("cmd.exe", "/c \"" + cmd + "\"")

let print (result: ProcessResult) =
    result.stderr |> printfn "%s"
    result.output |> Array.iter (fun q ->  printfn "%s" q)