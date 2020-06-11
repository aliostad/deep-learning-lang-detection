open System;
open System.IO

let delDir dir =
    let dirInfo = new DirectoryInfo(dir)
    for file in dirInfo.GetFiles() do
        file.Delete() |> ignore
    for dir in dirInfo.GetDirectories() do
        dir.Delete(true) |> ignore

try
    delDir "Packaged/BreakoutFSharp"
with
    _ -> ()

try
    let releaseFiles = Directory.GetFiles("Release")
    let filesToCpy = 
        releaseFiles 
        |> Array.filter (fun (s:String) -> s.Contains ".dll" || s.Contains ".exe" || s.Contains ".jpg" || s.Contains ".wav")
        |> Array.map (fun (s:string)-> s.Substring 8)
        
    filesToCpy |> Array.map (fun file -> File.Copy("Release/" + file, "Packaged/BreakoutFSharp/" + file)) |> ignore
    File.Copy("README.md", "Packaged/BreakoutFSharp/README.md") |> ignore
    System.Console.WriteLine("project packaged successfully")
    System.Console.ReadKey() |> ignore
with
    :? System.Exception -> 
        System.Console.WriteLine("not all required files were found to create package")
        System.Console.ReadKey() |> ignore