namespace FsWeb.Controllers

open System
open System.Web
open System.Web.Mvc
open System.Net.Http
open System.Web.Http

open Model
open FsWeb.Data.DataSource
open FsWeb.Data.DataRecord
open FsWeb.Repositories
open Repository

type CategoriesController() =
    inherit ApiController()
    
    let db = dbSchema.GetDataContext()
    let fromRepository = db.Lc_Category |> Repository.get 

    // GET /api/values
    member x.Get() = getAll toCategoryInfo |> fromRepository  <| withCacheKeyOf("AllCategories")

    // GET /api/values/5
    //    member x.Get (id:int) = "value"
    // POST /api/values
    member x.Post ([<FromBody>] value: CategoryInfo) = ()
//    // PUT /api/values/5
//    member x.Put (id:int) ([<FromBody>] value:string) = ()
//    // DELETE /api/values/5
//    member x.Delete (id:int) = ()


