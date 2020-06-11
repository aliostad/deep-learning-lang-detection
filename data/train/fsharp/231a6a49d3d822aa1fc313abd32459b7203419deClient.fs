namespace ProcessSample

open WebSharper
open WebSharper.UI.Next
open WebSharper.UI.Next.Client
open Chrisjdobson.WebSharper.SignalR

[<JavaScript>]
module Client =

    let Main () =
        let processes = ListModel.Create (fun p -> p.Id)[]

        Connection.New()
            |> Connection.Start(StartupConfig()) (fun _ -> ()) (fun _ -> ())

        let s = SignalR.New("processesHub")
        s
            |> SignalR.Receive<seq<Process>> "processes" (fun ps -> 
                processes.Clear()
                ps |> Seq.iter (fun p -> processes.Add p))
            |> ignore

        let renderProcess (p : Process) = 
            Doc.Element "tr" [] [
                Doc.Element "td" [] [Doc.TextNode (p.Id.ToString())]
                Doc.Element "td" [] [Doc.TextNode p.Name]
                Doc.Element "td" [] [Doc.TextNode p.Machine]
                Doc.Element "td" [] [Doc.TextNode (p.Started.ToString())]
            ]

        let processList = 
            Doc.Element "table" [Attr.Class "table table-striped table-hover"] [
                Doc.Element "thead" [] [
                    Doc.Element "tr" [] [
                        Doc.Element "th" [] [Doc.TextNode "Process Id"]
                        Doc.Element "th" [] [Doc.TextNode "Process Name"]
                        Doc.Element "th" [] [Doc.TextNode "Machine Name"]
                        Doc.Element "th" [] [Doc.TextNode "Started"]
                    ]
                ]
                Doc.Element "tbody" [] [
                    ListModel.View processes |> Doc.BindSeqCachedBy (fun p -> p.Id) (renderProcess)
                ]
            ]

        processList
