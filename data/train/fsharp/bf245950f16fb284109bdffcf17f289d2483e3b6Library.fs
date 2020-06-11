namespace Harmful

module Types =
    type IItem =
        abstract member Text : string
//        abstract member Icon : Unit option
    and Search = Search of string list
    and [<AbstractClass>] IProvider() =
        abstract member Search: Search -> Async<IItem seq>
        abstract member Exec: IItem -> Command
    and Command = Exec of string list

module Commands =
    open System.Diagnostics
    open Types

    let exec cmd =
        match cmd with
        | Exec cmds ->
            let _ = Process.Start (ProcessStartInfo(cmds.Head, String.concat " " cmds.Tail))
            ()

module Fogbugz =
    open Types
    type CaseItem = { case:int
                      title:string }
    with
        interface IItem with
            member x.Text = sprintf "Case %i: %s" x.case x.title
//            member x.Icon = None

    type ActionITem = { action:string
                        arg:string
                        f: string -> Command }
    with
        interface IItem with
            member x.Text = sprintf "%s: %s" x.action x.arg

    module Api =
        type LoginProvider = FSharp.Data.XmlProvider<"""<?xml version="1.0" encoding="UTF-8"?><response><token><![CDATA[82ovqq2bb0ulvsjgitaohf8ugu52gs]]></token></response>""">
        type CaseProvider = FSharp.Data.XmlProvider<"""<?xml version="1.0" encoding="UTF-8"?>
    <response>
        <cases count="1">
            <case ixBug="806120" operations="edit,assign,resolve,reply,forward,remind">
                <sTitle><![CDATA[title]]></sTitle>
            </case>
            <case ixBug="123456"/>
        </cases>
    </response>""">
        open FSharp.Data
        type t = { url: string; token: string }
        let from s : t = { url = s; token = "" }

        let login(u:string)(p:string)(api:t) =
            let resp = Http.RequestString(api.url, query=["cmd","logon";"email",u;"password",p])
            let xmlP = LoginProvider.Parse(resp)
            { api with token = xmlP.Token }
        let search (id:int) (api:t) =
            async {
                let qparams = [ "token", api.token
                                "cmd","search"
                                "q",id.ToString()
                                "cols", "sTitle"
                                "max", "50"]
                printf "\nSearching: %A" id
                let! resp = Http.AsyncRequestString(api.url, query=qparams)
                printf "\nSearch: %A" resp
                let cases = CaseProvider.Parse resp
                return seq { for c in cases.Cases.Cases do
                                 yield { case = c.IxBug
                                         title = defaultArg c.STitle "" }
                }
            }

    type Config = { apiUrl:string
                    user:string
                    password:string }
    type Provider(c:Config) =
        inherit IProvider()
        let init() =
            let api = Api.from c.apiUrl
            api |> Api.login c.user c.password //|> Async.star
        let api = init()
        let searchFmt = "http://fogbugz.unity3d.com/default.asp?pre=preMultiSearch&pg=pgList&pgBack=pgSearch&search=2&searchFor="
        let searchAction tokens =
            { action="Search"
              arg = String.concat " " tokens
              f = fun a -> Exec [sprintf "%s%s" searchFmt a] } :> IItem
        override x.Search(Search tokens) : Async<seq<IItem>> =
            let search = searchAction tokens :: []
            async {
                let case =
                    match tokens with
                        | "case" :: s :: []  ->
                            match System.Int32.TryParse s with
                            | true,i ->
                                Some <| async {
//                                        let! _ = Async.Sleep 3000
                                    let! cases = api |> Api.search i
                                    return cases
                                }
                            | _ -> None
                        | _ -> None
                match case with
                | None -> return search |> Seq.ofList
                | Some casesAsync ->
                    let! cases = casesAsync
                    let cases = cases |> Seq.cast<IItem> |> List.ofSeq
                    return List.append cases search |> Seq.ofList
            }
        override x.Exec i =
            match i with
            | :? CaseItem as ci -> Exec [sprintf "http://fogbugz.unity3d.com/default.asp?%i" ci.case ]
            | :? ActionITem as i -> i.f i.arg

//module Caching =
//    open System.Runtime.Caching
//
//    type t = private { impl: MemoryCache }
//    let empty (name:string) = { impl = new MemoryCache(name) }
//    let add k v t = t.impl.