module R4nd0mApps.TddStud10.VsixEditor.PdbInjector

open System
open System.IO

let private cleanFiles path = 
    printfn "... Cleaning up %s" path
    let excl = [ "Microsoft.VisualStudio."; "System.Xml"; ]
    let incl = [ "Microsoft.VisualStudio.TestPlatform" ]
    path
    |> fun d -> Directory.GetFiles(d, "*", SearchOption.AllDirectories)
    |> Seq.filter (fun f -> 
           let fn = Path.GetFileName(f)
           excl
           |> List.exists (fun f -> fn.StartsWith(f, StringComparison.OrdinalIgnoreCase))
           && not (incl |> List.exists (fun f -> fn.StartsWith(f, StringComparison.OrdinalIgnoreCase))))
    |> Seq.iter File.Delete
    path

let private copyPdbs src path = 
    printfn "... Copying pdbs from %s to %s" src path
    path
    |> Common.getTddStud10Executables
    |> Array.map (fun f -> Path.ChangeExtension(Path.GetFileName(f), "pdb"))
    |> Array.iter (fun f -> FileInfo(Path.Combine(src, f)).CopyTo(Path.Combine(path, f), true) |> ignore)
    path

let injectPdbs path = 
    printfn "VsixEditor: Cleaning and injecting pdbs into %s..." path
    let temp = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName())
    Directory.CreateDirectory(temp) |> ignore
    temp
    |> Common.unzipTo path
    |> cleanFiles
    |> copyPdbs (Path.GetDirectoryName path)
    |> Common.zipTo path
    printfn "VsixEditor: Done!"

