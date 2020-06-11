// Using an F# script to help build thesis

open System
open System.IO
open System.Diagnostics


let project = "Master's Thesis"

let summary = "The research report that partially satisfies the requirement of a MSCS at EWU"

let sourceDirectory = "./thesis"

let outDirectory = DirectoryInfo(sourceDirectory + "/out")

let (</>) s1 s2 = Path.Combine(s1,s2)

let cleanOutDirectory() =
  let rec delete (dir:DirectoryInfo) =
    dir.GetFiles()
    |> Array.iter(fun f ->
      f.Delete()
    )

    dir.GetDirectories()
    |> Array.iter delete

    dir.Delete()
  delete outDirectory

let copyDependencies() =
  //printfn "Copying files to output directory..."
  let rec copyTo (src:DirectoryInfo) (dest:DirectoryInfo) =
    src.GetFiles()
    |> Array.filter(fun f -> not <| f.FullName.Contains(".fsx"))
    |> Array.iter(fun f ->
      f.CopyTo(dest.FullName </> f.Name) |> ignore
    )
    src.GetDirectories()
    |> Array.filter(fun d -> d.FullName <> outDirectory.FullName)
    |> Array.iter(fun (d:DirectoryInfo) ->
      let nd = DirectoryInfo(dest.FullName </> d.Name)
      nd.Create()
      copyTo d nd
    )
  let root = DirectoryInfo(sourceDirectory)
  outDirectory.Create()
  copyTo root outDirectory
  outDirectory.FullName </> "Thesis.tex"

let genProcessStartInfo thesis =
  //printfn "Creating process start info..."
  let startInfo = ProcessStartInfo()
  startInfo.FileName <- "latexmk"
  startInfo.Arguments <- "-f -pdf -file-line-error " + thesis
  startInfo.RedirectStandardOutput <- true
  startInfo.RedirectStandardError <- true
  startInfo.UseShellExecute <- false
  startInfo.WorkingDirectory <- outDirectory.FullName
  startInfo

let startBuildCmd startInfo =
  printfn "Running build command..."
  let build = new Process()
  build.StartInfo <- startInfo
  if build.Start() then
    Some build
  else 
    build.Close()
    build.Dispose()
    None

let checkBuildSuccess (processOp:Process option) =
  if processOp.IsNone then
    printfn "Build failed to start"
  else
    let build : Process = processOp.Value
    if not <| build.WaitForExit(10000) then
      printfn "Build failed. Check logs."
    else
      printfn "Build successful"
    build.Close()
    build.Dispose()

let copyThesisToRoot() =
  let outFile = outDirectory.FullName </> ".." </> ".." </> "Thesis.pdf"
  let inFile = outDirectory.FullName </> "Thesis.pdf"
  File.Copy(inFile,outFile,true)

let handleDependencies = copyDependencies

let buildProcess = (genProcessStartInfo >> startBuildCmd >> checkBuildSuccess)
let buildThesis = (handleDependencies >> buildProcess)

if outDirectory.Exists then
  //printfn "Cleaning up from last build..."
  cleanOutDirectory()
//printfn "Starting build pipeline..."
//handleDependencies()
buildThesis()
copyThesisToRoot()