#I "../packages/FAKE/tools/"
#r "../packages/FAKE/tools/FakeLib.dll"
#r "../packages/AjaxMin/lib/net40/AjaxMin.dll"

open Fake
open Fake.FileHelper
open System.IO
open Microsoft.Ajax.Utilities

let buildDir = "./build"

let writeToFile path content = File.WriteAllText(path, content)

let append right left = left + right

let minifier = new Minifier()

let compressCss = minifier.MinifyStyleSheet

let compressJs = minifier.MinifyJavaScript

let rec matchVaildExtensions extensions file =
  match extensions with
  | [] -> false
  | [extension] ->
    match (|EndsWith|_|) extension file with
    | Some() -> true
    | _ -> false
  | head::tail ->
    match (|EndsWith|_|) head file with
    | Some() -> true
    | _ -> matchVaildExtensions tail file

Target "Bower" (fun _ ->
    Shell.Exec("bower", "install --allow-root", "./") |> ignore)

Target "BuildRelease" (fun _ ->
    ["./bjoernerlwein_de/bjoernerlwein_de.fsproj"]
    |> MSBuildRelease buildDir "Build"
    |> Log "AppBuild-Output: ")

Target "BuildDebug" (fun _ ->
    ["./bjoernerlwein_de/bjoernerlwein_de.fsproj"]
    |> MSBuildDebug buildDir "Build"
    |> Log "AppBuild-Output: ")

Target "CssMin" (fun _ ->
    let cssdir = buildDir + "/static/css/"
    buildDir + "/static/bower/normalize-css/" + "normalize.css"
    |> File.ReadAllText
    |> append (File.ReadAllText (cssdir + "style.css"))
    |> compressCss
    |> writeToFile (cssdir + "style.min.css"))

Target "CopyStaticfiles" (fun _ ->
    CopyDir (buildDir + "/static/bower") "bjoernerlwein_de/static/bower" (matchVaildExtensions [".css"; ".js"]) |> ignore
    CopyDir (buildDir + "/static/css") "bjoernerlwein_de/static/css" (matchVaildExtensions [".css"]) |> ignore
    CopyDir (buildDir + "/static/js") "bjoernerlwein_de/static/js" (matchVaildExtensions [".js"]) |> ignore
)

Target "CopyContent" (fun _ ->
    CopyDir (buildDir + "/content") "bjoernerlwein_de/content" (matchVaildExtensions [".json"]) |> ignore
)



Target "JsMin" (fun _ ->
    let jsDir = buildDir + "/static/"
    File.ReadAllText (jsDir + "bower/vue/dist/vue.js")
    |> append (File.ReadAllText (jsDir + "/bower/nanoajax/nanoajax.min.js"))
    |> append (File.ReadAllText (jsDir + "/js/script.js"))
    |> compressJs
    |> writeToFile (jsDir + "js/script.min.js")
    |> ignore)

Target "RunRelease" (fun _ ->
    Shell.Exec("bjoernerlwein_de.exe", "production", buildDir)
    |> ignore)

Target "RunDebug" (fun _ ->
    Shell.Exec("bjoernerlwein_de.exe", "", buildDir)
    |> ignore)

Target "Clean" (fun _ ->
    CleanDir buildDir)
