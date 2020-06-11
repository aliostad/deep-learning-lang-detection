module Projekt.Template
open System
open System.IO
open System.Xml.Linq

let (</>) a b = Path.Combine(a,b)
let xname s = XName.Get s
let copy src dst =
    try File.Copy(src, dst) |> Success
    with
    | ex ->
        Failure (sprintf "err: failed to copy %s to %s. Message: %s" src dst ex.Message)

let replace (o: string) n (s : string) =
    s.Replace(o, n)

let copyToTarget templatesDir (data : ProjectInitData) : Result<unit> =
    result {
        let name = Path.GetFileNameWithoutExtension data.ProjPath
        let targetDir = Path.GetDirectoryName data.ProjPath
        let templateDir = templatesDir </> sprintf "%A" data.Template

        if Directory.Exists targetDir then
            return! Failure (sprintf "err: target directory: %s already exists" targetDir)
        else
            let _ = Directory.CreateDirectory targetDir 
            let p = templateDir </> (sprintf "%A.fsproj" data.Template)
            do! copy p (targetDir </> sprintf "%s.fsproj" name)

            let files = 
                Directory.GetFiles templateDir 
                |> Seq.filter (fun f -> Path.GetExtension f <> ".fsproj")

            for file in files do
                let name = Path.GetFileName file
                do! copy file (targetDir </> name) }


let update (data: ProjectInitData) =
    let name = Path.GetFileNameWithoutExtension data.ProjPath
    let targetDir = Path.GetDirectoryName data.ProjPath
    let guid1 = Guid.NewGuid() |> string
    Directory.GetFiles targetDir 
    |> Seq.map (fun f -> f, File.ReadAllText f)
    |> Seq.map (fun (f, text) ->
        //I am not too proud for a bit of crummy string replacement :)
        f,  replace "$safeprojectname$" name text
            |> replace "$targetframeworkversion$" (string data.FrameworkVersion) //TODO override ToString
            |> replace "$guid1$" guid1 
            |> replace "$projectname$" name 
            |> replace "$registeredorganization$" data.Organisation 
            |> replace "$year$" (DateTime.Now.Year.ToString()) )
    |> Seq.iter (fun (f, text) ->
        File.WriteAllText(f, text))

let init (templatesDir : string) (data : ProjectInitData) =
    result {
        let templatesDir = Path.GetFullPath templatesDir
        do! copyToTarget templatesDir data
        update data }
