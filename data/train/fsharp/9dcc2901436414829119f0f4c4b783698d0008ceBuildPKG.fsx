open System
open System.IO
open System.Diagnostics

let mkdir (path : String) = 
    Directory.CreateDirectory(path)

let copy (src : String) (dst : String) =
    File.Copy(src, dst, true)

let nuget (args : String[]) =
    let p = new Process()
    p.StartInfo.FileName <- "nuget.exe"
    p.StartInfo.Arguments <- String.Join(" ", args)
    p.StartInfo.UseShellExecute <- false
    p.StartInfo.RedirectStandardOutput <- true
    p.Start() |> ignore
    Console.Out.Write(p.StandardOutput.ReadToEnd())
    p.WaitForExit()


mkdir "lib/net20"
mkdir "lib/net40"
mkdir "lib/net45"

copy "../QiniuFS_20/bin/Release/QiniuFS_20.dll" "lib/net20/QiniuFS_20.dll"
copy "../QiniuFS_40/bin/Release/QiniuFS_40.dll" "lib/net40/QiniuFS_40.dll"
copy "../QiniuFS/bin/Release/QiniuFS.dll" "lib/net45/QiniuFS.dll"

nuget [| "pack"; "QiniuFS.nuspec" |]
