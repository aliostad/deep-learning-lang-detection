#I  @"C:\Documenti\EASYSOFT2017_INSPIRON17\ESPERIMENTI ISTS\My First Google Script\GoogleScript1"

open System.IO
open System.Diagnostics


let processFiles()=
    let p=new Process()
    p.StartInfo.UseShellExecute<-false
    p.StartInfo.RedirectStandardOutput<-true
    p.StartInfo.FileName<-"ts2Fable.exe"
    Directory.GetFiles( @"\TypeDefinition\","*.ts")
    |> Array.map (fun f -> p.StartInfo.Arguments <- sprintf "%s" f; p.Start() |> ignore; p.StandardOutput.ReadToEnd(),f)
    |> Array.iter (fun (s,f) -> File.WriteAllText( sprintf "%s%s" f ".fs",s))

processFiles()

Path.GetFullPath("script1.fsx")


