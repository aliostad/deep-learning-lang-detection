#r @"..\packages\FParsec\lib\portable-net45+netcore45+wpa81+wp8\FParsecCS.dll"
#r @"..\packages\FParsec\lib\portable-net45+netcore45+wpa81+wp8\FParsec.dll"  
#load "Graphs.fs"
#load "CoolAst.fs"
#load "CoolType.fs"

open System.IO
open CoolAst
open CoolType
open Graphs
open FParsec

type ProcessResult = { exitCode : int; stdout : string; stderr : string }
let executeProcess (exe,cmdline) =
    let psi = System.Diagnostics.ProcessStartInfo(exe,cmdline) 
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true        
    let p = System.Diagnostics.Process.Start(psi) 
    let output = System.Text.StringBuilder()
    let error = System.Text.StringBuilder()
    p.OutputDataReceived.Add(fun args -> output.Append(args.Data) |> ignore)
    p.ErrorDataReceived.Add(fun args -> error.Append(args.Data) |> ignore)
    p.BeginErrorReadLine()
    p.BeginOutputReadLine()
    p.WaitForExit()
    { exitCode = p.ExitCode; stdout = output.ToString(); stderr = error.ToString() }

let checkFromFile (srce) =
    let pref = __SOURCE_DIRECTORY__ + "\\tests\\"
    let src = pref + srce + ".cl"
    let out = pref + srce
    let astFile = out + ".cl-ast"
    let args = "--parse --out " + out + " " + src
    let cool = System.Environment.GetEnvironmentVariable("COOLEXE")
    printfn "out = %s" out

    if File.Exists(astFile) then File.Delete(astFile)
     
    executeProcess (cool, args) |> printfn "Process executed: \n%A"
    if File.Exists(astFile) then
        let text = File.ReadAllText(astFile)
        match run CoolAst.Deserialize.pAst text with
        | ParserResult.Success (cs,_,_) ->
            let ast = Ast cs
            match typecheckAst ast with
            | CoolType.Result.Success _ -> printfn "%A" ast
            | CoolType.Result.Failure ers -> 
                printfn "Errors: "
                printfn "%A" ers
            printfn "======================================="
            File.WriteAllText("scriptOut.txt", analyze ast |> sprintf "%A")
            
        | ParserResult.Failure _ -> printfn "parse error"
    else
        printfn "File does not exist"

checkFromFile ("5-inheritance")
