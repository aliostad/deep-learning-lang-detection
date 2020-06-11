open System
open System.IO

let inline (@@) (a:string) (b:string) = Path.Combine(a,b)

let srcdir = __SOURCE_DIRECTORY__ 
let fsdlxdir = srcdir @@ "FsDLX/src/FsDLX.Assembler/"

let files = Directory.GetFiles(fsdlxdir, "*.fs")

let bindir = 
    let path = srcdir @@ "bin"
    if Directory.Exists(path) then Directory.Delete(path,true)
    let dir = Directory.CreateDirectory(srcdir @@ "bin")
    dir.FullName
    
let copypath f = bindir @@ Path.GetFileName(f)

files |> Seq.iter (fun f -> File.Copy(f, copypath f))