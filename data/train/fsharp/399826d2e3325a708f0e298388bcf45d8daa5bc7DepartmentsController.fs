namespace FsWeb.Controllers

open System.Web
open System.Web.Mvc
open System.Net.Http
open System.Web.Http
open Model
open FsWeb.Data.DataSource
open FsWeb.Data.DataRecord
open FsWeb.Repositories
open Repository

type DepartmentsController() =
    inherit ApiController()

    let db = dbSchema.GetDataContext()

    let catRepository = db.Lc_Category |> Repository.get 
    let LoadCat = getAll toCategoryInfo |> catRepository  <| withCacheKeyOf("AllCategories")

    let fromRepository = db.Lc_Department |> Repository.get 
    let Load = getAll (fun x -> toDepartmentInfo x LoadCat) |> fromRepository  <| withCacheKeyOf("AllDepartments")

    // GET /api/values
    member x.Get() = Load
//    // GET /api/values/5
//    member x.Get (id:int) = "value"
//    // POST /api/values
//    member x.Post ([<FromBody>] value:string) = ()
//    // PUT /api/values/5
//    member x.Put (id:int) ([<FromBody>] value:string) = ()
//    // DELETE /api/values/5
//    member x.Delete (id:int) = ()

