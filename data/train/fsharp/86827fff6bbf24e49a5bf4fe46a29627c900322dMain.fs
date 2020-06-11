namespace RestBackend

open WebSharper
open WebSharper.Sitelets
open WebSharper.UI.Next
open WebSharper.UI.Next.Html
open WebSharper.UI.Next.Server

type Action =
    | Home
    | Api of RestApi.Action

module Site =

    let HomePage (ctx: Context<Action>) =
        Content.Page(
            Title = "HomePage",
            Body = [
                client <@ Client.Main() @>
            ]
        )

    [<Website>]
    let Main =
        Sitelet.Sum [
            Sitelet.Content "/" Home HomePage
            Sitelet.Shift "api" (Sitelet.EmbedInUnion <@ Api @> RestApi.Sitelet)
        ]
