#r "System.Xml"
#r "System.Xml.Linq"
open System
open System.IO
open System.Xml.Linq

//Bootstrap script to create the initial Projekt ConsoleApplication

//helpers
let (</>) a b = Path.Combine(a,b)
let xname s = XName.Get s
let copy src dst =
    File.Copy(src, dst)

let replace (o: string) n (s : string) =
    s.Replace(o, n)

//args
let projectName = "Projekt"
let safeprojectName = projectName //what does it mean to be a safe project name?
let guid1 = Guid.NewGuid().ToString() 
let targetFrameworkVersion = "4.5"
let dir = __SOURCE_DIRECTORY__ </> "src" //where the new project is to be created
let template = "ConsoleApplication"
let org = "MyOrganisation"

let templateFile template file =
    __SOURCE_DIRECTORY__ </> "templates" </> template </> file 
let (|Range|_|) range c =
    List.tryFind ((=) c) range
let r  =['a' .. 'z']
let s = ""
match s.[0] with
| Range r _ -> ()

let templateToTarget template target projectName =
    let t = Directory.CreateDirectory (target </> projectName)
    let tProjFile = templateFile template (sprintf "%s.fsproj" template)
    copy tProjFile (t.FullName </> sprintf "%s.fsproj" projectName)
    let tappConf = templateFile template "App.config" 
    copy tappConf (t.FullName </> "App.config")
    let tassInfo = templateFile template "AssemblyInfo.fs" 
    copy tassInfo (t.FullName </> "AssemblyInfo.fs")
    let tprogram = templateFile template "Program.fs" 
    copy tprogram (t.FullName </> "Program.fs")

let update targetDir =
    Directory.GetFiles targetDir
    |> Seq.map (fun f -> f, File.ReadAllText f)
    |> Seq.map(fun (f, text) ->
        //I am not too proud for a bit of crummy string replacement :)
        f,  replace "$safeprojectname$" safeprojectName text
            |> replace "$targetframeworkversion$" targetFrameworkVersion
            |> replace "$guid1$" guid1 
            |> replace "$projectname$" projectName 
            |> replace "$registeredorganization$" org 
            |> replace "$year$" (DateTime.Now.Year.ToString()) 
            |> replace "$registeredorganization$" org )
    |> Seq.iter (fun (f, text) ->
        File.WriteAllText(f, text))

templateToTarget "ConsoleApplication" dir projectName 
update (dir </> projectName)

//let doc = XDocument.Load(path)


