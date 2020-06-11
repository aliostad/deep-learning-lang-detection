module Program

open System.Net
open System.IO
open FSharp.Http
open FsWeb.Domain

let boxedList list =
  seq [| for key, value in list -> 
          [| box key; box value |] |> box |] 
  |> box |> Some

let apiController (ctx:HttpListenerContext) =
  match ctx.Request.Url.LocalPath with
  | "/api/dashboard/productsInCategories" -> 
      boxedList (Analytics.countProductsInCategories Data.categories)
  | "/api/dashboard/salesByOperator" -> 
      boxedList (Analytics.salesByOperator Data.history)
  | "/api/dashboard/purchasedByCategory" -> 
      boxedList (Analytics.purchasedByCategory Data.history)
  | "/api/dashboard/moneySpentByCategory" -> 
      boxedList (Analytics.moneySpentByCategory Data.history)
  | _ -> None
 
[<EntryPoint>]
do
  let root = __SOURCE_DIRECTORY__
  let url = sprintf "http://localhost:8888/"
  let server = 
    HttpServer.Start(url, Path.Combine(root, "..\\Web"), apiController)
  printfn "Starting web server at %s" url
  System.Diagnostics.Process.Start(url) |> ignore
  System.Console.ReadLine() |> ignore
  server.Stop()  
