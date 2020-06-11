#load "..\lib\Process.fsx"
#load "..\lib\_Nfsr.fsx"
if Args.has "-pr" then
    printfn "started %A" System.DateTime.Now
open System.IO

#if INTERACTIVE
printfn "Running from interactive. Attempting to compile modules..."
Process.executeProcess(Resolver.fsiPath, __SOURCE_DIRECTORY__+ "\compile.fsx --all-internal") |> Process.print
#endif

let args = Args.getArgs() |> Seq.skip 1 |> Seq.toArray

if args.Length < 1 || args.[0] = "-h" || args.[0] = "--help" then
    File.ReadAllText(Resolver.globalBasePath + "\\nfsr\\bin\\nfsr.txt") |> printfn "%s"
else
    let headParams = _Nfsr.getHeadParams (args)
    let allowedTypes = _Nfsr.getAllowedTypes (headParams)

    let cmatch = 
        Resolver.getClosestScriptMatch (args.[headParams.Length]) allowedTypes

    match cmatch with
    | Some(m) ->    
                    let join (arr: string[]) = System.String.Join(" ", arr)
                    let fullPath = Resolver.fsiPath + " " + m.Path
                    let joinedArgs = join (args |> Array.toSeq |> Seq.skip (headParams.Length + 1) |> Seq.toArray)
                    let target = "\""+ m.Path + "\" " + joinedArgs

                    //Array.
                    let execute() = 
                        if m.FileType = Resolver.FileType.Fsx then
                            if File.Exists(m.Path.Replace(".fsx", ".exe")) then
                                printfn "using compiled exe instead"
                                Process.executeProcess(m.Path.Replace(".fsx", ".exe"), joinedArgs) |> ignore
                            else
                                Process.executeProcess(Resolver.fsiPath, target) |> ignore
                        else if m.FileType = Resolver.FileType.Powershell then
                            Process.executeProcess(Resolver.powershellPath, "-ExecutionPolicy Bypass -File "+ target) |> ignore
                            //Process.shellExecute("powershell -ExecutionPolicy Bypass -File "+ target) |> Process.print
                        else
                            Process.shellExecute(target) |> ignore

                    if Args.hasFor "-h" args || Args.hasFor "--help" args then
                        let helpfilePath = m.Path
                                            .Replace(".fsx", "")
                                            .Replace(".bat", "")
                                            .Replace(".ps1", "")
                                            .Replace(".sh", "") + ".txt"
                        if System.IO.File.Exists(helpfilePath) then
                            File.ReadAllText(helpfilePath) |> printfn "%s"
                        else
                            execute()
                    else
                    execute()

                

    | none -> printfn "no match"
if Args.has "-pr" then
    printfn "finished %A" System.DateTime.Now