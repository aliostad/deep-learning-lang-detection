module ProcessFileNames

open System.IO

let processDependencyFile x dir =
    let path fileName = Path.Combine( dir, fileName)
    let p = path "paket.references"
    printfn "found: %s" p
    File.WriteAllText(p, File.ReadAllText x)
    File.Delete x


let rename dir =
    dir |> Directory.EnumerateFiles
    |> Seq.filter(fun x -> x.Contains("ripple.dependencies.config"))
    |> Seq.iter (fun x -> processDependencyFile x dir)

let enumerateDirectories dir = dir |> Directory.EnumerateDirectories

let rec renameRippleDependencyFiles startDir =
    rename startDir
    for dir in (enumerateDirectories startDir) do
        renameRippleDependencyFiles dir
