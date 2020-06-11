#r @"packages\FAKE\tools\FakeLib.dll"

open Fake
open MSBuildHelper
open System.Xml

let packagesDir = "./packages"
let buildDir = "./build"
let binDir = buildDir + "/bin"
let dataDir = buildDir + "/data"
let dbName = "data.sdf"

let readXmlDocument (filePath:string) =
  let doc = new XmlDocument()
  doc.Load filePath |> ignore

  doc

let saveXmlDocument (filePath:string) (doc: XmlDocument) = 
  doc.Save filePath

Target "Clean" (fun _ -> 
  CleanDir buildDir
)

Target "Build" (fun _ -> 
  !! "./src/**/*.csproj"
    |> MSBuildRelease binDir "Build"
    |> Log "AppBuild-Output: "
)

Target "CleanExcessFiles" (fun _ -> 
  let files = !! (binDir + "/*.pdb")
                ++ (binDir + "/*.xml")
  
  DeleteFiles files
)

Target "CopySqlCE" (fun _ -> 
  let binariesDir = packagesDir + "/Microsoft.SqlServer.Compact.4.0.8854.1/NativeBinaries/"

  ["/x86"; "/amd64"]
  |> List.iter (fun dir -> 
       let targetDir = binDir + dir
       if not <| directoryExists targetDir then
         !! (binariesDir + dir + "/*.dll")
         |> Copy (binDir + dir)
     )
)

Target "CopyFormulas" (fun _ ->
  let formulas = "./src/MilitaryFaculty.Application/Content/formulas"

  CopyDir dataDir formulas (fun _ -> true)

)

Target "CopyDb" (fun _ ->
  [dbName] |> Copy dataDir
)

//TODO
Target "TransformConfig" (fun _ ->
  ()
)

Target "Publish" (fun _ -> ())

"Clean"
  ==> "Build"
  ==> "CleanExcessFiles"
  ==> "CopySqlCE"
  ==> "CopyFormulas"
  ==> "CopyDb"
  ==> "TransformConfig"
  ==> "Publish"

RunTargetOrDefault "Publish"