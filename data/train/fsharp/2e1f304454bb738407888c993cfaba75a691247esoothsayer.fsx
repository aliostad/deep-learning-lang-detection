#r "../node_modules/fable-core/Fable.Core.dll"
#r "../node_modules/fable-powerpack/Fable.PowerPack.dll"
#load "../../paket-files/Ionide/ionide-vscode-helpers/Fable.Import.VSCode.fs"
#load "../../paket-files/Ionide/ionide-vscode-helpers/Helpers.fs"
#load "../../soothsayer/AssemblyData.fs"

open System
open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Fable.Import.Browser
open Fable.Import.JS
open Fable.Import.Node

[<Erase>]
module Child_process_promise =

    [<AutoOpen>]    
    type Globals =
        member x.exec(cmd:string, ?options:obj) : Promise<child_process_types.ChildProcess> =
            Exceptions.jsNative

    [<Import("*", "child-process-promise")>]
    let child_process : Globals = Exceptions.jsNative

module HtmlMapping =
    open AssemblyData
    let mapFunction (SMember(name, classification, signature)) =
        sprintf """
<h4>%s<h4>
<p><i>%s</i></p><hr>""" name signature

    
    let mapType t = 
        ""

    let mapNamespace n =
        ""
    let node s c =
        sprintf "<%s>%s</%s>" s c s

    let p s =
        node "p" s

    let mapAssembly (a:AssemblyData.Assembly) =
        let mutable pretty = "<body><div style=\"height: 100%; width: 100%\">" + node "h1" a.name
        for entity in a.entities do
            match entity with
            | Namespace (SNamespace(name, entities)) ->
                pretty <- pretty + node "h2" name
            | Module (SModule(name, entities)) ->
                pretty <- pretty + node "h2" name
            | Type(SType(name, classification, members)) ->
                pretty <- pretty + node "h3" name
                for m in members do
                    pretty <- pretty + mapFunction m
            | Member(SMember(name, classification, signature) as sm) ->
                pretty <- pretty + mapFunction sm
            //TODO recurse heavily on children
        pretty + "</div></body>"
               

module Soothsayer =
    open Fable.PowerPack
    open Ionide.VSCode.Helpers
    open Child_process_promise
    open Fable.Import.vscode
    
    let resolverExe = VSCode.getPluginPath "7sharp9.soothsayer" + "/bin/Resolver.exe"
    let soothsayerExe = VSCode.getPluginPath "7sharp9.soothsayer" + "/bin/soothsayer.exe"
    let choosenAssembly = ""
    let choosenProject = "~/fsharp/soothsayer-addin/soothsayer/soothsayer.fsproj"
    //TODO: collection from quickpick

    let createCommand command args =
        if Process.isWin() then command + " " + args
        else "mono" + " " + command + " " + args

    let createProcessOptionsWithBuffer size =
        createObj [
            "cwd" ==> workspace.rootPath
            "maxBuffer" ==> size
            //TODO: set max size of buffer later, only really applicable for soothsayer stdio as it will be large
        ]

    let createSoothsayerProvider() =
         { new TextDocumentContentProvider
            with
                member this.provideTextDocumentContent (uri, token) =
                    let assemblyPath = uri.path
                    let optionsForSoothsayer = createProcessOptionsWithBuffer (1024 * 4000)
                    promise {
                        let! soothsayerResult =
                            child_process.exec(createCommand soothsayerExe assemblyPath, optionsForSoothsayer)
                            
                        let soothsayerResult, SoothsayerError =
                            soothsayerResult.stdout.ToString(), soothsayerResult.stderr

                        let assemblyDetail = Fable.Core.Serialize.ofJson<AssemblyData.Assembly> soothsayerResult
                
                        let prettyHtml = HtmlMapping.mapAssembly assemblyDetail
                        return prettyHtml}

            }

    
    let runResolver() =
        promise {
            let resolverOptions = createProcessOptionsWithBuffer (1024 * 500)

            let! result = child_process.exec(createCommand resolverExe choosenProject, resolverOptions)
            let result, error = result.stdout, result.stderr

            let! quickPickresult = 
                let inputList = 
                    result.ToString().Split([|"\r";"\n"|], StringSplitOptions.RemoveEmptyEntries)
                    |> ResizeArray
                vscode.window.showQuickPick (unbox inputList)
            let soothsayerUri = sprintf "soothsayer://%s" quickPickresult
            do! vscode.commands.executeCommand("vscode.previewHtml", soothsayerUri, vscode.ViewColumn.Two)
            return promise.Zero
        } |> ignore
//---

let activate(context: vscode.ExtensionContext) =
    let registerCommand com (f: unit->unit) =
        vscode.commands.registerCommand(com, unbox f)
        |> context.subscriptions.Add
    
    let prov = Soothsayer.createSoothsayerProvider()
    vscode.workspace.registerTextDocumentContentProvider("soothsayer" |> unbox, prov) |> ignore

    registerCommand "extension.soothsayer" Soothsayer.runResolver
