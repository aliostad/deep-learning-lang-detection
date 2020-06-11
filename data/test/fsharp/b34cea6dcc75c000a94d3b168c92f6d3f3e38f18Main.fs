namespace TwoThumbsUp
open System
open TwoThumbsUp.Routing
open WebSharper.Html.Server
open WebSharper
open WebSharper.Sitelets

module Templating =
    open System.Web

    type MainTemplateData =
      { browserTitle: string
        title: Element list
        content: Element list }

    let MainTemplate =
        Content.Template<_>("~/MainTemplate.xml")
               .With("browserTitle", fun data -> data.browserTitle)
               .With("title", fun data -> data.title)
               .With("content", fun data -> data.content)

module Site =
    let ahref href text = A [ HRef href ] -< [Text text]

    let NotFoundPage endPoint =
        Content.WithTemplate Templating.MainTemplate {
            browserTitle = "Page not found - TwoThumbsUp"
            title = [Text "Page not found"]
            content =
               [Span [Class "text-sub-heading"]
                -< [Text "The requested URL "
                    B [Text (link endPoint)]
                    Text " does not exist."]
                ] }

    let CreateVotePage votingRoomName endPoint =
        Content.WithTemplate Templating.MainTemplate
          { browserTitle = "TwoThumbsUp - Create voting room"
            title = [Text "Create a voting room"]
            content = [Div [ClientSide <@ Client.form_createVote votingRoomName @>]] }
    
    let IndexPage = CreateVotePage ""

    let ManageVotePage votingRoomName endPoint =
        let url = link (Vote votingRoomName)
        Content.WithTemplate Templating.MainTemplate
          { browserTitle = "Manage voting room - TwoThumbsUp"
            title = [Text "Manage "; ahref url url]
            content = [] }
    
    let VotePage votingRoomName endPoint = async {
        let! votingRoom = AppState.postMessageAndReply votingRoomName RetrieveState
        match votingRoom with
        | Some(votingRoom) ->
            // WebSharper templating performs escaping for us
            return!
                Content.WithTemplate Templating.MainTemplate
                  { browserTitle = "Vote! - TwoThumbsUp"
                    title = [Text (sprintf "Vote in %s" (link (Vote votingRoomName)))]
                    content = [Div [ClientSide <@ Client.form_submitVote votingRoomName votingRoom @>]] }
        | None -> return! CreateVotePage votingRoomName endPoint }

    let ViewVotePage votingRoomName endPoint =
        Content.WithTemplate Templating.MainTemplate
         { browserTitle = "Results - TwoThumbsUp "
           title = [Text (sprintf "Viewing results in %s" votingRoomName)]
           content = [Div [ClientSide <@ Client.form_viewVote votingRoomName @>]] }

    let Controller =
        { Handle = fun action ->
            try
                let makePage =
                    match action with
                    | NotFound url -> NotFoundPage
                    | Index -> IndexPage
                    | Vote roomName -> VotePage roomName
                    | ManageVote roomName -> ManageVotePage roomName
                    | ViewVote roomName -> ViewVotePage roomName
                
                Content.FromContext (fun ctx -> makePage action)
                |> Content.FromAsync
            with e ->
                printfn "500 internal server error: %A" (e.ToString ())
                reraise () }
    
    let MainSitelet =
      { Router = Router.New route (fun x -> Some(new Uri(link x, UriKind.Relative)))
        Controller = Controller }

open System.Net.NetworkInformation
open System.Net.Sockets

module Main =
    [<EntryPoint>]
    let main args =
        let hosts =
            if args.Length > 0 then
                Array.toList args
            else
                let localIp =
                    NetworkInterface.GetAllNetworkInterfaces ()
                    |> Seq.tryPick (fun netInterface ->
                        match netInterface.NetworkInterfaceType with
                        | NetworkInterfaceType.Wireless80211 | NetworkInterfaceType.Ethernet ->
                            netInterface.GetIPProperties().UnicastAddresses
                            |> Seq.tryPick (fun addrInfo ->
                                if addrInfo.Address.AddressFamily = AddressFamily.InterNetwork then Some(string addrInfo.Address) else None)
                        | _ -> None)
                List.choose id [localIp; Some "localhost"] |> List.map (fun host -> host + ":8080")
        let urls = hosts |> List.map (fun host -> "http://" + host)
        WebSharper.Warp.RunAndWaitForInput (Site.MainSitelet, urls = urls, debug = true)