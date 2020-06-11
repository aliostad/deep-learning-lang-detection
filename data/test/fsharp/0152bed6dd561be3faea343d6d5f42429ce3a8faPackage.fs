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

module Generators.Package
open FsHelpers
open System.IO
open System.Xml.Linq
open System.Linq
open XmlHelpers
open Env
open Collections
open MSBuildHelpers
open Graph


let private generateItemGroupContent (pkgDir : DirectoryInfo) (files : FileInfo seq) =
    seq {
        for file in files do
            let assemblyName = Path.GetFileNameWithoutExtension (file.FullName)
            let relativePath = ComputeRelativeFilePath pkgDir file
            let hintPath = sprintf "%s%s" MSBUILD_PACKAGE_FOLDER relativePath |> ToWindows
            yield XElement(NsMsBuild + "Reference",
                    XAttribute(NsNone + "Include", assemblyName),
                    XElement(NsMsBuild + "HintPath", hintPath),
                    XElement(NsMsBuild + "Private", "true"))
    }

let private generateItemGroupCopyContent (pkgDir : DirectoryInfo) (fxLibs : DirectoryInfo) =
    let relativePath = ComputeRelativeDirPath pkgDir fxLibs
    let files = sprintf @"$(SolutionDir)\.full-build\packages\%s\**\*.*" relativePath
    let copyFiles = XElement(NsMsBuild + "FBCopyFiles",
                        XAttribute(NsNone + "Include", files))
    copyFiles

let private generateItemGroup (fxLibs : DirectoryInfo) (condition : string) =
    let pkgDir = Env.GetFolder Env.Folder.Package
    let dlls = fxLibs.EnumerateFiles("*.dll")
    let exes = fxLibs.EnumerateFiles("*.exes")
    let files = Seq.append dlls exes |> List.ofSeq
    let itemGroup = generateItemGroupContent pkgDir files
    XElement(NsMsBuild + "When",
        XAttribute(NsNone + "Condition", condition),
            XElement(NsMsBuild + "ItemGroup",
                itemGroup))

let private generateItemGroupCopy (fxLibs : DirectoryInfo) (condition : string) =
    let pkgDir = Env.GetFolder Env.Folder.Package
    let itemGroup = generateItemGroupCopyContent pkgDir fxLibs
    XElement(NsMsBuild + "When",
        XAttribute(NsNone + "Condition", condition),
            XElement(NsMsBuild + "ItemGroup",
                itemGroup))

let private generateChooseRefContent (libDir : DirectoryInfo) =
    let whens = seq {
        if libDir.Exists then
            let foundDirs = libDir.EnumerateDirectories() |> Seq.map (fun x -> x.Name) |> List.ofSeq
            // for very old nugets we do not have folder per platform
            let dirs = if foundDirs.Length = 0 then [""]
                       else foundDirs
            let path2platforms = Paket.PlatformMatching.getSupportedTargetProfiles dirs
            let allTargets = path2platforms |> Seq.map (fun x -> x.Value) |> List.ofSeq

            for path2pf in path2platforms do
                let pathLib = libDir |> FsHelpers.GetSubDirectory path2pf.Key
                let condition = Paket.PlatformMatching.getCondition None allTargets (List.ofSeq path2pf.Value)
                let whenCondition = if condition = "$(TargetFrameworkIdentifier) == 'true'" then "True"
                                    else condition
                yield generateItemGroup pathLib whenCondition
    }

    seq {
        if whens.Any() then
            yield XElement (NsMsBuild + "Choose", whens)
    }

let private generateChooseCopyContent (libDir : DirectoryInfo) =
    let whens = seq {
        if libDir.Exists then
            let foundDirs = libDir.EnumerateDirectories() |> Seq.map (fun x -> x.Name) |> List.ofSeq
            // for very old nugets we do not have folder per platform
            let dirs = if foundDirs.Length = 0 then [""]
                       else foundDirs
            let path2platforms = Paket.PlatformMatching.getSupportedTargetProfiles dirs
            let allTargets = path2platforms |> Seq.map (fun x -> x.Value) |> List.ofSeq

            for path2pf in path2platforms do
                let pathLib = libDir |> FsHelpers.GetSubDirectory path2pf.Key
                let condition = Paket.PlatformMatching.getCondition None allTargets (List.ofSeq path2pf.Value)
                let whenCondition = if condition = "$(TargetFrameworkIdentifier) == 'true'" then "True"
                                    else condition
                yield generateItemGroupCopy pathLib whenCondition
    }

    seq {
        if whens.Any() then
            yield XElement (NsMsBuild + "Choose", whens)
    }

let private generateDependenciesRefContent (dependencies : Package seq) =
    seq {
        for dependency in dependencies do
            let defineName = MsBuildPackagePropertyName dependency
            let condition = sprintf "'$(%s)' == ''" defineName

            let depId = dependency.Name
            let dependencyTargets = sprintf "%s%s/package.targets" MSBUILD_PACKAGE_FOLDER depId
            yield XElement(NsMsBuild + "Import",
                      XAttribute(NsNone + "Project", dependencyTargets),
                      XAttribute(NsNone + "Condition", condition))
    }

let private generateDependenciesCopyContent (dependencies : Package seq) =
    seq {
        for dependency in dependencies do
            let defineName = MsBuildPackagePropertyName dependency
            let condition = sprintf "'$(%sCopy)' == ''" defineName

            let depId = dependency.Name
            let dependencyTargets = sprintf "%s%s/package-copy.targets" MSBUILD_PACKAGE_FOLDER depId

            yield XElement(NsMsBuild + "Import",
                      XAttribute(NsNone + "Project", dependencyTargets),
                      XAttribute(NsNone + "Condition", condition))
    }

let private generateProjectRefContent (package : Package) (imports : XElement seq) (choose : XElement seq) =
    let defineName = MsBuildPackagePropertyName package
    let propCondition = sprintf "'$(%s)' == ''" defineName
    let project = XElement (NsMsBuild + "Project",
                    XAttribute (NsNone + "Condition", propCondition),
                    XElement (NsMsBuild + "PropertyGroup",
                        XElement (NsMsBuild + defineName, "Y")),
                    imports,
                    choose)
    project

let private generateProjectCopyContent (package : Package) (imports : XElement seq) (choose : XElement seq) =
    let defineName = sprintf "%sCopy" (MsBuildPackagePropertyName package)
    let propCondition = sprintf "'$(%s)' == ''" defineName
    let project = XElement (NsMsBuild + "Project",
                    XAttribute (NsNone + "Condition", propCondition),
                    XElement (NsMsBuild + "PropertyGroup",
                        XElement (NsMsBuild + defineName, "Y")),
                    imports,
                    choose)
    project


let private generateTargetForPackageRef (package : Package) =
    let pkgsDir = Env.GetFolder Env.Folder.Package
    let pkgDir = pkgsDir |> GetSubDirectory (package.Name)
    let libDir = pkgDir |> GetSubDirectory "lib"

    let dependencies = package.Dependencies

    let imports = generateDependenciesRefContent dependencies
    let choose = generateChooseRefContent libDir
    let project = generateProjectRefContent package imports choose

    let targetFile = pkgDir |> GetFile "package.targets"
    project.Save (targetFile.FullName)

let private generateTargetForPackageCopy (package : Package) =
    let pkgsDir = Env.GetFolder Env.Folder.Package
    let pkgDir = pkgsDir |> GetSubDirectory (package.Name)
    let libDir = pkgDir |> GetSubDirectory "lib"

    let dependencies = package.Dependencies

    let imports = generateDependenciesCopyContent dependencies
    let choose = generateChooseCopyContent libDir
    let project = generateProjectCopyContent package imports choose

    let targetFile = pkgDir |> GetFile "package-copy.targets"
    project.Save (targetFile.FullName)


let private generateTargetsForPackage (package : Package) =
    generateTargetForPackageRef package
    generateTargetForPackageCopy package


let rec collectDependencies (packages : Package set) =
    if packages = Set.empty then Set.empty
    else
        let dependencies = packages |> Set.map (fun x -> x.Dependencies)
                                    |> Set.unionMany
        packages + collectDependencies dependencies


let GeneratePackageImports () =
    let graph = Graph.load()
    graph.Packages |> collectDependencies
                   |> Seq.iter generateTargetsForPackage
