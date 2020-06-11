module FigContactManager.Web.Actions

open System
open System.Xml.Linq
open System.Web.Mvc
open FSharpx
open FSharpx.Reader
open Figment
open FigContactManager
open FigContactManager.Model
open FigContactManager.Web.Views
open FigContactManager.Web.Routes
open Formlets

type RouteAndAction = {
    Route: RouteConstraint
    Action: FAction
}

type RouteAndDbAction = {
    Route: RouteConstraint
    DbAction: Sql.ConnectionManager -> FAction
} with 
    static member ToRouteAndAction cmgr (r: RouteAndDbAction) =
        { Route = r.Route
          Action = r.DbAction cmgr }


get "/" (redirectR AllContacts)
let errorUrl = Error "" |> mapWebGetRoute |> baseUrl
get errorUrl (fun ctx -> contentf "<pre>%s</pre>" ctx.QueryString.["e"] ctx)

let manage findAll view =
    let view = findAll() >> Tx.get >> view
    fun cmgr ->
        getFlash >>= fun err -> view cmgr err |> wbview

let error a = 
    redirectR (Error (sprintf "%A" a))

let delete name allRoute deleteEntity formlet cmgr = 
    runPost formlet
    >>= function
        | Formlet.Success x -> 
            match deleteEntity x cmgr with
            | Tx.Commit (Some _) -> redirectR allRoute
            | Tx.Commit None -> 
                sprintf "%s previously deleted or modified" name |> setFlash >>. redirectR allRoute
            | Tx.Rollback a -> error a
            | Tx.Failed e -> error e
        | Formlet.Failure (_, errors) -> error errors

let getIdFromQueryString : ControllerContext -> int option =     
    getQueryString "id" |> Reader.map (Option.bind Int32.parse)

let edit name getById editFormlet view cmgr = 
    getIdFromQueryString
    |> Reader.map (Option.bind (fun i ->
                                match getById i cmgr with
                                | Tx.Commit c -> c
                                | _ -> None))
    |> Reader.map (Option.map (fun c -> 
                                let editForm = editFormlet c |> renderToXml
                                let view = view editForm
                                wbview view))
    |> Reader.bind (Option.getOrElse (error (sprintf "%s not found" name)))

let save name formlet upsert allRoute editView editOkView cmgr = 
    runPost formlet
    >>= function
        | { Form = populatedForm; Value = Some entity } -> 
            match upsert entity cmgr with
            | Tx.Commit (Some _) -> redirectR allRoute
            | Tx.Commit None -> 
                let msg = sprintf "%s deleted or modified, please go back and reload" name
                wbview (editView msg populatedForm)
            | _ -> error "DB Error"
        | { Form = errorForm; Value = None } -> wbview (editOkView errorForm)

[<AbstractClass>]
type AbstractCRUDActions<'a, 'b>(views: 'a CRUDViews, routes: CRUDRoutes) =
    abstract FindAll: (unit -> Sql.ConnectionManager -> Tx.TxResult<'a seq, _>)
    abstract GetById: (_ -> Sql.ConnectionManager -> Tx.TxResult<'a option, _>)
    abstract DeleteEntity: ('b -> Sql.ConnectionManager -> Tx.TxResult<unit option, _>)
    abstract Upsert: ('a -> Sql.ConnectionManager -> Tx.TxResult<'a option, _>)
    abstract DeleteFormlet: 'b Formlet
    member x.Manage = 
        { Route = getPathR routes.All
          DbAction = manage x.FindAll views.ShowView }
    member x.Delete = 
        { Route = postPathR routes.Delete
          DbAction = delete views.Name routes.All x.DeleteEntity x.DeleteFormlet }
    member x.Edit = 
        let action = edit views.Name x.GetById views.EditFormlet views.EditOkView
        { Route = getPathR (routes.Edit 0L)
          DbAction = fun c -> noCache >>. action c }
    member x.Save =
        { Route = postPathR routes.Save
          DbAction = save views.Name views.EmptyEditFormlet x.Upsert routes.All views.EditView views.EditOkView }
    member x.New = 
        { Route = getPathR routes.New
          Action = views.EmptyEditFormlet |> renderToXml |> views.NewView |> wbview }

let contactActions' = 
    { new AbstractCRUDActions<_,_>(contactViews, contactRoutes) with
        override x.FindAll = Contact.FindAll
        override x.GetById = Contact.GetById
        override x.DeleteEntity = Contact.DeleteCascade
        override x.Upsert = Contact.Upsert
        override x.DeleteFormlet = emptyIdVersionFormlet }
    
let groupActions' = 
    { new AbstractCRUDActions<_,_>(groupViews, groupRoutes) with
        override x.FindAll = Group.FindAll
        override x.GetById = Group.GetById
        override x.DeleteEntity = Group.DeleteCascade
        override x.Upsert = Group.Upsert
        override x.DeleteFormlet = pickler 0L }

type CRUDActions = {
    Manage: RouteAndAction
    Delete: RouteAndAction
    Edit: RouteAndAction
    Save: RouteAndAction
    New: RouteAndAction
}

let abstractToConcreteCRUDActions (a: AbstractCRUDActions<_,_>) cmgr =
    { Manage = RouteAndDbAction.ToRouteAndAction cmgr a.Manage
      Delete = RouteAndDbAction.ToRouteAndAction cmgr a.Delete
      Edit = RouteAndDbAction.ToRouteAndAction cmgr a.Edit
      Save = RouteAndDbAction.ToRouteAndAction cmgr a.Save
      New = a.New }

let crudActionsToList (a: CRUDActions) = 
    [a.Manage; a.Delete; a.Edit; a.Save; a.New]

let abstractCRUDToActionList a b = abstractToConcreteCRUDActions a b |> crudActionsToList

let contactActions = abstractCRUDToActionList contactActions'
let groupActions = abstractCRUDToActionList groupActions'