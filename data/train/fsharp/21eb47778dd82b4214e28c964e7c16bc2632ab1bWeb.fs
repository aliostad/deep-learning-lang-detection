module Cart.Web

open System.Collections.Generic
open System
open Suave                 // always open suave
open Suave.Successful      // for OK-result
open Suave.Web             // for config
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.WebSocket
open Serializer
open Cart
open Cart.Data
open EventSocket
open Chiron

// TODO: refactore all
let store = InMemoryEventStore()
let productRepo = MockProductRepository() :> IProductRepository
let mgr = CartManager(store,productRepo)
let cmdApi = CommandApi.CommandApiClient(mgr)

mgr.Publish.Subscribe (printfn "new event %O") |> ignore



let getProducts r = 
  productRepo.GetAll() |> JSON
let getProduct id =
  match productRepo.GetById id with
  | Some p -> p |> JSON
  | None -> Suave.RequestErrors.NOT_FOUND "product not found"
  
let cartApp = 
  choose [
    path "/cart/ws" >=> handShake (eventSocket mgr.Publish)
    GET >=> choose [
      pathScan "/cart/product/%i" getProduct
      path "/cart/products"  >=> request getProducts
    ]
    POST >=> choose [
      path "/cart/create" >=> cmdApi.Create
      path "/cart/add" >=> cmdApi.AddProduct
      path "/cart/setqty" >=> cmdApi.SetQty
      path "/cart/remove" >=> cmdApi.RemoveProduct
      path "/cart/commit" >=> cmdApi.Commit
    ]
  ]
 
//startWebServer defaultConfig app
