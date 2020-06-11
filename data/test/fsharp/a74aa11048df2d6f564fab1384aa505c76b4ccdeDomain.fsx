module Konfig.Domain

// include Fake lib
#I "../packages/FAKE/tools/"

#r "FakeLib.dll"

open Fake

type FileExtension = string
type RelativePath = string
type AbsolutePath = string
type Port = uint16

type FileWatch =
    | ByExtension of FileExtension

type NotificationChannel =
    | WebSocket of Port

type PostBuildTask =
    | CopyDirectory of src:RelativePath * dest:RelativePath
    | TransformConfig of srcFile:RelativePath * transformation:RelativePath
    | GenericTask of runFunc:(unit -> unit)
    | RunTests of filePattern:string * testFun:(seq<string> -> unit)

type DeployTask =
    | Zip of destination:AbsolutePath
    | CopyTo of destination:AbsolutePath
    | CopyToIIS of destination:AbsolutePath * appOffline:RelativePath

type WatchConfig = {
    Statics : FileWatch list
    Dynamics : FileWatch list
    NotificationChannel : NotificationChannel option
}

type BuildConfig = {
    OutputDirectory: RelativePath
    SupportsParallelBuild : bool
    SharedTasks: PostBuildTask list
    DebugTasks: PostBuildTask list
    ReleaseTasks: PostBuildTask list
}

type DeployConfig = {
    Tasks : DeployTask list
}

type ProjectConfig = {
    SourceDirectory : RelativePath
    ReleaseNotes : RelativePath option
    MetaData : AssemblyInfoFile.Attribute list
    Watch : WatchConfig
    Build : BuildConfig
    Deploy : DeployConfig
}