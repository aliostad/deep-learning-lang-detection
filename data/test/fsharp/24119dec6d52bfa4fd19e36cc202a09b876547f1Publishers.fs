//   Copyright 2014-2017 Pierre Chalamet
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

module Core.Publishers
open FsHelpers
open Env
open System.IO
open Graph
open Exec


type private PublishApp =
    { Name : string
      App : Application
      Version : string }


let private publishCopy (app : PublishApp) =
    let wsDir = GetFolder Env.Folder.Workspace
    let project = app.App.Project
    let repoDir = wsDir |> GetSubDirectory (project.Repository.Name)
    if repoDir.Exists then
        let projFile = repoDir |> GetFile project.ProjectFile
        let args = sprintf "/nologo /t:FBPublish /p:SolutionDir=%A /p:FBApp=%A %A" wsDir.FullName app.Name projFile.FullName

        if Env.IsMono () then Exec "xbuild" args wsDir Map.empty |> IO.CheckResponseCode
        else Exec "msbuild" args wsDir Map.empty |> IO.CheckResponseCode

        let appDir = GetFolder Env.Folder.AppOutput
        let artifactDir = appDir |> GetSubDirectory app.Name
        Bindings.UpdateArtifactBindingRedirects artifactDir
    else
        printfn "[WARNING] Can't publish application %A without repository" app.Name

let private publishZip (app : PublishApp) =
    let tmpApp = { app
                   with Name = ".tmp-" + app.Name }
    publishCopy tmpApp

    let appDir = GetFolder Env.Folder.AppOutput
    let sourceFolder = appDir |> GetSubDirectory (tmpApp.Name)
    let targetFile = appDir |> GetFile app.Name
    if targetFile.Exists then targetFile.Delete()

    System.IO.Compression.ZipFile.CreateFromDirectory(sourceFolder.FullName, targetFile.FullName, Compression.CompressionLevel.Fastest, false)

let private publishDocker (app : PublishApp) =
    let tmpApp = { app
                   with Name = ".tmp-docker" }
    publishCopy tmpApp

    let appDir = GetFolder Env.Folder.AppOutput
    let sourceFolder = appDir |> GetSubDirectory (tmpApp.Name)
    let targetFile = appDir |> GetFile app.Name
    if targetFile.Exists then targetFile.Delete()

    let dockerArgs = sprintf "build -t %s ." app.Name
    Exec "docker" dockerArgs sourceFolder Map.empty |> IO.CheckResponseCode

    let imgFile = appDir |> GetSubDirectory app.Name
    let saveArgs = sprintf "save -o %s %s" imgFile.FullName app.Name
    Exec "docker" saveArgs sourceFolder Map.empty |> IO.CheckResponseCode
    sourceFolder.Delete(true)

let private publishNuget (app : PublishApp) =
    let tmpApp = { app
                   with Name = ".tmp-nuget-" + app.Name }
    publishCopy tmpApp

    let appDir = GetFolder Env.Folder.AppOutput
    let tmpFolder = appDir |> GetSubDirectory tmpApp.Name
    let tmp2Folder = appDir |> GetSubDirectory (".tmp-nuget2-" + app.Name)
    tmp2Folder.Create()

    let nuspec = tmpFolder.EnumerateFiles("*.nuspec")  |> Seq.head
    Generators.Packagers.UpdateDependencies nuspec
    let version = app.Version
    let nugetArgs = sprintf "pack -NoDefaultExcludes -NoPackageAnalysis -NonInteractive -OutputDirectory %s -version %s %s" tmp2Folder.FullName version nuspec.Name
    Exec "nuget" nugetArgs tmpFolder Map.empty |> IO.CheckResponseCode
    let nugetFile = tmp2Folder.EnumerateFiles() |> Seq.exactlyOne
    let targetFile = appDir |> GetFile app.Name
    nugetFile.CopyTo(targetFile.FullName, true) |> ignore

    tmp2Folder.Delete(true)
    tmpFolder.Delete(true)

let PublishWithPublisher (version : string) (app : Application) =
    let publisher =
        match app.Publisher with
        | PublisherType.Copy -> publishCopy
        | PublisherType.Zip -> publishZip
        | PublisherType.Docker -> publishDocker
        | PublisherType.NuGet -> publishNuget
    { Name = app.Name; App = app; Version = version }
        |> publisher


