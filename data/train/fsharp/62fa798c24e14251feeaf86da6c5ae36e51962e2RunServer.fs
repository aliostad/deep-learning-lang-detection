namespace TextOn.Atom

open System
open System.IO
open Suave
open Suave.Http
open Suave.Operators
open Suave.Web
open Suave.WebPart
open Suave.WebSocket
open Suave.Sockets.Control
open Suave.Filters
open Newtonsoft.Json
open TextOn.Atom.DTO.DTO

type ServerModeConfig =
    {
        [<ArgDescription("The port to listen on.")>]
        [<ArgRange(8100, 8999)>]
        Port : int
    }

[<RequireQualifiedAccess>]
module internal RunServer =
    let run serverModeConfig =
        let mutable client : WebSocket option  = None

        System.Threading.ThreadPool.SetMinThreads(8, 8) |> ignore
        let commands = Commands(JsonSerializer.writeJson)

        let handler f : WebPart = fun (r : HttpContext) -> async {
              let data = r.request |> SuaveUtils.getResourceFromReq
              let! res = Async.Catch (f data)
              match res with
              | Choice1Of2 res ->
                 let res' = res |> List.toArray |> Json.toJson
                 return! Response.response HttpCode.HTTP_200 res' r
              | Choice2Of2 e -> return! Response.response HttpCode.HTTP_500 (Json.toJson e) r
            }

        let app =
            choose [
                path "/parse" >=> handler (fun (data : ParseRequest) -> commands.Parse data.FileName data.Lines)
                path "/generatorstart" >=> handler (fun (data : GeneratorStartRequest) -> commands.GenerateStart data.FileName (data.Lines |> List.ofArray) (data.LineNumber))
                path "/generatorstop" >=> handler (fun (data : GeneratorStopRequest) -> commands.GenerateStop ())
                path "/navigaterequest" >=> handler (fun (data : NavigateRequest) -> commands.Navigate data.FileName data.NavigateType data.Name)
                path "/generatorvalueset" >=> handler (fun (data : GeneratorValueSetRequest) -> commands.GeneratorValueSet data.Type data.Name data.Value)
                path "/generate" >=> handler (fun (data : GenerateRequest) -> commands.Generate data.Config)
                path "/updategenerator" >=> handler (fun (data : UpdateGeneratorRequest) -> commands.UpdateGenerator())
                path "/autocomplete" >=> handler (fun (data : SuggestionRequest) -> commands.GetCompletions data.fileName data.``type`` data.line data.column)
                path "/navigatetosymbol" >=> handler (fun (data : NavigateToSymbolRequest) -> commands.NavigateToSymbol data.FileName data.Line data.Column)
                path "/browserstart" >=> handler (fun (data : BrowserStartRequest) -> commands.BrowserStart data.FileName (data.Lines |> List.ofArray))
                path "/browserstop" >=> handler (fun (data : BrowserStopRequest) -> commands.BrowserStop ())
                path "/browserexpand" >=> handler (fun (data : BrowserExpandRequest) -> commands.BrowserExpand data.browserFile data.rootFunction data.indexPath)
                path "/browsercollapse" >=> handler (fun (data : BrowserExpandRequest) -> commands.BrowserCollapse data.browserFile data.rootFunction data.indexPath)
                path "/browservalueset" >=> handler (fun (data : BrowserValueSetRequest) -> commands.BrowserValueSet data.FileName data.Type data.Name data.Value)
                path "/updatebrowser" >=> handler (fun (data : UpdateBrowserRequest) -> commands.UpdateBrowser())
                path "/browsercycle" >=> handler (fun (data : BrowserCycleRequest) -> commands.BrowserCycle data.FileName data.LineNumber)
            ]

        let port = serverModeConfig.Port
        let defaultBinding = defaultConfig.bindings.[0]
        let withPort = { defaultBinding.socketBinding with port = uint16 port }
        let serverConfig =
            { defaultConfig with bindings = [{ defaultBinding with socketBinding = withPort }]}
        startWebServer serverConfig app
        0
