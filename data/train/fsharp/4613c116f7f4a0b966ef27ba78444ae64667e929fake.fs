[<ReflectedDefinition>]
module Ionide.VSCode

open System
open System.Text.RegularExpressions
open FunScript
open FunScript.TypeScript
open FunScript.TypeScript.fs
open FunScript.TypeScript.child_process
open FunScript.TypeScript.vscode

open Ionide
open Ionide.VSCode

module FakeService =
    type BuildData = {Name : string; Start : DateTime; mutable End : DateTime option; Process : ChildProcess}

    let mutable private linuxPrefix = ""
    let mutable private command = ""
    let mutable private script = ""
    let mutable private BuildList = ResizeArray()
    let outputChannel = window.Globals.createOutputChannel "FAKE"

    let private loadParameters () =
        let p = workspace.Globals.rootPath
        linuxPrefix <- Settings.loadOrDefault (fun s -> s.Fake.linuxPrefix ) "sh"
        command <- Settings.loadOrDefault (fun s -> p + "/" + s.Fake.command ) (if Process.isWin () then p + "/" + "build.cmd" else p + "/" + "build.sh")
        script <- Settings.loadOrDefault (fun s -> p + "/" + s.Fake.build )  (p + "/" + "build.fsx")
        ()

    let private startBuild target =
        if JS.isDefined target then
            outputChannel.clear ()
            let startedMessage = window.Globals.setStatusBarMessage "Build started"
            let fixSpaces s = if s |> String.exists ((=) ' ') then s |> sprintf "\"%s\"" else s
            let proc = Process.spawnWithNotification command linuxPrefix (fixSpaces target) outputChannel
            let data = {Name = (if target = "" then "Default" else target); Start = DateTime.Now; End = None; Process = proc}
            BuildList.Add data
            let cfg = workspace.Globals.getConfiguration ()
            if cfg.get("FAKE.autoshow", true) then outputChannel.show ()
            proc.on("exit",unbox<Function>(fun (code : string) ->
                startedMessage.dispose() |> ignore
                if code ="0" then
                    window.Globals.setStatusBarMessage ("Build completed", 10000.0) |> ignore
                else
                    window.Globals.showErrorMessage "Build failed" |> ignore
                data.End <- Some DateTime.Now)) |> ignore


    let cancelBuild target =
        let build = BuildList |> Seq.find (fun t -> t.Name = target)
        if Process.isWin () then
            Process.spawn "taskkill" "" ("/pid " + build.Process.pid.ToString() + " /f /t")
            |> ignore
        else
            build.Process.kill ()
        build.End <- Some DateTime.Now

    let buildHandle () =
        do loadParameters ()
        script
        |> Globals.readFileSync
        |> fun n -> (n.toString(), "Target \"([^\".]+)\"")
        |> Regex.Matches
        |> Seq.cast<Match>
        |> Seq.toArray
        |> Array.map(fun m -> m.Groups.[1].Value)
        |> Promise.lift
        |> window.Globals.showQuickPick
        |> Promise.toPromise
        |> Promise.success startBuild

    let cancelHandle () =
        let targets =
            BuildList
            |> Seq.where (fun n -> n.End.IsNone)
            |> Seq.map (fun n -> n.Name)
            |> Seq.toArray

        if Array.length targets = 1 then
            targets.[0]
            |> Promise.lift
            |> Promise.success cancelBuild
        else
            targets
            |> Promise.lift
            |> window.Globals.showQuickPick
            |> Promise.toPromise
            |> Promise.success cancelBuild

    let defaultHandle () =
        do loadParameters ()
        do startBuild ""

type Fake() =
    member x.activate(state:obj) =
        let t = workspace.Globals.rootPath
        commands.Globals.registerCommand("fake.fakeBuild", FakeService.buildHandle |> unbox ) |> ignore
        commands.Globals.registerCommand("fake.cancelBuild", FakeService.cancelHandle |> unbox) |> ignore
        commands.Globals.registerCommand("fake.buildDefault", FakeService.defaultHandle |> unbox) |> ignore
        ()
