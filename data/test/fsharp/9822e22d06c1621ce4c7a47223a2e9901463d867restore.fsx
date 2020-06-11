#load "..\lib\Resolver.fsx"
#load "..\lib\Process.fsx"

open System.IO

type FolderType = 
    | Paket of string
    | Bower of string
    | DynamicRefs of string

let rec getFolders path =
    seq{
        for filePath in Directory.EnumerateFiles(path) do
            match Path.GetFileName(filePath) with
            | "paket.dependencies" -> yield Paket(path)
            | "bower.json" -> yield Bower(path)
            | "_DynamicReferences.lock" -> yield DynamicRefs(path)
            | _ -> ()

        for d in Directory.EnumerateDirectories(path) do
            yield! getFolders d
        }

Process.shellExecute("npm install")  |> Process.print

let dirName = System.Environment.CurrentDirectory
for f in getFolders dirName do
    match f with
    | Paket(s) -> Process.shellExecute("cd " + s + "&& paket install") |> Process.print
    | Bower(s) -> Process.shellExecute("cd " + s + "&& bower install") |> Process.print
    | DynamicRefs(s) -> Process.shellExecute("cd " + s + "&& nfsr dynamic-refs refresh") |> Process.print
//refresh dynamic refs