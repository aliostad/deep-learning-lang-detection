module FigContactManager.Web.Views

open System
open System.Xml.Linq
open FSharpx
open FigContactManager.Web.Routes
open Formlets
open WingBeats
open WingBeats.Xhtml
open WingBeats.Xml
open WingBeats.Formlets
open FigContactManager.Model

let e = XhtmlElement()
let s = e.Shortcut
let f = e.Formlets

let makeTable entities (proj: (string * (_ -> Node list)) list) = 
    let text t = &t
    let header = proj |> Seq.map (fst >> text >> List.singleton >> e.Th) |> e.Tr
    let makeRow g = proj |> Seq.map (snd >> (|>) g >> e.Td) |> e.Tr
    let rows = entities |> Seq.map makeRow |> Seq.toList
    e.Table (header::rows)

let layout title (body: Node list) = 
    [e.Html [
        e.Head [
            e.Title [ &title ]
        ]
        e.Body body
    ]]

let inline submit text = 
    e.Input ["type","submit"; "value", text]

let inline ihidden (name, value) = 
    e.Input ["type","hidden"; "name",name; "value",value]

let inline postForm url content = 
    e.Form ["method","post"; "action",url] content

let inline simplePostForm url text = 
    postForm url [ submit text ]

let postFormlet text url formlet =
    postForm url [
        yield! !++ formlet
        yield submit text
    ]

let link text url = e.A ["href", url] [ &text ]

let groupsView (groups: Group seq) error = 
    layout "Manage contact groups"
        [
            makeTable groups [
                "Group name", fun c -> [ &c.Name ]
                "", fun c -> [ postFormlet "Delete" (mapWebPostRoute DeleteGroup) (pickler c.Id) ]
                "", fun c -> [ link "Edit" (mapWebGetRoute (EditGroup c.Id)) ]
            ]
            e.P [ &error ]
        ]

let idVersionFormlet (idVersion: int64 * int64) = pickler idVersion
let emptyIdVersionFormlet = idVersionFormlet (0L,0L)

let contactsView (contacts: Contact seq) error = 
    layout "Manage contacts"
        [
            makeTable contacts [
                "Name", fun c -> [ &c.Name ]
                "Email", fun c -> [ &c.Email ]
                "Phone", fun c -> [ &c.Phone ]
                "", fun c -> [ postFormlet "Delete" (mapWebPostRoute DeleteContact) (idVersionFormlet (c.Id, c.Version)) ]
                "", fun c -> [ link "Edit" (mapWebGetRoute (EditContact c.Id)) ]
            ]
            e.P [ &error ]
        ]

let contactFormlet (c: Contact) =
    let idVersion = idVersionFormlet (c.Id, c.Version)
    let nameInput = f.Text(c.Name, required = true) |> f.WithLabel "Name"
    let phoneAndEmail = 
        let phoneInput = f.Tel(c.Phone) |> f.WithLabel "Phone:"
        let emailInput = f.Email(c.Email) |> f.WithLabel "Email:"
        let phoneAndEmail = yields tuple2 <*> phoneInput <*> emailInput
        let nonEmpty = String.IsNullOrWhiteSpace >> not
        let oneNonEmpty (a,b) = nonEmpty a || nonEmpty b
        phoneAndEmail |> satisfies (err oneNonEmpty (fun _ -> "Enter either a phone or an email"))

    yields (fun (i,v) n (p,e) -> { Contact.Id = i; Version = v; Name = n; Phone = p; Email = e; User = c.User })
    <*> idVersion
    <*> nameInput
    <*> phoneAndEmail

let groupFormlet (c: Group) =
    let nameInput = f.Text(c.Name, required = true) |> f.WithLabel "Name"

    yields (fun i n -> { Group.Id = i; Name = n; User = c.User })
    <*> pickler c.Id
    <*> nameInput

let saveView url title err (n: XNode list) =
    layout title
        [
            s.FormPost url [
                yield!!+ n
                yield e.P [ submit "Save" ]
                yield e.P [ &err ]
            ]
        ]

[<AbstractClass>]
type 'a CRUDViews(routes: CRUDRoutes) =
    abstract Dummy: 'a
    abstract EditFormlet: ('a -> 'a Formlet)
    abstract ShowView: ('a seq -> string -> Node list)
    member x.Name = typeof<'a>.Name
    member x.EmptyEditFormlet = x.EditFormlet x.Dummy
    member x.WriteView = saveView (mapWebPostRoute routes.Save)
    member x.EditView = x.WriteView (sprintf "Edit %s" x.Name)
    member x.EditOkView = x.EditView ""
    member x.NewView = x.WriteView (sprintf "New %s" x.Name) ""

let groupViews = 
    { new CRUDViews<Group>(groupRoutes) with
        override x.Dummy = Group.Dummy
        override x.EditFormlet = groupFormlet
        override x.ShowView = groupsView }

let contactViews = 
    { new CRUDViews<Contact>(contactRoutes) with
        override x.Dummy = Contact.Dummy
        override x.EditFormlet = contactFormlet
        override x.ShowView = contactsView }
