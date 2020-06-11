// propagate
open System.IO
open System.Diagnostics
open Argu

// something that looks like Python, just 'cause
module OsPath = 
    let fileName = Path.GetFileName
    let absPath = Path.GetFullPath
    let isDir = Directory.Exists

module Glob =
    let SearchFromCwd pats =
        pats |> Array.collect (Fake.Globbing.search "." >> Array.ofList)

type CLIArguments =
    | Dry
    | Verbose
    | [<MainCommand; ExactlyOnce; Last>] Paths of string list
with 
    interface IArgParserTemplate with
        member x.Usage = 
            match x with  
            | Dry -> "Dry run (do not copy anything)"
            | Verbose -> "Show more diagnostics"
            | Paths _ -> "Paths: either <SOURCEDIR> <TARGETDIR> or <GLOBPATTERNS>... <TARGETDIR>"

type Env = {
    Args: ParseResults<CLIArguments>
}

            
let doCopy (env: Env) (srcFiles: string[])  (tgtdir: string) = 
    let srcMap = srcFiles |> Array.map (fun e -> (OsPath.fileName e, e)) |> Map.ofArray

    let dry = env.Args.Contains <@ Dry @>
    let verbose = env.Args.Contains <@ Verbose @>
    
    let tgtFiles = Directory.GetFileSystemEntries(tgtdir, "*.*", SearchOption.AllDirectories) |> Array.filter File.Exists
    let found = tgtFiles |> Array.choose (fun e ->
            let fname = OsPath.fileName e
            let srcPath = Map.tryFind fname srcMap
            match srcPath with
            | None -> None
            | Some pth when pth = e -> None
            | Some pth -> Some (pth, e)
            )
    let copyGroups = found |> Array.groupBy fst |> Array.map (fun (src, tgts) -> (src, Array.map snd tgts))   

    let reportTargetDirs =
        let targetDirs = found |> Array.map (snd >> Path.GetDirectoryName) |> Set.ofArray
        if verbose then do
            printfn "Source files: %A" srcFiles

        printfn "Copying %d files to:" srcFiles.Length
        targetDirs |> Set.iter (printfn "  %s")  
        ()

    let copyTo (src: string) (targets: #seq<string>) =
        let tryCopy src tgt =
            try
                if dry || verbose then
                    printfn "%s -> %s" src tgt

                if not dry then
                    File.Copy(src, tgt, true)
                true
            with
            | :? IOException as e when e.HResult &&& 0xffff = 32 ->
                printfn "ERR file locked: %s" tgt
                false
            
        seq {
            for tgt in targets do
                yield tryCopy src tgt
        } 
            
    let sw = Stopwatch.StartNew()

    let failed = 
        seq {
            for src, tgts in copyGroups do
                yield! copyTo src tgts
        } |> Seq.exists (id >> not)

    sw.Stop()
    if not failed then 
        printfn "Copied %d times in %.2f sec" found.Length ((float sw.ElapsedMilliseconds)/1000.0)
    ()

let copyDir (env: Env) srcDir tgtDir = 
    let srcFiles = Directory.GetFiles(srcDir, "*.*") |> Array.filter File.Exists
    doCopy env srcFiles tgtDir


let copyFilePatterns (env: Env) patterns tgtDir = 
    let expanded = Glob.SearchFromCwd patterns |> Array.filter File.Exists
    doCopy env expanded tgtDir

[<EntryPoint>]
let main argv =
    let parser = ArgumentParser.Create<CLIArguments>(programName = "propagate")

    let handlePaths env paths = 
        match paths with
        | [ srcDir; tgtDir ] when OsPath.isDir srcDir && OsPath.isDir tgtDir ->
            copyDir env (OsPath.absPath srcDir) (OsPath.absPath tgtDir)

        | arr when arr.Length > 1 ->
            let tgtDir = List.last arr
            let srcPats = arr.[0..arr.Length - 2] |> Array.ofList
            copyFilePatterns env srcPats tgtDir        

        | _ -> printfn "%s" <| parser.PrintUsage()
    
    let ok = 
        try 
            let args = parser.ParseCommandLine(ignoreUnrecognized = false)
            let env = {
                Args = args
            }
            handlePaths env (args.GetResult <@ Paths @>) 
            true
        with 
        | :? ArguParseException as e -> 
            printfn "[%s]" e.Message
            false

    0 // return an integer exit code
