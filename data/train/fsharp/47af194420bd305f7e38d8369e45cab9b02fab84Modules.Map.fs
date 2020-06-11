namespace Arche.Modules

open WebSharper
open Arche.Common

module Map =

    module private Server =
        
        [<Rpc>]
        let getGoogleMapApiKey() =
            async {
                return Config.value.GoogleMap.ApiKey
            }

    [<JavaScript>]
    module Client =
        open WebSharper.UI.Next
        open WebSharper.UI.Next.Html
        open WebSharper.UI.Next.Client
        open WebSharper.JavaScript

        let page city =
            city
            |> View.MapAsync (fun (city: string) ->
                async {
                    let! apiKey = Server.getGoogleMapApiKey()
                    return apiKey, city
                })
            |> View.Map (fun (key, city) ->
                iframeAttr [ attr.width "100%"
                             attr.height "100%"
                             attr.frameborder "0"
                             attr.style "min-height: 200px; border: 0;"
                             attr.src (sprintf "https://www.google.com/maps/embed/v1/place?key=%s&q=%s" key city) ] [])
            |> Doc.EmbedView