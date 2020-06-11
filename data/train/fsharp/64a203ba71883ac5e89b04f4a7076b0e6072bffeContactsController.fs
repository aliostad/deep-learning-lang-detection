namespace Clunch.Controllers

open System
open System.Web.Http
open System.Linq
open Raven.Client
open Raven.Abstractions.Commands
open Clunch.Models
open Clunch

type ContactsController(session) =
    inherit RavenApiController(session)

    // GET /api/contacts
    member x.Get() =
        (query {
            for contact in session.Query<Contact>() do
            sortBy contact.FirstName 
            select contact
        }).ToListAsync()

    // GET /api/contacts/1
    member x.Get(id:int) =
        session.LoadAsync<Contact>(id)

    // POST /api/contacts
    member x.Post ([<FromBody>] contact:Contact) = 
        async {
            do! session.AsyncStore(contact)
            return contact
        } |> Async.StartAsTask

    // DELETE /api/contacts/1
    member x.Delete (id:int) =
        session.Advanced.Defer(DeleteCommandData(Key = sprintf "contacts/%i" id))
