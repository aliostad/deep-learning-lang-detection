#load "..\lib\Resolver.fsx"
#load "..\lib\Process.fsx"
#load "..\lib\Args.fsx"
//Experimental
//see http://softwareblog.morlok.net/2008/07/05/f-compiler-fscexe-command-line-options/
open System.IO

let private compileScriptToExe (file: Resolver.ScriptFile) =
    printfn "attempting to compile %s with params %s" Resolver.fscPath file.Path
    Process.executeProcessFrom(Resolver.fscPath, file.Path, Path.GetDirectoryName(file.Path)) |> Process.print

let compileInternal = Args.has "--all-internal"
if compileInternal then
    let fullBinPath = Resolver.globalBasePath + """\nfsr\bin\"""
    printfn "attempting to resolve files at %s" fullBinPath
    let f = {Resolver.SearchPath.Path = fullBinPath; Resolver.SearchPath.AllowCache = false}
    let files = Resolver.getFiles f [Resolver.FileType.Fsx] Resolver.getScripts
    for file in files do   
        compileScriptToExe file
    ()
else
    //try to find a script by that name
    let m = 
        if Args.getArgs().Length > 1 then
            let target = (Args.getArgs() |> Array.toSeq |> Seq.skip 1 |> Seq.head)
            printfn "looking for %s" target
            let someMatch = Resolver.getClosestScriptMatch target [|Resolver.FileType.Fsx|]
            printfn "%A" someMatch
            someMatch
        else None
    printfn "%A" m
    match m with
    | Some(file) -> compileScriptToExe file
    | None ->
        let join (arr: string[]) = System.String.Join(" ", arr)

        let args = Args.getArgs()
                            |> Array.toSeq |> Seq.skip 1 |> Seq.toArray
                            |> join

        Process.executeProcess(Resolver.fscPath, args)
            |> Process.print